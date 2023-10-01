function [ surface_elements, geI, surface_triangles ]  = surface_elements ( self, inds )
%
% [ surface_elements, geI, surface_triangles ]  = surface_elements ( self, inds )
%
% Given the indices of a set of elements, finds which of them comprise the
% surface of the set, by checking which elements do not have as many neighbours
% as an element should have faces.
%

    arguments
        self (1,1) core.TetraMesh
        inds (1,:) uint64 { mustBePositive } = 1 : self.element_count
    end

    tetra = self.tetra ( :, inds ) ;

    n_of_tetra = size ( tetra, 2 ) ;

    face_rotations = self.face_rotations ;

    fr1 = face_rotations (:,1) ;
    fr2 = face_rotations (:,2) ;
    fr3 = face_rotations (:,3) ;
    fr4 = face_rotations (:,4) ;

    face1 = tetra (fr1,:) ;
    face2 = tetra (fr2,:) ;
    face3 = tetra (fr3,:) ;
    face4 = tetra (fr4,:) ;

    % Form a face array and order it, so that opposing faces with the same node
    % indices are next to each other in columns.

    faces = [ face1 , face2 , face3 , face4 ] ;

    sorted_faces = sort ( faces, 1 ) ;

    [ sorted_faces, permutation ] = utilities.sortcolumns ( sorted_faces, [1 2 3] ) ;

    % Store faces and the opposing node indices they correspond to and
    % tetra indices into arrays. Then order them based on permutation.

    one = ones ( 1, size ( tetra, 2 ) ) ;

    face_ids = [ 1*one , 2*one , 3*one , 4*one ] ;

    face_ids = face_ids ( permutation ) ;

    tetra_ids = repmat ( 1 : n_of_tetra, 1, 4 ) ;

    tetra_ids = tetra_ids ( permutation ) ;

    % Find whether faces are opposing by checking whether adjacent subtracted
    % index sets subtract absolutely to 0.

    aI = find ( sum ( abs ( sorted_faces (:,2:end) - sorted_faces (:,1:end-1) ) ) == 0 ) ;

    % Mark elements that had neighbours.

    nI = zeros ( 1 , n_of_tetra ) ;

    nI ( aI ) = 1 ;

    nI ( aI + 1 ) = 1 ;

    % Determine surface element indices from incides that were not marked as having neighbours.

    nnI = nI == 0 ;

    seI = tetra_ids ( nnI ) ;

    sfI = face_ids ( nnI ) ;

    % Make a transformation into the global element index set and fetch the elements.

    geI = unique ( inds ( seI ) ) ;

    surface_elements = self.tetra ( :, geI ) ;

    % Get surface triangles.

    frs = face_rotations ( : , sfI ) ;

    tI = repmat ( seI, 3, 1 ) ;

    fI = sub2ind ( size ( tetra ), frs, tI ) ;

    surface_triangles = tetra ( fI ) ;

end % function
