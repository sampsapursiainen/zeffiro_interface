function [ ...
    out_deep_nodes, ...
    out_deep_node_inds, ...
    out_deep_tetra, ...
    out_deep_tetra_inds ...
] = peelSourcePositions ( ...
    in_nodes, ...
    in_tetra, ...
    in_volume_inds, ...
    in_acceptable_depth_mm ...
)
%
% [ out_deep_nodes, out_deep_node_inds, out_deep_tetra, out_deep_tetra_inds ] = peelSourcePositions ( in_nodes, in_tetra, in_volume_inds, in_acceptable_depth_mm )
%
% Produces the nodes and tetra which are deep enough within a given volume, and
% also their indices in the given global tetra and node data structures.
%
% Input:
%
% - in_nodes: finite elements nodes.
%
% - in_tetra: finite element tetrahedra (quadruples of node indices)
%   constructed from above nodes.
%
% - in_volume_inds: the indices of the tetrahedra that form the volume
%   under observation.
%
% - in_acceptable_depth_mm: the depth in millimetres, within which the
%   deep tetra are located.
%
% Output:
%
% - out_deep_nodes
%
%   The coordinates of the nodes that are deep enough inside the given volume.
%
% - out_deep_node_inds
%
%   The global indices of the nodes that are deep enough in the given volume.
%
% - out_deep_tetra
%
%   The tetrahedra that are deep enough in the given volume.
%
% - out_tetra_ind
%
%   The indices of the tetrahedra that are deep enough inside the given brain segment.
%

arguments
    in_nodes (:,3) double
    in_tetra (:,4) double { mustBeInteger, mustBePositive }
    in_volume_inds (:,1) double { mustBeInteger, mustBePositive }
    in_acceptable_depth_mm (1,1) double { mustBeNonnegative }
end

% Find out the boundary- and non-boundary nodes of the volume. Note that
% the indices generated here should reference the "global" set of input
% nodes.

volume_tetra = in_tetra(in_volume_inds, :);

volume_node_inds = unique(volume_tetra(:));

[ surface_triangles, ~ ] = core.tetraSurfaceTriangles ( in_tetra, in_volume_inds ) ;

surface_node_inds = unique(surface_triangles);

non_surface_node_inds = setdiff(volume_node_inds, surface_node_inds);

surface_nodes = in_nodes(surface_node_inds,:);

non_surface_nodes = in_nodes(non_surface_node_inds,:);

% Find out non-surface nodes deep enough within the volume with
% rangesearch.

non_surface_node_inds_too_near_to_surface = nearestPoints ( ...
    surface_nodes, ...
    non_surface_nodes, ...
    in_acceptable_depth_mm ...
);

non_surface_node_inds_too_near_to_surface = non_surface_node_inds(non_surface_node_inds_too_near_to_surface);

% Also take into account surface nodes themselves. D'uh.

surface_node_inds_too_near_to_surface = nearestPoints ( ...
    surface_nodes, ...
    surface_nodes, ...
    in_acceptable_depth_mm ...
) ;

surface_node_inds_too_near_to_surface = surface_node_inds(surface_node_inds_too_near_to_surface);

node_inds_too_near_to_surface = union ( ...
    non_surface_node_inds_too_near_to_surface, ...
    surface_node_inds_too_near_to_surface ...
);

out_deep_node_inds = setdiff ( ...
    volume_node_inds, ...
    node_inds_too_near_to_surface, ...
    'rows' ...
);

out_deep_nodes = in_nodes(out_deep_node_inds, :);

% Find tetra in the volume which only contain acceptable (deep) nodes.
% Acceptable tetra consist of 4 deep nodes.

vertices_in_deep_nodes = ismember ( in_tetra, out_deep_node_inds ) ;

vertex_row_sums = sum ( vertices_in_deep_nodes, 2 ) ;

out_deep_tetra_inds = find ( vertex_row_sums == 4 ) ;

out_deep_tetra = in_tetra(out_deep_tetra_inds, :);

end % function

%% Helper functions.

function pI = nearestPoints ( points, neighbour_points, radius )
%
% pI = nearestPoints ( points, neighbour_points, radius )
%
% Finds the indices of the points in a neighbouring set, that are within a
% given radius from the points of a "current" set.
%

    arguments
        points (:,3) double { mustBeFinite }
        neighbour_points (:, 3) double { mustBeFinite }
        radius (1,1) double { mustBeReal, mustBeNonnegative }
    end

    pI = rangesearch ( neighbour_points, points, radius ) ;

    % Reshape and -size

    pI = unique ( [ pI{:} ]' ) ;

end % function
