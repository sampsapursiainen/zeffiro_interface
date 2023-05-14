function fdn = zef_prism_fdn

% The face defining neighbours on nodes in a prism. The sets of vectors
% fdn[:,2] - fdn[:,1] and fdn[:,3] - fdn[:,1] define a basis which spans the
% plane that defines the faces of a tetrahedron.

fdn = [
    2 3 5;
    3 1 6;
    1 2 4;
    5 6 2;
    6 4 3;
    4 5 1
    ];

end
