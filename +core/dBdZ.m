function diffB = dBdZ (Bint, Z)
%
% diffB = dBdZ (Bint, Z)
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
    end

    diffB = - Bint / Z ^ 2 ;

end % function
