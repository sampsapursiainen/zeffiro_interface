function gradients = tetraVolumeGradient (nodes, tetrahedra, node_index )
%
% gradients = tetraVolumeGradient (nodes, tetrahedra, node_index )
%
% Calculates all of the ∇𝑉 of tetrahedra in the generated finite element mesh
% as a triple product a ⋅ (b × c). See https://math.stackexchange.com/q/797845
% for the general idea.
%
% Input:
%
% - nodes: a matrix that contains the 3D coordinates of each node in the
%   finite element mesh as its rows.
% - tetrahedra: a matrix that contains the 4 nodes of tetrahedra in the finite
%   element mesh as its rows.
%
% Output: a set of volume gradients ∇𝑉
%

% Helper matrix with rows determining the indices of the nodes whose
% differences will be taken.

ind_m = [
    2 3 4 ;
    3 4 1 ;
    4 1 2 ;
    1 2 3
    ];

% Cross products between the direction vectors that determine the faces of
% the tetrahedra. Results in the surface normals of the faces.

normals = 1/2 * cross( ...
    nodes(tetrahedra(:,ind_m(node_index,2)),:)' ...
    - ...
    nodes(tetrahedra(:,ind_m(node_index,1)),:)' ...
, ...
    nodes(tetrahedra(:,ind_m(node_index,3)),:)' ...
    - ...
    nodes(tetrahedra(:,ind_m(node_index,1)),:)' ...
);

% Dot products between the face normals and the direction vectors between
% a fixed node and other nodes in a tetrahedron.

fixed_nodes = nodes(tetrahedra(:,node_index),:)';
other_nodes = nodes(tetrahedra(:,ind_m(node_index,1)),:)';
direction_vectors = fixed_nodes - other_nodes;

gradients = normals .* repmat ( sign ( dot ( normals , direction_vectors ) ) , 3, 1 );

end
