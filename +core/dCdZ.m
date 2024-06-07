function out = dCdZ (Z,eI,L)
%
% out = dCdZ (Z,eI,L)
%
% Computes the derivative of the L × L diagonal matrix
%
%   C = diag ( 1 / Z )
%
% with respect to a given impedance Z.
%
% Inputs:
%
% - Z
%
%   The impedance of the electrodes corresponding to M.
%
% - eI
%
%   The diagonal index which the electrode impedance corresponds to.
%
% - L
%
%   The size of the output matrix.
%

    arguments
        Z  (1,:) double { mustBeNonNan }
        eI (1,1) double { mustBeInteger, mustBePositive, mustBeFinite }
        L  (1,1) double { mustBeInteger, mustBePositive, mustBeFinite }
    end

    out = sparse ( eI, eI, - 1 / Z ^ 2, L, L ) ;

end % function
