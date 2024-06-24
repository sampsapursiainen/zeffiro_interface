function out = relativeError (M1, M2)
%
% out = relativeError (M1, M2)
%
% Computes the relative error between M1 and M2, with M2 as the point of comparison.
%

    arguments
        M1 (:,:) double
        M2 (:,:) double
    end

    out = sqrt ( sum ( (M1 - M2) .^ 2 ) ) ./ sqrt ( mean ( sum ( M2 .^ 2 ) ) ) ;

end % function
