function [nP, nPI] = rangeSearch (refSet,neighbourSet, range)
%
% [nP, nPI] = rangeSearch (refSet, neighbourSet, range)
%
% Searches for data points nP and their unique indices nPI from neighbourSet
% that are within a given distance from refSet. Note that data points are
% given as COLUMNS of the input arrays, unlike with MATLAB's own rangesearch.
%
% Inputs:
%
% - refSet
%
%   The reference set which we are comparing neighbourSet to.
%
% - neighbourSet
%
%   The set we are searching points from.
%
% - range
%
%   The range within which the points in neighbourSet need to be from
%   refSet, so that
%

    arguments
        refSet       (:,:) double { mustBeFinite }
        neighbourSet (:,:) double { mustBeFinite }
        range        (1,1) double { mustBeNonnegative, mustBeFinite }
    end

    % Get numbers of coordinates and points.

    Ncc = size ( refSet, 1 ) ;

    Nnc = size ( neighbourSet, 1 ) ;

    Ncp = size ( refSet, 2 ) ;

    Nnp = size ( neighbourSet, 2 ) ;

    assert ( Ncc == Nnc, "The dimensions of current and neighbouring points need to be the same. Now current set has " + Ncc + " coordinates, and the neighbour set has " + Nnc + "." )

    % Repeat matrices so we have a Cartesian product or all combinations of
    % point pairs from both sets.

    repRefSet = repmat ( refSet, 1, Nnp ) ;

    repNeighbourSet = repelem ( neighbourSet, 1, Ncp ) ;

    % Compute distances between the points, assuming the points are as columns
    % of the input arrays. Also reshape the distance array as 3D, so that it
    % becomes easy to use logical operations to determine which points are
    % within the given distance.

    dist = sqrt ( sum ( ( repNeighbourSet - repRefSet ) .^ 2 , 1 ) ) ;

    dist = reshape ( dist, 1, Nnp, Ncp ) ;

    % Find which distances are within the given range value.

    dI = dist <= range ;

    % Find unique neighbour indices by collapsing the third dimension with any.

    nPI = any ( dI,  3 ) ;

    % The get unique points from neighbour set.

    nP = neighbourSet (:, nPI) ;

end % function
