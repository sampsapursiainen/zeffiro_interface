function faceVertexIndices = localVoxelFacetIndices
%
%   facesIndices = localVoxelFacetIndices
%
% Generates a set of local indices for extracting the facets from a given voxel.
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
