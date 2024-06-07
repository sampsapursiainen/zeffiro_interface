function diffB = dBdZ (Bint, Z, eA)
%
% diffB = dBdZ ()
%
% Computes the derivative of the matrix
%
%   B = ∫ ψi dS / Z / eA
%
% Inputs:
%
% - Bint
%
%   The integral ∫ ψi dS corresponding to the contact surface of an electrode.
%
% - Z
%
%   The impedance of the electrode.
%
% - eA
%
%   The total area of the electrode.
%

    arguments
        Bint (:,:) double { mustBeFinite }
        Z    (1,1) double { mustBeNonNan }
        eA   (1,1) double { mustBeNonnegative, mustBeFinite }
    end

    diffB = - intB / Z ^ 2 / eA ;

end % function
