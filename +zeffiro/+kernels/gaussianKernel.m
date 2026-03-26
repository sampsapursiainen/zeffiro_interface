function kernel = gaussianKernel(kwargs)
%
%   kernel = gaussianKernel(kwargs)
%
% Generates a Gaussian kernel of dimensions determined
% by size of kwargs.samples along the given dimensions.
%
% Arguments:
%
%   kwargs.samples (1,:) double { mustBePositive, mustBeInteger }
%
% The numbers of samples of the generated kernel along x-, y- and z-directions.
%
%   kwargs.variances (1,:) double { mustBeFinite, mustBePositive } = []
%
% The variances or widths squared of the generated kernel along each dimension.
%
%

    arguments
        kwargs.samples (1,:) double { mustBePositive, mustBeInteger }
        kwargs.variances (1,:) double { mustBeFinite, mustBePositive } = []
    end

    axisN = numel(kwargs.samples) ;

    axes = cell(axisN,1) ;

    varianceN = numel(kwargs.variances) ;

    maxVariances = 3 ;

    if varianceN < maxVariances

        missingDeviationN = maxVariances - varianceN ;

        kwargs.variances(varianceN+1:varianceN+missingDeviationN) = ones(1,missingDeviationN) ;

    end % if

    for ii = 1 : axisN

        samples = kwargs.samples(ii) ;

        axis = 1 : samples ;

        axisMean = mean(axis) ;

        axisStd = std(axis) ;

        standardAxis = (axis - axisMean) / axisStd ;

        axes{ii} = standardAxis ;

    end % for

    if axisN == 1

        X = axes{1} ;

        Y = zeros(size(X)) ;

        Z = zeros(size(Y)) ;

    elseif axisN == 2

        [X, Y] = meshgrid(axes{:}) ;

        Z = zeros(size(Y)) ;

    elseif axisN == 3

        [X, Y, Z] = meshgrid(axes{:}) ;

    else

        error("gaussianKernel: Unsupported dimensionality" + string(axisN) + " for output array.")

    end

    scalingFactor = 1 ;

    kernel = scalingFactor * exp( ...
        - (X .^ 2) / kwargs.variances(1) / 2 ...
        - (Y .^ 2) / kwargs.variances(2) / 2 ...
        - (Z .^ 2) / kwargs.variances(3) / 2 ...
    ) ;

    kernel = kernel / sum(kernel, "all") ;

end % function
