function face_rotations = face_rotations ( self )
%
% face_rotations = face_rotations ( self )
%
% Returns the rotations of the faces opposing each node in a single tetrahedron
% in this finite element mesh, as the columns of a matrix.
%

    arguments
        self (1,1) core.TetraMesh
    end

    face_rotations = [ 2 4 3 , 1 3 4 , 1 4 2 , 1 2 3 ];

    face_rotations = reshape ( face_rotations, 3, 4) ;

end % function
