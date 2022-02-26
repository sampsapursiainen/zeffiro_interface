function fdn = zef_tetra_fdn

% The face defining neighbours on nodes in a tetrahedron. The sets of vectors
% fdn[:,2] - fdn[:,1] and fdn[:,3] - fdn[:,1] define a basis which spans the
% plane that defines the faces of a tetrahedron.

	fdn = [
		2 3 4 ;
		3 4 1 ;
		4 1 2 ;
		1 2 3
	];

end
