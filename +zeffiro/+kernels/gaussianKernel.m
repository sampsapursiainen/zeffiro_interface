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

    axisN = numel(kwargs.samples) ;

    axes = cell(axisN,1) ;

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

    scalingFactor = 1 ./ sqrt(2 * pi) ;

    kernel = scalingFactor * exp( -  ( (X .^ 2) + (Y .^ 2) + (Z .^ 2) ) / 2 ) ;

end % function
