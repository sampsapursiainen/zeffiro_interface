function [elementNeighbours, connectingLocalFaces] = findElementFacetNeighbours(elements)
%
%   elementNeighbours, connectingLocalFaces = findElementFacetNeighbours(elements)
%
% Finds neighboring elements based on whether they share a facet.
% The kind of elements supported are triangles, tetrahedra and voxels.
%
% Arguments
%
%   elements (:,:) int64 { mustBeInteger, mustBePositive  }
%
% The elements whose facet connections are being discovered.
% The array should be of the size elements times vertices.
% The mesh formed by the elements should be conforming,
% as in there should be no hanging nodes.
%

    arguments
        elements (:,:) int64 { mustBeInteger, mustBePositive }
    end

    [elementN, vertexN] = size(elements) ;

    if vertexN == 3

        faceVertexIndices = zeffiro.geometry.localTriangleFacetIndices ;

    elseif vertexN == 4

        faceVertexIndices = zeffiro.geometry.localTetrahedronFacetIndices ;

    elseif vertexN == 8

        faceVertexIndices = zeffiro.geometry.localVoxelFacetIndices ;

    else

        error("Received a set of elements with an unhandled number of vertices.")

    end % if

    [faceVertexN,faceN] = size(faceVertexIndices) ;

    repeatedElementIndices = repelem(1:elementN, faceVertexN, faceN) ;

    repeatedFaceVertexIndices = repmat(faceVertexIndices, 1, elementN) ;

    linearIndices = sub2ind(size(elements), repeatedElementIndices', repeatedFaceVertexIndices') ;

    faces = reshape( ...
        elements(linearIndices), ...
        faceN * elementN, ...
        faceVertexN ...
    ) ;

    facesSortedByCols = sort(faces,2) ;

    [facesSortedByRows,rowSortPermutation] = sortrows(facesSortedByCols) ;

    sortedElementIndices = repeatedElementIndices(:,rowSortPermutation) ;

    faceDifferences = diff(facesSortedByRows,1,1) ;

    zeroRowMask = not(any(faceDifferences,2)) ;

    zeroRowIndices = find(zeroRowMask) ;

    zeroRowNeighbourIndices = zeroRowIndices + 1 ;

    firstVertices = transpose(sortedElementIndices(1,zeroRowIndices)) ;

    secondVertices = transpose(sortedElementIndices(1,zeroRowNeighbourIndices)) ;

    [elementNeighbours, elementNeighbourPermutation] = sortrows([ ...
        firstVertices, secondVertices ; ...
        secondVertices, firstVertices ; ...
    ]) ;

    repeatedLocalFacetIndices = transpose(repmat(1 : faceN, 1, elementN)) ;

    sortedRepeatedLocalFacetIndices = repeatedLocalFacetIndices(rowSortPermutation) ;

    unsortedConnectingLocalFaces = [ ...
        firstVertices, sortedRepeatedLocalFacetIndices(zeroRowIndices) ; ...
        secondVertices, sortedRepeatedLocalFacetIndices(zeroRowNeighbourIndices) ; ...
    ] ;

    connectingLocalFaces = unsortedConnectingLocalFaces(elementNeighbourPermutation,:) ;

end % function
