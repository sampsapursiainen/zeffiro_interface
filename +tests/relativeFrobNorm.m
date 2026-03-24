function out = relativeFrobNorm (M1, M2)
%
% out = relativeFrobNormDiff (M1, M2)
%
% Computes the relative Frobenius norm between arrays M1 and M2,
% with M2 as the point of comparison.
%

    arguments
        M1 (:,:) double
        M2 (:,:) double
    end

    out = norm ( M1, "fro" ) / norm ( M2, "fro" ) ;

end % function
