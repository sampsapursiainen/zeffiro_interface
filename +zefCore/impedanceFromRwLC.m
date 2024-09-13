function Z = impedanceFromRwLC (R,w,L,C)
%
% Z = impedanceFromRwLC (R,w,L,C)
%
% Computes impedances from given resistance R, angular frequency w, impedance L
% and capacitance C. Inputs can be vectors of identical length. If L is to be
% ignored, set it to 0 and if C is to be ignored, set it to Inf.
%

    arguments
        R (:,1) double { mustBeFinite, mustBePositive }
        w (:,1) double { mustBeFinite, mustBeNonnegative }
        L (:,1) double { mustBeFinite, mustBeNonnegative }
        C (:,1) double { mustBeNonNan, mustBeNonnegative }
    end

    % Set initial impedance.

    Z = R ;

    % Add inductive effects to it.

    Z = R + 1i .* w .* L ;

    % Record where frequencies and capacitances are non-zero.

    nonZerowI = abs (w) > eps ;

    nonZeroCI = abs (C) > eps ;

    nonZerowCI = nonZerowI & nonZeroCI ;

    % Take capacitance into account, if it and the corresponding frequency is non-zero.

    Z (nonZerowCI) = Z (nonZerowCI) - 1i ./ w (nonZerowCI) ./ C (nonZerowCI) ;

end % function
