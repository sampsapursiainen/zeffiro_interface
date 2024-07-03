function out = columnCosine (M1, M2)
%
% out = columnCosine (M1, M2)
%
% Given 2 matrices M1 and M2, computes the cosine of the angles between their
% column vectors.
%

    arguments
        M1 (:,:) double { mustBeFinite }
        M2 (:,:) double { mustBeFinite }
    end

    out = dot (M1,M2) ./ vecnorm (M1) ./ vecnorm (M2) ;

end % function
