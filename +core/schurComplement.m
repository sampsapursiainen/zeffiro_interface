function S = schurComplement (invAB, C, D)
%
% S = schurComplement (invAB, C, D)
%
% Computes the schur complement S = D - C * invAB of A in the block matrix [A B ; C D].
%
% Inputs:
%
% - invAB
%
%   Inverse of A times B.
%
% - C
%
%   The lower left block matrix C.
%
% - D
%
%   The lower right block matrix D.
%

    arguments
        invAB (:,:) double { mustBeFinite }
        C     (:,:) double { mustBeFinite }
        D     (:,:) double { mustBeFinite }
    end

    S = (D - C * invAB) ;

end % function
