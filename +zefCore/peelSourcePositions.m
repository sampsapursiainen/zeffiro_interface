function [ ...
    out_deep_nodes, ...
    out_deep_node_inds, ...
    out_deep_tetra, ...
    out_deep_tetra_inds ...
] = peelSourcePositions ( ...
    in_nodes, ...
    in_tetra, ...
    in_volume_inds, ...
    acceptableDepth ...
)
%
% [ out_deep_nodes, out_deep_node_inds, out_deep_tetra, out_deep_tetra_inds ] = peelSourcePositions ( in_nodes, in_tetra, in_volume_inds, acceptableDepth )
%
% Produces the nodes and tetra which are deep enough within a given volume, and
% also their indices in the given global tetra and node data structures.
%
% Input:
%
% - in_nodes
%
%   Finite elements nodes.
%
% - in_tetra
%
%   Finite element tetrahedra (quadruples of node indices) constructed from
%   above nodes.
%
% - in_volume_inds
%
%   The indices of the tetrahedra that form the volume under observation.
%
% - acceptableDepth
%
%   The depth within which the deep tetra are located. This should probably be
%   in the same units as the input node coordinates.
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
%   The indices of the tetrahedra that are deep enough inside the given brain
%   segment.
%

arguments
    in_nodes (:,3) double
    in_tetra (:,4) double { mustBeInteger, mustBePositive }
    in_volume_inds (:,1) double { mustBeInteger, mustBePositive }
    acceptableDepth (1,1) double { mustBeNonnegative }
end

% Find out the boundary- and non-boundary nodes of the volume. Note that the
% indices generated here should reference the "global" set of input nodes.

volume_tetra = in_tetra (in_volume_inds, :) ;

volume_node_inds = unique (volume_tetra(:)) ;

surface_triangles = zefCore.tetraSurfaceTriangles ( volume_tetra ) ;

surface_node_inds = unique (surface_triangles) ;

surface_nodes = in_nodes (surface_node_inds,:) ;

volume_nodes = in_nodes (volume_node_inds ,:) ;

% Find out non-surface nodes deep enough within the volume with rangesearch.

shallowI = rangesearch ( volume_nodes, surface_nodes, acceptableDepth ) ;

shallowI = volume_node_inds ( unique ( transpose ( [ shallowI{:} ] ) ) ) ;

out_deep_node_inds = setdiff ( volume_node_inds, shallowI ) ;

out_deep_nodes = in_nodes ( out_deep_node_inds, : ) ;

% Find tetra in the volume which only contain acceptable (deep) nodes.
% Acceptable tetra consist of 4 deep nodes.

vertices_in_deep_nodes = ismember ( in_tetra, out_deep_node_inds ) ;

vertex_row_sums = sum ( vertices_in_deep_nodes, 2 ) ;

out_deep_tetra_inds = find ( vertex_row_sums == 4 ) ;

out_deep_tetra = in_tetra(out_deep_tetra_inds, :);

end % function