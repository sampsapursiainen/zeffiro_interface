function D = dRdZ ( R, M, B, Bint, T, S, Z, eA )
%
% D = dRdZ ( R, M, B, Bint, T, Z, eA )
%
% Computes the derivative of the resistivity matrix R with respect to impedance
% Z.
%
% Inputs:
%
% - R
%
%   The current value of the resistivity matrix.
%
% - M
%
%   A mass matrix ∫ ψi ψj dS corresponding to a single electrode with impedance
%   Z.
%
% - B
%
%   The matrix ∫ ψi dS / Z / eA with all electrodes integrated into it.
%
% - Bint
%
%   A matrix containing the contact surface integral ∫ ψi dS for a single
%   electrode.
%
% - T
%
%   A transfer matrix A \ B.
%
% - S
%
%   The Schur complement of the stiffness matrix A.
%
% - Z
%
%   The impedance we are differentiating with respect to.
%
% - eA
%
%   The total surface area ∫ dS of the electrode with impedance Z.
%
% - eI
%
%   The index of the electrode whose impedance Z we are differentiating with
%   respect to.
%
% - L
%
%   The size of derivatives with respect to C
%

    arguments
        R (:,:) { mustBeNumeric, mustBeFinite }
        M (:,:) { mustBeNumeric, mustBeFinite }
        B (:,:) { mustBeNumeric, mustBeFinite }
        Bint (:,:) { mustBeNumeric, mustBeFinite }
        T (:,:) { mustBeNumeric, mustBeFinite }
        S (:,:) { mustBeNumeric, mustBeFinite }
        Z (1,1) double { mustBeNonNan }
        eA (1,1) double { mustBeFinite, mustBeReal }
        eI (1,1) double { mustBeInteger, mustBePositive, mustBeFinite }
        L (1,1) double { { mustBeInteger, mustBePositive, mustBeFinite } }
    end

    dAdZ = core.dAdZ (M, Z, eA) ;

    dBdZ = core.dAdZ (Bint, Z, eA) ;

    dCdZ = core.dAdZ (Z, eI, L) ;

    % TODO

end % function
