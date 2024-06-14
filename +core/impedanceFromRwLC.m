function Z = impedanceFromRwLC (R,w,L,C)
%
% Z = impedanceFromRwLC (R,w,L,C)
%
% Computes impedances from given resistance R, angular frequency w, impedance L
% and capacitance C. Inputs can be vectors of identical length. If L is to be
% ignored, set it to 0 and if C is to be ignored, set it to Inf.
%

    arguments
        R (:,1) double { mustBeFinite }
        w (:,1) double { mustBeFinite }
        L (:,1) double { mustBeFinite }
        C (:,1) double { mustBeNonNan }
    end

    assert ( all (C ~= 0), "Received a zero in place of capacitance, division by zero error." ) ;

    w (w == 0) = 1 ;

    Z = R + 1i .* ( w .* L - 1 ./ w ./ C ) ;

end % function
