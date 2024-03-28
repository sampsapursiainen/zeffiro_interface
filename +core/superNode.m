function [ whichTetra, surfTri, indInTetra ] = superNode (tetra, nodeI)
%
% [ whichTetra, surfTri, indInTetra ] = superNode (tetra, nodeI)
%
% Gathers information about a single supernode, a set of tetrahedra who all
% have a node whose index is nodeI as one of their vertices.
%
% Input:
%
% - tetra (4,:) uint32
%
%   Quadruples of node indices.
%
% - nodeI (1,1) uint32
%
%   The index of the central node within the mesh.
%
% Output:
%
% - whichTetra
%
%   The global indices of the tetra that each supernode is composed of.
%
% - surfTri
%
%   The surface triangles of each supernode.
%
% - indInTetra
%
%   The ordinal of the central node in the tetra that compose the supernode.
%

    arguments
        tetra (4,:) uint32 { mustBePositive }
        nodeI (1,1) uint32 { mustBePositive }
    end

    % Find which tetra (columns) contain nodeI and whether the node is the 1st,
    % 2nd, 3rd or 4th node in the tetrahedron (the row).

    isTetraMember = ismember ( tetra, nodeI ) ;

    [ indInTetra, whichTetra ] = find ( isTetraMember ) ;

    % Then find the surface triangles of the supernode.

    [surfTri,~] = core.tetraSurfaceTriangles (tetra', whichTetra) ;

    surfTri = transpose (surfTri) ;

end % function
