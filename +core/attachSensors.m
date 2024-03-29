function [ newPos, newI ] = attachSensors ( senPos, nodePos, triInd, kwargs )
%
% [ newPos, newI ] = attachSensors ( senPos, triPos, triInd, kwargs )
%
% Computes new positions for a given set of sensors, such that they are
% attached to a given surface. Also returns the indices of the triangles that
% the sensors were attached to. What "attached" means depends on the given
% settings.
%
% Inputs:
%
% - sensors
%
%   A set of sensors with positions.
%
% - nodePos
%
%   The nodes that the electrodes are to be attached to.
%
% - triInd
%
%   Triples of indices indicating which nodePos belong to which triangles. This
%   can be empty, if distances to some form of triangles are not needed, and
%   all one cares about are the nodes.
%
% - kwargs.attachMode
%
%   The meaning of "attached". One of "nearestNode" or "nearestTriangleCentroid".
%

    arguments
        senPos (3,:) double { mustBeFinite }
        nodePos (3,:) double { mustBeFinite }
        triInd (3,:) uint64 { mustBePositive }
        kwargs.attachMode { mustBeMember( kwargs.attachMode, [ "nearestNode", "nearestTriangleCentroid" ] ) } = "nearestNode"
    end

    % Compute new positions based on attachment mode.

    if kwargs.attachMode == "nearestNode"

        [ newPos, newI ] = nearestNodeFn ( senPos, nodePos ) ;

    elseif kwargs.attachMode == "nearestTriangleCentroid"

        [ newPos, newI ] = nearestTriCentroidFn ( senPos, nodePos, triInd ) ;

    else

        error ( "Unknown attachMode " + kwargs.attachMode ) ;

    end

end % function

%% Helper functions

function [ newPos, minI ] = nearestNodeFn ( senPos, nodePos )
%
% Places the sensor positions at nearest mesh nodes.
%

    % Compute matrix sizes.

    Nn = size ( nodePos, 2 ) ;

    Ns = size ( senPos, 2 ) ;

    % Repeat matrices to compute differences in a vectorized manner.

    repSenPos = repelem ( senPos, 1, Nn ) ;

    repNodePos = repmat ( nodePos, 1, Ns ) ;

    % Compute differences between node and sensor positions and their norms.

    repDiffs = repNodePos - repSenPos ;

    repDiffNorms = sqrt ( sum ( repDiffs .^ 2, 1 ) ) ;

    % Reshape repDiffNorms to a 3D array to be able to compute sensorwise minimum easily.

    repDiffNorms = reshape ( repDiffNorms, 1, Nn, Ns ) ;

    % Find minimum distance indices and then extract nearest nodes.

    [ ~, minI ] = min ( repDiffNorms, [], 2 ) ;

    minI = minI (:) ;

    newPos = nodePos ( :, minI ) ;

end % function

function [ newPos, newI ] = nearestTriCentroidFn ( senPos, nodePos, triInd )
%
% Places the sensor positions at the nearest centroids of triangles.
%

    % Compute centroids and compute distances to them using them as the nodes.

    [ C, ~, ~, ~ ] = core.triangleCentroids ( nodePos, triInd ) ;

    [ newPos, newI ] = nearestNodeFn ( senPos, C, triInd ) ;

end % function
