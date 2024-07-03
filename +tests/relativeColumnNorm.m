function out = relativeColumnNorm(M1,M2)
%
% out = relativeColumnNorm(M1,M2)
%
% Computes the column norms of M1 in relation to column norms of M2.
%

    arguments
        M1 (:,:) double { mustBeFinite }
        M2 (:,:) double { mustBeFinite }
    end

    out = vecnorm (M1) ./ vecnorm (M2) ;

end % function
