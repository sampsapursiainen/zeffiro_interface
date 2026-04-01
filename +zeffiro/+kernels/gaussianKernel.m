function [kernel, nonZeroCols] = gaussianKernel(centerPoints, dataPoints, variances)
%
%   [kernel, nonZeroCols] = gaussianKernel(centerPoints, dataPoints, variances, kwargs)
%
% Generates a matrix of Gaussian kernels based on given kernel centroids, data points and variances.
% The output has the dimensions of dataPoints * centerpoints * variances.
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

    arguments (Input)
        centerPoints (:,:) double { mustBeFinite }
        dataPoints (:,:) double { mustBeFinite }
        variances (:,:) double { mustBeFinite, mustBePositive }
    end

    arguments (Output)
        kernel (:,:,:) double { mustBeFinite }
        nonZeroCols (1,:,:) double { mustBeFinite }
    end

    [centerN, kernelDimension] = size(centerPoints) ;

    [dataN, dataDimension] = size(dataPoints) ;

    [varianceN, varianceDimension] = size(variances) ;

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

    repeatedCenterPoints = repelem(centerPoints, dataN, 1) ;

    repeatedVariances = repelem(variances, dataN, 1) ;

    repeatedDataPoints = repmat(dataPoints, centerN, 1) ;

    repeatedDiffs = repeatedDataPoints - repeatedCenterPoints ;

    repeatedNormsSquared = dot(repeatedDiffs, repeatedDiffs, 2) ;

    kernel1 = exp( - repeatedNormsSquared ./ 2 ./ repeatedVariances ) ;

    kernel2 = reshape(kernel1, dataN, centerN, varianceDimension) ;

    columnSums = sum(kernel2, 1) ;

    kernel = kernel2 ./ columnSums ;

end % function
