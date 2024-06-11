function D = dRdZ ( invAdAdZ, R, invAdBdZ, invS, dSdZ )
%
% DR = dRdZ ( invAdAdZ, R, invAdBdZ, invS, dSdZ )
%
% Computes the derivative of the resistivity matrix R with respect to impedance
% Z.
%
% Inputs:
%
% - invAdAdZ
%
%   The stiffness matrix A inverted with respect to the derivative of the
%   stiffness matrix with respect to the impedance Z.
%
% - R
%
%   The current value of the resistivity matrix.
%
% - invAdBdZ
%
%   The stiffness matrix A inverted with respect to the derivative of the
%   matrix B = ∫ ψi dS / Z / eA with respect to the impedance Z.
%
% - invS
%
%   The inverse of the Schur complement of the stiffness matrix A.
%
% - dSdZ
%
%   The derivative of the Schur complement with respect to the impedance Z.
%
%

    arguments
        invAdAdZ (:,:) { mustBeNumeric, mustBeFinite }
        R        (:,:) { mustBeNumeric, mustBeFinite }
        invAdBdZ (:,:) { mustBeNumeric, mustBeFinite }
        invS     (:,:) { mustBeNumeric, mustBeFinite }
        dSdZ     (:,:) { mustBeNumeric, mustBeFinite }
    end

    disp ("Computing dRdZ…") ;

    D = - invAdAdZ * R + invAdBdZ * invS - R * dSdZ * invS ;

end % function
