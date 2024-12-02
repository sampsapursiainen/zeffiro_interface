function DS = dSdZ ( dCdZ, Be, T, B, invAdAdZ, invAdBdZ )
%
% DS = dSdZ ( dCdZ, Be, T, B, invAdAdZ, invAdBdZ )
%
% Computes the derivative of the Schur complement of A in a system
%
%   [ A, B ; B^T, C ] * [ u ; v ] = [ x ; y ]
%
% with respect to an impedance Z.
%

    arguments
        dCdZ     (:,:)
        Be       (:,:)
        T        (:,:)
        B        (:,:)
        invAdAdZ (:,:)
        invAdBdZ (:,:)
    end

    cB = transpose (B) ;

    DS = dCdZ + dCdZ * transpose (Be) * T - cB * invAdAdZ * T + cB * invAdBdZ ;

end % function
