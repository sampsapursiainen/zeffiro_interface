function surface_triangles = tetraSurfaceTriangles ( tetra )
%
% surface_triangles = tetraSurfaceTriangles ( tetra )
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
% Outputs:
%
% - surface_triangles
%
%   Triples of node indices, corresponding to the surface triangles of the
%   given tetrahedral volume.
%

    arguments
        tetra (:,4) uint32
    end

    % Tetra faces (node index triples) opposite to row index node.

    tetraFR = transpose (core.tetraFaceRotation) ;

    % Find tetra indices I that share a face, by sorting and subtracting.

    faces = [
        tetra(:,[2 4 3]);
        tetra(:,[1 3 4]);
        tetra(:,[1 4 2]);
        tetra(:,[1 2 3]);
    ];

    faceLabels = uint32([
        1*ones(size(tetra,1),1) (1:size(tetra,1))';
        2*ones(size(tetra,1),1) (1:size(tetra,1))';
        3*ones(size(tetra,1),1) (1:size(tetra,1))';
        4*ones(size(tetra,1),1) (1:size(tetra,1))';
    ]);

    faces = sort(faces,2);

    [ faces, J ] = sortrows ( faces, [1 2 3] );

    tetra_ind = zeros(size(faces,1),1);

    I = find ( sum ( abs ( faces(2:end,1:3) - faces(1:end-1,1:3) ), 2 ) == 0 );

    faceLabels = faceLabels(J,:);

    tetra_ind(I) = 1;

    tetra_ind(I+1) = 1;

    I = find(tetra_ind == 0);

    tetra_ind = sub2ind(size(tetra),repmat(faceLabels(I,2),1,3),tetraFR(faceLabels(I,1),:));

    surface_triangles = tetra(tetra_ind);

    surface_triangles = uint32(surface_triangles(:,[1 3 2]));

end % function
