function facetVertexIndices = localTriangleFacetIndices
%
%   facesIndices = localTriangleFaceIndices
%
% Generates a set of local indices for extracting the facets (edges) from a given triangles.
%

    facetVertexIndices = [
        2 3 ;
        3 1 ;
        1 2 ;
    ]' ;

end % function
