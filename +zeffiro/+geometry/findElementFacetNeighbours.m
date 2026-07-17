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

        faceVertexIndices = localTriangleFaceIndices ;

    elseif vertexN == 4

        faceVertexIndices = localTetraFaceIndices ;

    elseif vertexN == 8

        faceVertexIndices = localVoxelFaceIndices ;

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

    elementNeighbours = dictionary( ...
        [firstVertices, secondVertices], ...
        [secondVertices, firstVertices] ...
    ) ;

    repeatedLocalFacetIndices = repmat(1 : faceN, 1, elementN) ;

    sortedRepeatedLocalFacetIndices = repeatedLocalFacetIndices(rowSortPermutation) ;

    connectingLocalFaces = dictionary( ...
        [firstVertices, secondVertices], ...
        sortedRepeatedLocalFacetIndices([zeroRowIndices,zeroRowNeighbourIndices]) ...
    ) ;

end % function

% Helper functions.

function faceVertexIndices = localTriangleFaceIndices
%
%   facesIndices = localTriangleFaceIndices
%
% Generates a set of local indices for extracting the faces from a given triangles.
%

    faceVertexIndices = [
        1 2 ;
        2 3 ;
        3 1 ;
    ]' ;

end % function

function faceVertexIndices = localTetraFaceIndices
%
%   facesIndices = localTetraFaceIndices
%
% Generates a set of local indices for extracting the faces from a given tetrahedron.
%

    faceVertexIndices = [
        1 3 2 ;
        1 2 4 ;
        1 4 3 ;
        2 3 4 ;
    ]' ;

end % function

function faceVertexIndices = localVoxelFaceIndices
%
%   facesIndices = localVoxelFaceIndices
%
% Generates a set of local indices for extracting the faces from a given voxel.
%

    faceVertexIndices = [
        1 4 3 2 ;
        1 2 6 5 ;
        2 3 7 6 ;
        3 4 8 7 ;
        4 1 5 8 ;
        5 6 7 8 ;
    ]' ;

end % function
