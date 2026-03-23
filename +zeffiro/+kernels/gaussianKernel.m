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

    axes = cell(axisN,1) ;

    for ii = 1 : axisN

        samples = kwargs.samples(ii) ;

        axes{ii} = (1 : samples) - dimensionMidpoints(ii) ;

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

    kernel = exp( - (X .^ 2) - (Y .^ 2) - (Z .^ 2) ) ;

end % function
