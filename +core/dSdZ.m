function DS = dSdZ ( dCdZ, dCHdZ, Be, T, B, A, Z, Me, eA, eI, kwargs )
%
% DS = dSdZ ( dCdZ, dCHdZ, Be, T, B, A, Z, Me, eA, kwargs )
%
% Computes the derivative of the Schur complement of A in a system
%
%   [ A, B ; B', C ] * [ u ; v ] = [ x ; y ]
%
% with respect to an impedance Z.
%

    arguments
        dCdZ   (:,:)
        dCHdZ  (:,:)
        Be     (:,:)
        T      (:,:)
        B      (:,:)
        A      (:,:)
        Z      (1,1)
        Me     (:,:)
        eA     (1,1)
        eI     (1,1)
        kwargs.tolerance (1,1) double { mustBePositive, mustBeFinite } = 1e-8
    end

    cB = ctranspose (B) ;

    MT = Me * T / Z ^ 2 / eA ;

    T1 = core.transferMatrix ( A, MT, useGPU=true, tolerances=kwargs.tolerance) ;

    t2 = core.transferMatrix ( A, Be (:,eI), useGPU=true, tolerances=kwargs.tolerance) ;

    [Tr,Tc] = size (T) ;

    T2 = sparse ( Tr, Tc ) ;

    T2 (:,eI) = t2 ;

    DS = dCdZ ...
        + dCHdZ * transpose (Be) * T ...
        - cB * T1 ...
        - cB * T2 ;


end % function
