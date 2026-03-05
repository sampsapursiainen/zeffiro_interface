function rotations = tetraFaceRotation
%
% rotations = tetraFaceRotation
%
% A constant function that returns an array whose Nth column indicates the
% order in which the face opposite to the Nth node in a tetrahedron should be
% traversed.
%

    arguments; end

    rotations = transpose ([ 2 4 3 ; 1 3 4 ; 1 4 2 ; 1 2 3 ]) ;

end % function
