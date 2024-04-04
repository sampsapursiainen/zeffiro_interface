function [ tetraOut, surfTri, indInTetra ] = superNode (tetra, nodeI, kwargs)
%
% [ tetraOut, surfTri, indInTetra ] = superNode (tetra, nodeI, kwargs)
%
% Gathers information about a single supernode, a set of tetrahedra who
% surround a node whose index is nodeI.
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
% - kwargs.radius = 0
%
%   If this is other than 0, all tetra that contain nodes that are within this
%   distance from the central node will be included into the supernode.
%
% - kwargs.nodes = []
%
%   This needs to contain the node set from which nodes within kwargs.radius
%   are searched from. If this is empty, only the immediate tetra that contain
%   nodeI will be considered.
%
% Output:
%
% - tetraOut
%
%   The tetra that this supernode is composed of.
%
% - surfTri
%
%   The surface triangles of the volume that is comprised of tetraOut.
%
% - indInTetra
%
%   A logical array whose columns indicate which nodes in corresponding tetra
%   are within kwargs.radius of the supernode center.
%

    arguments
        tetra         (4,:) uint32 { mustBePositive }
        nodeI         (1,1) uint32 { mustBePositive }
        kwargs.radius (1,1) double { mustBeNonnegative } = 0
        kwargs.nodes  (:,3) double { mustBeFinite } = []
    end

    % Find nodes that are within the given radius from the central nodeI.

    if kwargs.radius > 0 && not ( isempty (kwargs.nodes) )

        nodeICell = rangesearch ( kwargs.nodes, kwargs.nodes (nodeI,:), kwargs.radius ) ;

        nodeI = [ nodeICell{:} ] ;

    end

    % Find which tetra (columns) contain nodeI and whether the node is the 1st,
    % 2nd, 3rd or 4th node in the tetrahedron (the row).

    isTetraMember = ismember ( tetra, nodeI ) ;

    whichTetra = any (isTetraMember,1) ;

    indInTetra = isTetraMember (:,whichTetra) ;

    tetraOut = tetra (:,whichTetra) ;

    % Then find the surface triangles of the supernode.

    surfTri = core.tetraSurfaceTriangles ( transpose ( tetra (:,whichTetra) ) ) ;

    surfTri = transpose (surfTri) ;

end % function
