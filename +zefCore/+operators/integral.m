function I = integral ( integrands, dV, dims )
%
% I = zefCore.operators.integral ( integrands, dV, dims=[] )
%
% Computes an integral over the dimensions dims, by summing together the
% elementwise products of given integrands and element volumes dV.
%
% Inputs:
%
% - integrands
%
%   The integrands
%
% - dV
%
%   Element "volumes".
%
% - dims = []
%
%   The dimensions along which the summation will be performed. If empty, first
%   non-zero dimension will be used.
%

    arguments
        integrands double { mustBeNonNan }
        dV double { mustBeNonNan }
        dims (1,:) double { mustBePositive, mustBeInteger } = []
    end

    if isempty ( dims )

        I = sum ( integrands .* dV ) ;

    else

        I = sum ( integrands .* dV, dims ) ;

    end % if

end % function
