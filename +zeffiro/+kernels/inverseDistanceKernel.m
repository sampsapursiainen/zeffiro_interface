function [kernel, nonZeroCols] = inverseDistanceKernel(centerPoints, dataPoints, latticeUnit, power, kwargs)
%
%   [kernel, nonZeroCols] = gaussianKernel(centerPoints, dataPoints, latticeUnit, power, kwargs)
%
% Generates a matrix of kernels based on given kernel centroids, data points and latticeUnit.
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
%   latticeUnit (1,1) double {mustBeFinite, mustBePositive}
%
% The distance around the kernel after which the inverse distance should not be considered,
% but this unit should be used as the value of the kernel instead. Gets rid of the singularity
% that follows from dividing by zero distance.
%
% If a lattice or mesh has a resolution of 1, then it might make sense to set this to 1 as well.
%
%   power (1,1) double {mustBeFinite, mustBePositive}
%
% The power that the inverse distance kernel denominator is raised to.
%
%   kwargs.filterZeroColumns (1,1) logical = true
%
% Whether to filter out zero columns that might occur when
% the latticeUnits of the kernels are not large enough in relation
% to the distances between kernel centers and the data points.
%

    arguments (Input)
        centerPoints (:,:) double { mustBeFinite }
        dataPoints (:,:) double { mustBeFinite }
        latticeUnit (1,1) double {mustBeFinite, mustBePositive}
        power (1,1) double { mustBeInteger, mustBePositive }
        kwargs.filterZeroColumns (1,1) logical = true
    end

    arguments (Output)
        kernel (:,:) double { mustBeFinite }
        nonZeroCols (1,:) double { mustBeFinite  }
    end

    [kernelDimension, centerN] = size(centerPoints) ;

    [dataDimension, dataN] = size(dataPoints) ;

    assert( ...
        kernelDimension == dataDimension, ...
        "gaussianKernel: The dimensionality of the center points needs to match that of the data points." ...
    )

    repeatedCenterPoints = repelem(centerPoints,1, dataN) ;

    repeatedLatticeUnit = repelem(latticeUnit, 1, dataN * centerN) ;

    repeatedDataPoints = repmat(dataPoints, 1, centerN) ;

    repeatedDiffs = repeatedDataPoints - repeatedCenterPoints ;

    repeatedNorms = vecnorm(repeatedDiffs) ;

    kernel1 = repeatedLatticeUnit .^ power ./ (repeatedLatticeUnit .^ power +  abs(repeatedNorms) .^ power ) ;

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
