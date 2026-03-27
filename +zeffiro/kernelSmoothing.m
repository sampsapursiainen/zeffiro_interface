function smoothedField = kernelSmoothing(centerPositions, fieldPositions, field, kwargs)
%
%   smoothedField = kernelSmoothing(centerPositions, fieldPositions, field, kwargs)
%
% Smooths a given vector field using a Gaussian kernel function.
%
% Arguments:
%
%   centerPositions (3,:) double { mustBeFinite }
%
% The center positions of the Gaussian kernels.
%
%   fieldPositions (3,:) double { mustBeFinite }
%
% Positions that a field is evaluated at.
%
%   field (3,:) double { mustBeFinite }
%
% The field that is to be smoothed.
%
%   kwargs.variances (3,:) double { mustBeFinite } = ones(size(centerPositions))
%
% The widths squared of the wanted kernel functions.
%

    arguments
        centerPositions (3,:) double { mustBeFinite }
        fieldPositions (3,:) double { mustBeFinite }
        field (3,:) double { mustBeFinite }
        kwargs.variances (3,:) double { mustBeFinite } = ones(size(centerPositions))
    end

    kernels = zeffiro.kernels.gaussianKernel(centerPositions, fieldPositions, kwargs.variances);

    smoothedField = field * kernels ;

end % function
