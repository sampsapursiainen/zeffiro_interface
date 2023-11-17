function [surface_triangles, tetra_ind] = tetraSurfaceTriangles ( tetra, tI )
%
% [surface_triangles, tetra_ind] = tetraSurfaceTriangles ( tetra, tI )
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
% - tI
%
%   The indices that select a subset of tetra.
%
% Outputs:
%
% - surface_triangles
%
%   Triples of node indices, corresponding to the surface triangles of the
%   given tetrahedral volume.
%
% - tetra_ind
%
%   Indices of the tetrahedra that surface_triangles belong to.
%

    arguments
        tetra (:,4) uint32
        tI    (:,1) uint32
    end

    % Tetra faces (node index triples) opposite to row index node.

    ind_m = [ 2 4 3 ; 1 3 4 ; 1 4 2 ; 1 2 3 ];

    % Find tetra indices I that share a face, by sorting and subtracting.

    tetra = tetra(tI,:) ;

    tetra_sort_1 = [
        tetra(:,[2 4 3]);
        tetra(:,[1 3 4]);
        tetra(:,[1 4 2]);
        tetra(:,[1 2 3]);
    ];

    tetra_sort_2 = uint32([
        1*ones(size(tetra,1),1) (1:size(tetra,1))';
        2*ones(size(tetra,1),1) (1:size(tetra,1))';
        3*ones(size(tetra,1),1) (1:size(tetra,1))';
        4*ones(size(tetra,1),1) (1:size(tetra,1))';
    ]);

    tetra_sort_1 = sort(tetra_sort_1,2);

    [ tetra_sort_1, J ] = sortrows ( tetra_sort_1, [1 2 3] );

    tetra_ind = zeros(size(tetra_sort_1,1),1);

    I = find ( sum ( abs ( tetra_sort_1(2:end,1:3) - tetra_sort_1(1:end-1,1:3) ), 2 ) == 0 );

    tetra_sort_2 = tetra_sort_2(J,:);

    tetra_ind(I) = 1;

    tetra_ind(I+1) = 1;

    I = find(tetra_ind == 0);

    tetra_ind = sub2ind(size(tetra),repmat(tetra_sort_2(I,2),1,3),ind_m(tetra_sort_2(I,1),:));

    surface_triangles = tetra(tetra_ind);

    surface_triangles = uint32(surface_triangles(:,[1 3 2]));

    tetra_ind = tetra_sort_2(I,2);

end % function
