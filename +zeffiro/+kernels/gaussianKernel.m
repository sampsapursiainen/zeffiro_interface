function kernel = gaussianKernel(kwargs)
%
%   kernel = gaussianKernel(data,kwargs)
%
% Generates a Gaussian kernel of dimensions determined
% by size of kwargs.samples along the given dimensions.
%

    arguments
        kwargs.samples (1,:) double { mustBePositive, mustBeInteger }
    end

    dimensionMidpoints = (kwargs.samples) / 2 + 1 / 2 ;

    axisN = numel(kwargs.samples) ;

    stepSizes = 2 * pi ./ (kwargs.samples - 1) ;

    axes = cell(axisN,1) ;

    for ii = 1 : axisN

        samples = kwargs.samples(ii) ;

        stepSize = stepSizes(ii) ;

        axes{ii} = (- pi : stepSize : pi) ; ... - dimensionMidpoints(ii) ;

    end % for

    axes

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

    scalingFactor = 1 ./ sqrt(2 * pi) ;

    kernel = scalingFactor * exp( -  ( (X .^ 2) + (Y .^ 2) + (Z .^ 2) ) / 2 ) ;

end % function
