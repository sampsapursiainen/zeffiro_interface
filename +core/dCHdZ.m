function out = dCHdZ (Z,eI,L)
%
% out = dCHdZ (Z,eI,L)
%
% Computes the derivative of the L × L diagonal matrix
%
%   ctranspose C = diag ( Z / |Z| ^ 2 )
%
% with respect to a given impedance Z.
%
% Inputs:
%
% - Z
%
%   The impedance of the electrode under observation.
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

    Zcoeff = ( abs (Z) - 2 * Z ) / abs (Z) ^ 3 ;

    out = sparse ( eI, eI, Zcoeff, L, L ) ;

end % function
