function [surface_triangles, tetra_ind] = surface_triangles(tetra)

    %
    % surface_triangles
    %
    % Determines the surface triangles, corresponding surface nodes and the
    % tetra which are on the surface of the give volume determined by the
    % input tetra.
    %
    % Input:
    %
    % - tetra
    %
    %   These determine the volume whose surface we are inspecting.
    %
    % Outputs:
    %
    % - surface_triangles
    %
    %   Triples of indices of nodes that are on the surface of the volume
    %   determined by the input tetra.
    %
    % - tetra_ind
    %
    %   The indices of the tetra that are on the surface of the volume.
    %

    arguments

        tetra (:,4) double { mustBeInteger, mustBePositive }

    end

    n_of_tetra = size(tetra, 1);

    % Tetra faces (node index triples) opposite to row index node within each
    % tetra.

    face_inds = zef_as_class.Zef.TETRA_FACES;

    faces = [
        tetra(:,face_inds(1,:)) ;
        tetra(:,face_inds(2,:)) ;
        tetra(:,face_inds(3,:)) ;
        tetra(:,face_inds(4,:))
    ];

    opposite_node_inds = [
        1 * ones(n_of_tetra, 1) ;
        2 * ones(n_of_tetra, 1) ;
        3 * ones(n_of_tetra, 1) ;
        4 * ones(n_of_tetra, 1)
    ];

    tetra_inds_for_opposite_nodes = repmat([1:n_of_tetra]', 4, 1);

    % Form a relation (face triangle, opposite node index, tetra index). Also
    % preallocate an index array for the indices of tetra that share faces.

    sorting_relation = [ faces, opposite_node_inds, tetra_inds_for_opposite_nodes ];

    tetra_ind = zeros(size(sorting_relation,1),1);

    % Sort the face portion of the rows, and place back into the relation.

    sorting_relation(:,1:3) = sort(sorting_relation(:,1:3),2);

    % Then sort the entire relation based on the first 3 columns, starting
    % from the left.

    sorting_relation = sortrows(sorting_relation,[1 2 3]);

    % After the rows and columns of the relation have been sorted, the tetra
    % that share a face triangle should be on subsequent rows, such that
    % subtracting a preceding triangle from the succeeding one will sum up to
    % 0, if a face is shared.

    preceding_triangles = sorting_relation(1:end-1, 1:3);

    following_triangles = sorting_relation(2:end, 1:3);

    differences = following_triangles - preceding_triangles;

    I = find(sum(abs(differences),2)==0);

    % Save the tetra pairs that share a face. Again, subsequent rows
    % correspond to adjacent tetra.

    tetra_ind(I) = 1;

    tetra_ind(I+1) = 1;

    % Now determine which tetra have a face that is NOT shared with any tetra
    % in the given volume. These are the surface tetra.

    I = find(tetra_ind == 0);

    % Then build an N × 3 matrix of tetra indices with sub2ind and N × 3 row
    % and columns matrices.

    node_inds_in_tetra = sorting_relation(I, 4);

    tetra_inds_in_relation = sorting_relation(I, 5);

    rows = repmat(tetra_inds_in_relation, 1, 3);

    cols = face_inds(node_inds_in_tetra, :);

    tetra_ind = sub2ind(size(tetra), rows, cols);

    % Form surface triangles from tetra indices.

    surface_triangles = tetra(tetra_ind);

    % This permutation is done in the original function, but why?
    %
    % surface_triangles = surface_triangles(:,[1 3 2]);

    tetra_ind = tetra_inds_in_relation;

end
