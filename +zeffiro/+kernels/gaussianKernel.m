function [kernel, nonZeroCols] = gaussianKernel(centerPoints, dataPoints, variances, kwargs)
%
%   [kernel, nonZeroCols] = gaussianKernel(centerPoints, dataPoints, variances, kwargs)
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
%   kwargs.filterZeroColumns (1,1) logical = true
%
% Whether to filter out zero columns that might occur when
% the variances of the kernels are not large enough in relation
% to the distances between kernel centers and the data points.
%

    arguments (Input)
        centerPoints (:,:) double { mustBeFinite }
        dataPoints (:,:) double { mustBeFinite }
        variances (:,:) double {mustBeFinite, mustBePositive}
        kwargs.filterZeroColumns (1,1) logical = true
    end

    arguments (Output)
        kernel (:,:) double { mustBeFinite }
        nonZeroCols (1,:) double { mustBeFinite  }
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

    kernel1 = exp( - repeatedNormsSquared ./ 2 ./ sum(repeatedVariances, 1) ) ;

    kernel2 = reshape(kernel1, dataN, centerN) ;

    columnSums = sum(kernel2, 1) ;

    nonZeroCols = columnSums > 0 ;

    kernel3 = kernel2 ;

    kernel3(:,nonZeroCols) = kernel3(:,nonZeroCols) ./ columnSums(nonZeroCols) ;

    if kwargs.filterZeroColumns

        kernel = kernel3(:,nonZeroCols) ;

    else

        kernel = kernel3 ;

    end % if

end % function
