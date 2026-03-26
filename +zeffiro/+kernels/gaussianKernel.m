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
        variances (1,:) double {mustBeFinite, mustBePositive}
    end

    [kernelDimension, centerN] = size(centerPoints) ;

    [dataDimension, dataN] = size(dataPoints) ;

    varianceN = numel(variances) ;

    assert( ...
        varianceN == centerN, ...
        "gaussianKernel: The number of given variances did not match the number of kernel center points." ...
    )

    assert( ...
        kernelDimension == dataDimension, ...
        "gaussianKernel: The dimensionality of the center points needs to match that of the data points." ...
    )

    repeatedCenterPoints = repelem(centerPoints,1, dataN) ;

    repeatedVariances = repelem(variances, 1, dataN) ;

    repeatedDataPoints = repmat(dataPoints, 1, centerN) ;

    repeatedDiffs = repeatedDataPoints - repeatedCenterPoints ;

    repeatedNormsSquared = dot(repeatedDiffs, repeatedDiffs,1) ;

    kernel1 = exp( - repeatedNormsSquared ./ 2 ./ repeatedVariances ) ;

    kernel = kernel1 ./ sum(kernel1, "all") ;

    kernel = reshape(kernel, dataN, centerN) ;

end % function
