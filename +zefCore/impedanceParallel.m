function Z = impedanceParallel (R, f, L, C)
%
% Z = impedanceParallel (R, f, L, C)
%
% Computes the impedance of a single electrical component, supposing that in
% the simplified circuit diagram of the component, resistance, inductance and
% capacitance are parallel. When given zero frequencies f, inductances L or capacitances C,
% the inductive and/or capacitive effects are ignored.
%

    arguments
        R (:,1) double { mustBePositive, mustBeFinite }
        f (:,1) double { mustBeNonnegative, mustBeFinite }
        L (:,1) double { mustBeNonnegative, mustBeFinite }
        C (:,1) double { mustBeNonnegative, mustBeFinite }
    end

    fC = f ;

    % Inductive reactance with zeros and imaginary infinities eliminated.

    XL = 2i .* pi .* f .* L ;

    zeroXLI = zeroOrInfCheck (XL) ;

    XL (zeroXLI) = Inf ;

    % Capacitive reactance, where division by zero and imaginary infinities have been eliminated.

    zeroCI = fC < eps | C < eps ;

    fC (zeroCI) = Inf ;

    nonZeroC = C ;

    nonZeroC (zeroCI) = Inf ;

    XC = - 1i ./ 2 ./ pi ./ fC ./ nonZeroC ;

    zeroXCI = zeroOrInfCheck (XC) ;

    XC (zeroXCI) = Inf ;

    % The impedance itself.

    onePerZ = 1 ./ R + 1 ./ XL + 1 ./ XC ;

    Z = 1 ./ onePerZ ;

end % function

%% Helper functions.

function I = zeroOrInfCheck (A)
%
% Checks which zeros need to be eliminated from a given array.
%

    arguments
        A (:,1) double
    end

    I = abs (A) < eps | isinf (A) ;

end
