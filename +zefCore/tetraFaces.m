function [ V, nI ] = tetraFaces (nodes, tetra)
%
% [ V, nI ] = tetraFaces (nodes, tetra)
%
% Extracts the face triangle vertex coordinate vectors of given tetra as a 3D
% array. Also returns the triples of node indices that were used to form the
% vertex triples.
%

    arguments
        nodes (3,:) double { mustBeFinite }
        tetra (4,:) uint64 { mustBePositive }
    end

    % Get number of tetra.

    Nt = size ( tetra, 2 ) ;

    % Define face combinations.

    fc = zefCore.tetraFaceRotation ;

    % Index into tetra to get the triples of node indices.

    nI = tetra ( fc, : ) ;

    % Get vertex coordinates of these node triples.

    V = nodes ( :, nI ) ;

    % Reshape result before returning.

    V = reshape ( V, 3, 12, Nt ) ;

end % function
