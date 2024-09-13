function R = resistivityMatrix (T,invS)
%
% R = resistivityMatrix (T,invS)
%
% Computes the resistivity matrix of a system
%
%   [ A, B ; B', C ] * [ u ; v ] = [ 0 ; y ]
%
% where A is a stiffness matrix, B is the potential loss matrix across
% electrodes and C is the diagonal inverse impedance matrix.
%
% Inputs:
%
% - T = A \ B
%
%   A transfer matrix, A inverted against B.
%
% - invS = inv ( C - B' * T )
%
%   Inverse of the Schur complement of A.
%

    arguments
        T (:,:) double { mustBeFinite }
        invS (:,:) double { mustBeFinite }
    end

    R = T * invS ;

end % function
