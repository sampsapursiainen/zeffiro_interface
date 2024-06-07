function diffA = dAdZ (M,Z,eA)
%
% diffA = dAdZ (M,Z,eA)
%
% Computes the derivative of the stiffness matrix
%
%   A = ∫ σψiψj dV + ∑ 1 / Z / |eA| ∫ψiψj dS
%
% with respect to a given impedance Z.
%
% Inputs:
%
% - M
%
%   The mass matrix ∫ ψi ψj dS computed for the electrode with impedance Z.
%
% - Z
%
%   The impedance of the electrodes corresponding to M.
%
% - eA
%
%   The contact surface area of the electrode corresponding to M and Z.
%

    arguments
        M  (:,:) double { mustBeNumeric }
        Z  (1,:) double
        eA (1,:) double { mustBeNonnegative, mustBeFinite }
    end

    if eA == 0
        eA = 1 ;
    end

    diffA = - M / Z ^ 2 / eA ;

end % function
