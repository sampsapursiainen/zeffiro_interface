function [ newPos, newI ] = attachSensors ( sensorPositions, meshNodePositions, triangleIndices, kwargs )
%
% [ newPos, newI ] = attachSensors ( sensorPositions, triPos, triangleIndices, kwargs )
%
% Computes new positions for a given set of sensors, such that they are
% attached to a given surface. Also returns the indices of the triangles that
% the sensors were attached to. What "attached" means depends on the given
% settings.
%
% Inputs:
%
% - sensorPositions
%
%   A set of sensor positions.
%
% - meshNodePositions
%
%   The nodes that the electrodes are to be attached to.
%
% - triangleIndices
%
%   Triples of indices indicating which meshNodePositions belong to which triangles. This
%   can be empty, if distances to some form of triangles are not needed, and
%   all one cares about are the nodes.
%
% - kwargs.attachMode
%
%   The meaning of "attached". One of "nearestNode" or "nearestTriangleCentroid".
%

    arguments
        sensorPositions (3,:) double { mustBeFinite }
        meshNodePositions (3,:) double { mustBeFinite }
        triangleIndices (3,:) uint64 { mustBePositive }
        kwargs.attachMode { mustBeMember( kwargs.attachMode, [ "nearestNode", "nearestTriangleCentroid" ] ) } = "nearestNode"
    end

    % Compute new positions based on attachment mode.

    if kwargs.attachMode == "nearestNode"

        [ newPos, newI ] = nearestNodeFn ( sensorPositions, meshNodePositions ) ;

    elseif kwargs.attachMode == "nearestTriangleCentroid"

        [ newPos, newI ] = nearestTriCentroidFn ( sensorPositions, meshNodePositions, triangleIndices ) ;

    else

        error ( "Unknown attachMode " + kwargs.attachMode ) ;

    end

end % function

%% Helper functions

function [ newPos, minI ] = nearestNodeFn ( sensorPositions, meshNodePositions )
%
% Places the sensor positions at nearest mesh nodes.
%

    % Compute matrix sizes.

    Nn = size ( meshNodePositions, 2 ) ;

    Ns = size ( sensorPositions, 2 ) ;

    % Repeat matrices to compute differences in a vectorized manner.

    repSenPos = repelem ( sensorPositions, 1, Nn ) ;

    repNodePos = repmat ( meshNodePositions, 1, Ns ) ;

    % Compute differences between node and sensor positions and their norms.

    repDiffs = repNodePos - repSenPos ;

    repDiffNorms = sqrt ( sum ( repDiffs .^ 2, 1 ) ) ;

    % Reshape repDiffNorms to a 3D array to be able to compute sensorwise minimum easily.

    repDiffNorms = reshape ( repDiffNorms, 1, Nn, Ns ) ;

    % Find minimum distance indices and then extract nearest nodes.

    [ ~, minI ] = min ( repDiffNorms, [], 2 ) ;

    minI = minI (:) ;

    newPos = meshNodePositions ( :, minI ) ;

end % function

function [ newPos, newI ] = nearestTriCentroidFn ( sensorPositions, meshNodePositions, triangleIndices )
%
% Places the sensor positions at the nearest centroids of triangles.
%

    % Compute centroids and compute distances to them using them as the nodes.

    [ C, ~, ~, ~ ] = zeffiro.triangleCentroids ( meshNodePositions, triangleIndices ) ;

    [ newPos, newI ] = nearestNodeFn ( sensorPositions, C ) ;

end % function
