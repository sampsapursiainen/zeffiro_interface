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
%   - indInTetra
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

    sNodes.indInTetra = cell (1,Nc) ;

    sNodes.tetra = cell (1,Nc) ;

    sNodes.surfTri = cell (1,Nc) ;

    % Go over the individual nodeI.

    for ii = 1 : numel (nodeI)

        nI = nodeI (ii) ;

        [whichTetra,surfTri,indInTetra] = core.superNode (tetra,nI) ;

        sNodes.indInTetra {ii} = indInTetra ;

        sNodes.tetra {ii} = whichTetra ;

        sNodes.surfTri {ii} = surfTri ;

    end % for

end % function
