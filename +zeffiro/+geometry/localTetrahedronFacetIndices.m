function faceVertexIndices = localTetrahedronFacetIndices
%
%   facesIndices = localTetrahedronFacetIndices
%
% Generates a set of local indices for extracting the facets (triangles) from a given tetrahedron.
%

    faceVertexIndices = [
        2 3 4 ;
        1 4 3 ;
        1 2 4 ;
        1 3 2 ;
    ]' ;

end % function
