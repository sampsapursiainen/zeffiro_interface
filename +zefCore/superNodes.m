function [ sNodes ] = superNodes (tetra,nodeI, kwargs)
%
% [ sNodes ] = superNodes (tetra,nodeI,kwargs)
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
% - kwargs.radii = 0
%
%   The distances from the centers of the wanted supernodes, within which nodes
%   and the elements that contain them will be included into the supernodes.
%
% - kwargs.nodes = []
%
%   If kwargs.radii > 0, this set of nodes wil be queried for nodes that are
%   close enough to the central nodes.
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
        kwargs.radii (:,1) double { mustBeNonnegative } = 0
        kwargs.nodes (:,3) double { mustBeFinite } = []
    end

    % Number of central nodes.

    Nc = numel (nodeI) ;

    % Adjust radii in case it is a scalar.

    if isscalar (kwargs.radii)
        radii = kwargs.radii * ones (1,Nc) ;
    else
        radii = kwargs.radii ;
    end

    % Preallocate space for the headers of the supernode data.

    sNodes.indInTetra = cell (1,Nc) ;

    sNodes.tetra = cell (1,Nc) ;

    sNodes.surfTri = cell (1,Nc) ;

    % Go over the individual nodeI.

    for ii = 1 : numel (nodeI)

        nI = nodeI (ii) ;

        radius = radii (ii) ;

        [whichTetra,surfTri,indInTetra] = zefCore.superNode (tetra,nI,radius=radius,nodes=kwargs.nodes) ;

        sNodes.indInTetra {ii} = indInTetra ;

        sNodes.tetra {ii} = whichTetra ;

        sNodes.surfTri {ii} = surfTri ;

    end % for

end % function
