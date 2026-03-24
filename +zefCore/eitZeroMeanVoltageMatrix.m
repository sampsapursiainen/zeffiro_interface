function R = eitZeroMeanVoltageMatrix (L)
%
% R = eitZeroMeanVoltageMatrix (L)
%
% For an EIT system
%
%   [A , B ; B' ; C ] * [ u ; v ] = [ -Gx ; I ]
%
% where the vector v can be solved from
%
%   (C - B' * inv(A) * B) v = I ,
%
% the zero-mean potential vector y should be solvable via the equation y = Rv,
% where R is the L-by-L output of this function.
%

    arguments
        L (1,1) double { mustBePositive, mustBeInteger, mustBeFinite }
    end

    I = 1 : L ;

    [rows, cols] = meshgrid (I,I) ;

    eqI = rows == cols ;

    neqI = rows ~= cols ;

    R = zeros (L,L) ;

    R (eqI) = 1 - 1 / L ;

    R (neqI) = - 1 / L ;

end % function
