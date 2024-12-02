function DS = dSdZ ( dCdZ, dCHdZ, Be, T, B, invAdAdZ, invAdBdZ )
%
% DS = dSdZ ( dCdZ, dCHdZ, Be, T, B, invAdAdZ, invAdBdZ )
%
% Computes the derivative of the Schur complement of A in a system
%
%   [ A, B ; B^T, C ] * [ u ; v ] = [ x ; y ]
%
% with respect to an impedance Z.
%

    arguments
        dCdZ     (:,:)
        dCHdZ    (:,:)
        Be       (:,:)
        T        (:,:)
        B        (:,:)
        invAdAdZ (:,:)
        invAdBdZ (:,:)
    end

    cB = transpose (B) ;

    DS = dCdZ + dCHdZ * transpose (Be) * T - cB * invAdAdZ * T + cB * invAdBdZ ;


end % function
