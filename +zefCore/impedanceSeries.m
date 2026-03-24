function Z = impedanceSeries (R,f,L,C)
%
% Z = impedanceSeries (R,f,L,C)
%
% Computes impedances of RLC circuits, from given resistance R, voltage
% frequency f, impedance L and capacitance C. Inputs can be vectors of
% identical length. Any f, L or C values set to 0 will have the reactive
% components ignored.
%

    arguments
        R (:,1) double { mustBeFinite, mustBePositive }
        f (:,1) double { mustBeFinite, mustBeNonnegative }
        L (:,1) double { mustBeFinite, mustBeNonnegative }
        C (:,1) double { mustBeFinite, mustBeNonnegative }
    end

    % Get rid of capacitive effects where capacitance or frequency was zero.

    zeroFI = abs (f) < eps  ;

    zeroCI = abs (C) < eps;

    zeroFCI = zeroFI | zeroCI ;

    fC = f ;

    fC (zeroFCI) = Inf ;

    C (zeroFCI) = Inf ;

    % Take capacitance into account, if it and the corresponding frequency is non-zero.

    XL = 2i .* pi .* f .* L ;

    XC = - 1i ./ 2 ./ pi ./ fC ./ C ;

    Z = R + XL + XC ;

end % function
