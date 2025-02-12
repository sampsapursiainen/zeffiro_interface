function obj = FitAdvGMM(positions, weight, k, varargin)
%FITGMDIST Fit a Gaussian mixture distribution to data.
%   GM = FITGMDIST(X,K) fits a Gaussian mixture distribution with K
%   components to the data in X.  X is an N-by-D matrix.  Rows of X
%   correspond to observations; columns correspond to variables. FITGMDIST
%   fits the model by maximum likelihood, using the
%   Expectation-Maximization (EM) algorithm.
%
%   FITGMDIST treats NaNs as missing data.  Rows of X with NaNs are
%   excluded from the fit.
%
%   GM = FITGMDIST(X,K, 'PARAM1',val1, 'PARAM2',val2, ...) allows you to
%   specify optional parameter name/value pairs to specify details of the
%   model and to control the iterative EM algorithm used to fit the model.
%   Parameters are:
%
%      'Start'                The method used to choose initial mean,
%                             covariance, and mixing proportion parameters
%                             for the Gaussian components. Choices are:
%
%                            'plus', select K observations from X as the
%                             initial component means by kmeans++
%                             algorithm. Initial mixing proportions are
%                             uniform. Initial covariance matrices for all
%                             components are diagonal, where the Jth
%                             element on the diagonal is the variance of
%                             X(:,J).(Default)  
%
%                             'randSample', to select K observations from X
%                             at random as the initial component means.
%                             The initial mixing proportions are uniform,
%                             and the initial covariance matrices for all
%                             components are diagonal, where the Jth
%                             element on the diagonal is the variance of
%                             X(:,J).
%
%                             As a vector of length N containing component
%                             indices, chosen from 1:K, for each
%                             observation in X.  The initial values for the
%                             mean and covariance of each component are the
%                             sample mean and covariance of the
%                             observations assigned to that component, and
%                             the initial values for the mixing proportions
%                             are the proportion of each component in the
%                             specified indices.
%
%                             A scalar structure S containing the initial
%                             parameter values in the following fields:
%                             S.mu: A K-by-D matrix specifying the initial
%                               mean of each component.
%                             S.Sigma: An array specifying the covariance
%                               matrix of each component.  S.Sigma is one
%                               of the following:
%                                A D-by-D-by-K array.  S.Sigma(:,:,J) is
%                                the initial covariance matrix of component
%                                J. 
%                                A 1-by-D-by-K array.  DIAG(S.Sigma(:,:,J))
%                                is the initial covariance matrix of
%                                component J.
%                                A D-by-D matrix contains the initial
%                                covariance matrix for all components.
%                                A 1-by-D vector.  Diag(S.Sigma) is the
%                                initial covariance matrix for all
%                                components.
%                             S.ComponentProportion: A 1-by-K vector
%                               specifying the initial mixing proportions
%                               of each component.  Default is uniform.
%
%      'Replicates'           A positive integer giving the number of times
%                             to repeat the fit, each with a new set of
%                             initial parameters.  FITGMDIST returns the
%                             fit with the largest likelihood.  Default
%                             number of replicates is 1.  A value larger
%                             than 1 requires the 'Start' input must be
%                             'randSample' or 'plus'.
%
%      'CovarianceType'       'diagonal' if the covariance matrices are
%                             restricted to be diagonal; 'full' otherwise.
%                             Default is 'full'
%
%      'SharedCovariance'     True if all the covariance matrices are
%                             restricted to be the same (pooled estimate);
%                             false otherwise.  Default is false.
%
%      'RegularizationValue'  A non-negative regularization value to be
%                             added to the diagonal of each covariance
%                             matrix to ensure that the  estimates are
%                             positive-definite.  Default is 0.
%
%      'ProbabilityTolerance' A non-negative scalar specifying tolerance
%                             for posterior probabilities. In each
%                             iteration, after the posterior probabilities
%                             are estimated, FITGMDIST sets any posterior
%                             probability that is not larger than the
%                             tolerance to zero. Using a non-zero tolerance
%                             may speed up FITGMDIST. The range is [0,
%                             1e-6]. Default is 1e-8.
%
%      'Options'              Options structure for the iterative EM
%                             algorithm, as created by STATSET.  The
%                             following STATSET parameters are used:
%
%                             'Display'  Level of display output.  Choices
%                                        are 'off' (Default), 'iter', and
%                                        'final'.
%                             'MaxIter'  Maximum number of iterations
%                                        allowed. Default is 100.
%                             'TolFun'   Positive number giving the
%                                        termination tolerance for the
%                                        log-likelihood function.  Default
%                                        is 1e-6.
%
%   Example:   Generate data from a mixture of two bivariate Gaussian
%              distributions and fit a Gaussian mixture model:
%                 mu1 = [1 2];
%                 Sigma1 = [2 0; 0 .5];
%                 mu2 = [-3 -5];
%                 Sigma2 = [1 0; 0 1];
%                 X = [mvnrnd(mu1,Sigma1,1000);mvnrnd(mu2,Sigma2,1000)];
%                 gmfit = fitgmdist(X,2);
%
%   See also GMDISTRIBUTION

%   Reference:  McLachlan, G., and D. Peel, Finite Mixture Models, John
%               Wiley & Sons, New York, 2000.

%   Copyright 2007-2017 The MathWorks, Inc.
%   Copyright 2008-2016 The MathWorks, Inc.

if nargin > 2
    [varargin{:}] = convertStringsToChars(varargin{:});
end

if nargin < 2
    error(message('stats:gmdistribution:TooFewInputs'));
end

if ~isscalar(k) || ~isnumeric(k) || ~isfinite(k) ...
         || k<1 || k~=round(k)
    error(message('stats:gmdistribution:BadK'));
end

[n, d] = size(positions);
if n <= d
    error('Too few source points in the target space. Consider lowering the reconstruction threshold value from the app''s window or check that the activity is not concentrated to one source position.')
end

if n <= k
    error(message('stats:gmdistribution:TooManyClusters'));
end

if n ~= size(weight,1)
    error('Number of source positions and weights do not match.')
end

% parse input and error check
pnames = {      'start' 'replicates'  'covariancetype' 'sharedcovariance'  'regularizationvalue'  'options' 'probabilitytolerance'};
dflts =  {      'plus'           1      'full'            false             0                     []         1e-8};
[start,reps, CovType,SharedCov, RegV, options,probtol,setflags,extraArgs] ...
    = internal.stats.parseArgs(pnames, dflts, varargin{:});

if  ~setflags.covariancetype || ~setflags.regularizationvalue
    pnames = {'covtype','regularize' };
    dflts = {'full'      zeros(1,1,'like',positions)};
    [CovType_oldinput,RegV_oldinput] = internal.stats.parseArgs(pnames, dflts, extraArgs{:});
    if ~setflags.covariancetype
        %if 'covariancetype' is not used, accept 'covtype' for backward compatibility
        CovType = CovType_oldinput;
    end
    if ~setflags.regularizationvalue
        RegV =  RegV_oldinput;
    end
end

options = statset(statset('gmdistribution'),options);

if ~isnumeric(reps) || ~isscalar(reps) || round(reps) ~= reps || reps < 1
    error(message('stats:gmdistribution:BadReps'));
end

if ~isnumeric(probtol) || ~isscalar(probtol)|| probtol >1e-6 || probtol<0
    error(message('stats:gmdistribution:BadProbTol'));
end


if ~isnumeric(RegV) || ~isscalar(RegV) || RegV < 0
    error(message('stats:gmdistribution:InvalidReg'));
end

varX = var(weight.*positions) + RegV;
I = find(varX < eps(max(varX)));
if ~isempty(I)
    error(message('stats:gmdistribution:ZeroVariance', num2str( I )));
end

if ischar(CovType)
    covNames = {'diagonal','full'};
    i = find(strncmpi(CovType,covNames,length(CovType)));
    if isempty(i)
        error(message('stats:gmdistribution:UnknownCovType', CovType));
    end
    CovType = i;
else
    error(message('stats:gmdistribution:InvalidCovType'));
end

if ~islogical(SharedCov)
    error(message('stats:gmdistribution:InvalidSharedCov'));
end

options.Display = find(strncmpi(options.Display, {'off','notify','final','iter'},...
    length(options.Display))) - 1;

try
    %========= ACTUAL GMM ===================
    [S,NlogL,optimInfo] =...
        AdvGMModeling4Rec(positions,weight,k,start,reps,CovType,SharedCov,RegV,options,probtol);

    % Store results in object
    %obj = gmdistribution;
    obj.NDimensions = d;
    obj.NComponents = k;
    obj.ComponentProportion = S.PComponents;
    obj.mu = S.mu;
    obj.Sigma = S.Sigma;
    obj.Converged = optimInfo.Converged;
    obj.Iters = optimInfo.Iters;
    obj.NlogL = NlogL;
    obj.SharedCov = SharedCov;
    obj.RegV = RegV;
    obj.ProbabilityTolerance = probtol;
    if CovType == 1
        obj.CovType = 'diagonal';
        if SharedCov
            nParam = obj.NDimensions;
        else
            nParam = obj.NDimensions * k;
        end
    else
        obj.CovType = 'full';
        if SharedCov
            nParam = obj.NDimensions * (obj.NDimensions+1)/2;
        else
            nParam = k*obj.NDimensions * (obj.NDimensions+1)/2;
        end

    end
    nParam = nParam + k-1 + k * obj.NDimensions;
    obj.BIC = 2*NlogL + nParam*log(n);
    obj.AIC = 2*NlogL + 2*nParam;

catch ME
    rethrow(ME) ;
end