function [ elementsOut, surfTri, indInTetra ] = superNode (elements, centerNodeI, kwargs)
%
% [ elementsOut, surfTri, indInTetra ] = superNode (elements, centerNodeI, kwargs)
%
% Gathers information about a single supernode, a set of tetrahedra who
% surround a node whose index is centerNodeI.
%
% Input:
%
% - elements ({3,4},:) uint32
%
%   Triples or quadruples of node indices, which indicate the sets of nodes
%   that each surface triangle or tetrahedron is composed of.
%
% - centerNodeI (1,:) uint32
%
%   The indices of the central nodes on the surface or within the volumetric mesh.
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
%   centerNodeI will be considered.
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
        centerNodeI   (1,:) uint32 { mustBePositive }
        kwargs.radius (1,1) double { mustBeNonnegative } = 0
        kwargs.nodes  (:,3) double { mustBeFinite } = []
    end

    % Check validity of inputs.

    [ Nv, ~ ] = size (elements) ;

    assert ( ismember ( Nv, [3,4] ), "The first argument needs to consist of elements that have either 3 or 4 vertices." )

    % Find nodes that are within the given radius from the central centerNodeI.

    if kwargs.radius > 0 && not ( isempty (kwargs.nodes) )

        nodeICell = rangesearch ( kwargs.nodes, kwargs.nodes (centerNodeI,:), kwargs.radius ) ;

        centerNodeI = [ nodeICell{:} ] ;

    end % if

    % Find which elements (columns) contain centerNodeI and whether the node is the 1st,
    % 2nd, 3rd or 4th node in the tetrahedron (the row).

    isElementMember = ismember ( elements, centerNodeI ) ;

    whichElements = any (isElementMember,1) ;

    indInTetra = isElementMember (:,whichElements) ;

    elementsOut = elements (:,whichElements) ;

    % Then find the surface triangles of the supernode. If a mesh of triangles
    % was given instead of elements, the surface mesh is the set of qualifying
    % elements itself.

    if Nv == 4

        surfTri = zefCore.tetraSurfaceTriangles ( transpose ( elements (:,whichElements) ) ) ;

        surfTri = transpose (surfTri) ;

    else

        surfTri = elementsOut ;

    end % if

end % function
