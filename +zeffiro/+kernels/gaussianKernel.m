function kernel = gaussianKernel(centerPoints, dataPoints, variances)
%
%   kernel = gaussianKernel(centerPoints, dataPoints, variances)
%
% Generates a matrix of Gaussian kernels based on given kernel centroids, data points and variances.
% The output has the kernel values for each center point as its columns.
%
% Arguments:
%
%   centerPoints (:,:) double { mustBeFinite }
%
% The centers of the kernels to be produced.
%
%   dataPoints (:,:) double { mustBeFinite }
%
% The data points around the kernel.
%
%   variances (1,:) double {mustBeFinite, mustBePositive}
%
% The widths squared of each kernel.
%

    arguments
        centerPoints (:,:) double { mustBeFinite }
        dataPoints (:,:) double { mustBeFinite }
        variances (:,:) double {mustBeFinite, mustBePositive}
    end

    arguments (Output)
        kernel (:,:) double { mustBeFinite }
    end

    [kernelDimension, centerN] = size(centerPoints) ;

    [dataDimension, dataN] = size(dataPoints) ;

    [varianceDimension, varianceN] = size(variances) ;

    assert( ...
        varianceN == centerN, ...
        "gaussianKernel: The number of given variances did not match the number of kernel center points." ...
    )

    assert( ...
        kernelDimension == dataDimension, ...
        "gaussianKernel: The dimensionality of the center points needs to match that of the data points." ...
    )

    assert( ...
        varianceDimension == kernelDimension, ...
        "gaussianKernel: The number of components of kernel variances did not match that of the kernels themselves." ...
    )

    repeatedCenterPoints = repelem(centerPoints,1, dataN) ;

    repeatedVariances = repelem(variances, 1, dataN) ;

    repeatedDataPoints = repmat(dataPoints, 1, centerN) ;

    repeatedDiffs = repeatedDataPoints - repeatedCenterPoints ;

    repeatedNormsSquared = dot(repeatedDiffs, repeatedDiffs, 1) ;

    kernel1 = exp( - repeatedNormsSquared ./ 2 ./ prod(repeatedVariances, 1) ) ;

    kernel2 = reshape(kernel1, dataN, centerN) ;

    kernel = kernel2 ./ sum(kernel2, 1) ;

end % function
