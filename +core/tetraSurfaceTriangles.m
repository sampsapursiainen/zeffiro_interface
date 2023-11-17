function T = tetraSurfaceTriangles ( tetra, I )
%
% T = tetraSurfaceTriangles ( tetra, inds )
%
% Retrieves the surface triangles of a given tetrahedral volume, indicated by
% the index set I.
%
% Inputs:
%
% - tetra
%
%   The set of all tetrahedra.
%
% - I
%
%   The indices that select a subset of tetra.
%
% Outputs:
%
% - T
%
%   Triples of node indices.
%

    T = zef_surface_mesh ( tetra, [], I ) ;

end % function
