function smoothedField = kernelSmoothing(sourcePositions, field, kwargs)
%
%   smoothedField = kernelSmoothing(field, kernelFn, kwargs)
%
% Smooths a given vector field using a Gaussian kernel function.
%
% Arguments:
%
%   sourcePositions (3,:) double { mustBeFinite }
%
% Positions that a source is evaluated at.
%
%   field (3,:) double { mustBeFinite }
%
% The field that is to be smoothed.
%
%   kwargs.variances (1,3) double { mustBeFinite } = ones(size(sourcePositions))
%
% The widths squared of the wanted kernel functions.
%

    arguments
        sourcePositions (3,:) double { mustBeFinite }
        field (3,:) double { mustBeFinite }
        kwargs.variances (1,3) double { mustBeFinite } = ones(size(sourcePositions))
    end

    kernels = zeffiro.kernels.gaussianKernel(sourcePositions, sourcePositions, kwargs.variances);

    smoothedField = field * kernels ;

end % function
