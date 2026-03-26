function kernel = gaussianKernel(kwargs)
%
%   kernel = gaussianKernel(data,kwargs)
%
% Generates a Gaussian kernel of dimensions determined
% by size of kwargs.samples along the given dimensions.
%

    arguments
        kwargs.samples (1,:) double { mustBePositive, mustBeInteger }
        kwargs.standardDeviations (1,:) double { mustBeFinite, mustBePositive } = []
    end

    axisN = numel(kwargs.samples) ;

    axes = cell(axisN,1) ;

    deviationN = numel(kwargs.standardDeviations) ;

    maxDeviations = 3 ;

    if deviationN < maxDeviations

        missingDeviationN = maxDeviations - deviationN ;

        kwargs.standardDeviations(deviationN+1:deviationN+missingDeviationN) = ones(1,missingDeviationN) ;

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

    kernel = scalingFactor * exp( - ( ...
        (X .^ 2) / kwargs.standardDeviations(1) ...
        + ...
        (Y .^ 2) / kwargs.standardDeviations(2) ...
        + ...
        (Z .^ 2) / kwargs.standardDeviations(3) ...
    ) / 2 ) ;

    kernel = kernel / sum(kernel, "all") ;

end % function
