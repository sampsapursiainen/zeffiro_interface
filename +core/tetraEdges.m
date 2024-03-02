function [ E, V, tI ] = tetraEdges (nodes, tetra)
%
% [ E, V, tI ] = tetraEdges (nodes, tetra)
%
% Extracts the direction vectors of edges of given tetra as a 3D array. Also
% returns the vertex pairs corresponding to these and the tetra indices used to
% form the vertex pairs.
%

    arguments
        nodes (3,:) double { mustBeFinite }
        tetra (4,:) uint64 { mustBePositive }
    end

    Nt = size ( tetra, 2 ) ;

    % Define the 6 edge combinations.

    ec = [ 1 2 ; 1 3 ; 1 4 ; 2 3 ; 2 4 ; 3 4 ]' ;

    % Index into the tetra to extract 6 node index pairs per tetrahedron.

    tI = tetra ( ec, : ) ;

    % Extract vertices corresponding to these.

    V = nodes ( :, tI ) ;

    % Reshape this such that each page of a 3D array contains the 6 vertex
    % coordinate vector pairs for each element.

    V = reshape ( V, 3, 12, Nt ) ;

    % Compute the pairwise differences to get direction vectors of edges.

    E = V ( :, 2 : 2 : end, : ) - V ( :, 1 : 2 : end, : ) ;

end % function
