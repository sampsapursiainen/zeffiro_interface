function [ sNodes ] = superNodes (tetra,nodeI)
%
% [ sNodes ] = superNodes (tetra,nodeI)
%
% Given a set of central node indices nodeI, finds out the supernodes around
% these nodes from the mesh defined by nodes and tetra. A supernode is a set of
% tetrahedra connected to a central node.
%
% Input:
%
% - tetra
%
%   Quadruples of node indices, such that nodes (:,tetra) given the coordinates
%   of the nodes in each tetrahedron in groups of 4.
%
% - nodeI:
%
%   The indices of the central nodes within the mesh.
%
% Output:
%
% - sNodes
%
%   A structure array that contains the following cell array fields:
%
%   - nodeOrd
%
%     The ordinals of each central node in the tetra that compose the
%     supernodes. For example, a value of 1 at index I in this cell array
%     indicates that the node was the first node of a tetrahedron in the same
%     index I of superNodes.tetra.
%
%   - tetra
%
%     The global indices of the tetra that each supernode is composed of.
%
%   - surfTri
%
%     The surface triangles of each supernode.
%

    arguments
        tetra (4,:) uint32 { mustBePositive }
        nodeI (1,:) uint32 { mustBePositive }
    end

    % Number of central nodes.

    Nc = numel (nodeI) ;

    % Preallocate space for the headers of the supernode data.

    sNodes.nodeOrd = cell (1,Nc) ;

    sNodes.tetra = cell (1,Nc) ;

    sNodes.surfTri = cell (1,Nc) ;

    % Go over the individual nodeI.

    for ii = 1 : numel (nodeI)

        % Find which tetra (columns) contain this node index and whether the
        % node is the 1st, 2nd 3rd or 4th node in the tetrahedron (the row).

        nI = nodeI (ii) ;

        isTetMember = ismember ( tetra, nI ) ;

        [ nodeOrder, whichTetra ] = find ( isTetMember ) ;

        sNodes.nodeOrd {ii} = nodeOrder ;

        sNodes.tetra {ii} = whichTetra ;

        % Then find the surface triangles of the supernode.

        [surfTri,~] = core.tetraSurfaceTriangles (tetra', whichTetra) ;

        sNodes.surfTri {ii} = transpose (surfTri) ;

    end % for

end % function
