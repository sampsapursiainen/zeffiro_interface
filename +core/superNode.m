function [ elementsOut, surfTri, indInTetra ] = superNode (elements, nodeI, kwargs)
%
% [ elementsOut, surfTri, indInTetra ] = superNode (elements, nodeI, kwargs)
%
% Gathers information about a single supernode, a set of tetrahedra who
% surround a node whose index is nodeI.
%
% Input:
%
% - elements ({3,4},:) uint32
%
%   Triples or quadruples of node indices, which indicate the sets of nodes
%   that each surface triangle or tetrahedron is composed of.
%
% - nodeI (1,1) uint32
%
%   The index of the central node within the surface or volumetric mesh.
%
% - kwargs.radius = 0
%
%   If this is other than 0, all elements that contain nodes that are within this
%   distance from the central node will be included into the supernode.
%
% - kwargs.nodes = []
%
%   This needs to contain the node set from which nodes within kwargs.radius
%   are searched from. If this is empty, only the immediate elements that contain
%   nodeI will be considered.
%
% Output:
%
% - elementsOut
%
%   The elements that this supernode is composed of.
%
% - surfTri
%
%   The surface triangles of the volume that is comprised of elementsOut. If
%   input elements were triangles, this will equal elementsOut.
%
% - indInTetra
%
%   A logical array whose columns indicate which nodes in corresponding
%   elements are within kwargs.radius of the supernode center.
%

    arguments
        elements      (:,:) uint32 { mustBePositive }
        nodeI         (1,1) uint32 { mustBePositive }
        kwargs.radius (1,1) double { mustBeNonnegative } = 0
        kwargs.nodes  (:,3) double { mustBeFinite } = []
    end

    % Check validity of inputs.

    [ Nv, ~ ] = size (elements) ;

    assert ( ismember ( Nv, [3,4] ), "The first argument needs to consist of elements that have either 3 or 4 vertices." )

    % Find nodes that are within the given radius from the central nodeI.

    if kwargs.radius > 0 && not ( isempty (kwargs.nodes) )

        nodeICell = rangesearch ( kwargs.nodes, kwargs.nodes (nodeI,:), kwargs.radius ) ;

        nodeI = [ nodeICell{:} ] ;

    end % if

    % Find which elements (columns) contain nodeI and whether the node is the 1st,
    % 2nd, 3rd or 4th node in the tetrahedron (the row).

    isElementMember = ismember ( elements, nodeI ) ;

    whichElements = any (isElementMember,1) ;

    indInTetra = isElementMember (:,whichElements) ;

    elementsOut = elements (:,whichElements) ;

    % Then find the surface triangles of the supernode. If a mesh of triangles
    % was given instead of elements, the surface mesh is the set of qualifying
    % elements itself.

    if Nv == 4

        surfTri = core.tetraSurfaceTriangles ( transpose ( elements (:,whichElements) ) ) ;

        surfTri = transpose (surfTri) ;

    else

        surfTri = elementsOut ;

    end % if

end % function
