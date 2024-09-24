function newR = linearizeResistivityMatrix (iniR, A, B, T, invS, electrodes, dfs, colI, kwargs)
%
% newR = linearizeResistivityMatrix (iniR, A, B, T, invS, electrodes, dfs, colI, kwargs)
%
% Given an initial resistivity matrix iniR and a set of frequency perturbations df,
% computes a new resistivity matrix newR via the linearization
%
%   newR = iniR + sum ( ∂R/∂Z * dZ )
%
% Inputs:
%
% - iniR
%
%   The initial value of the resistivity matrix being linearized.
%
% - A
%
%   Stiffness matrix of the related finite element mesh.
%
% - B
%
%   The basis function mean potential matrix divided by the respective electrode impedances.
%
% - T
%
%   A transfer matrix inv A * B.
%
% - invS
%
%   The inverse of a Schur complement of A in the system [ A, B, B', C ].
%
% - electrodes
%
%   A set of electrodes that iniR was computed with.
%
% - dfs
%
%   The frequencies that the electrode stimultion frequencies will be perturbed by.
%
% - colI
%
%   The indices subset of the columns of iniR that will be differentiated with
%   respect to.
%
%

    arguments
        iniR
        A          (:,:) double { mustBeFinite }
        B          (:,:) double { mustBeFinite }
        T          (:,:) double { mustBeFinite }
        invS       (:,:) double { mustBeFinite }
        electrodes (1,1) zefCore.ElectrodeSet
        dfs        (:,1) double { mustBeFinite }
        colI       (:,1) double { mustBePositive, mustBeInteger }
        kwargs.indent (1,1) double { mustBeNonnegative, mustBeInteger } = 2
    end

    disp (newline + "Linearizing resistivity matrix. newR = newR" + newline) ;

    contactSurfaces = electrodes.contactSurfaces ;

    Ms = zefCore.electrodeMassMatrix ( size (A,1), contactSurfaces ) ;

    Bs = zefCore.electrodeBasisFnMean ( size (A,1), contactSurfaces ) ;

    electrodeN = numel (electrodes) ;

    modifiedN = numel (colI) ;

    newR = iniR ;

    newElectrodes = electrodes ;

    for ii = 1 : modifiedN

        col = colI (ii) ;

        disp ( newline + kwargs.indent + "+ dR/dZ" + col + " * dZ" + col + "...")

        Zs = newElectrodes.impedances ;

        Z = Zs (col) ;

        contactSurface = contactSurfaces (col) ;

        dAdZ = zefCore.dAdZ ( Ms{col}, Z, contactSurface.totalSurfaceArea ) ;

        invAdAdZ = zefCore.invAY (A,dAdZ) ;

        dBdZ = zefCore.dBdZ ( Bs{col}, Z ) ;

        invAdBdZ = zefCore.invAY (A,dBdZ) ;

        dCdZ = zefCore.dCdZ ( Z, col, electrodeN ) ;

        dCHdZ = zefCore.dCHdZ ( Z, col, electrodeN ) ;

        dSdZ = zefCore.dSdZ ( dCdZ, dCHdZ, Bs{col}, T, B, invAdAdZ, invAdBdZ ) ;

        dRdZ = zefCore.dRdZ ( invAdAdZ, Rini, invAdBdZ, invS, dSdZ ) ;

        df = dfs (ii) ;

        newElectrodes = newElectrodes.withPerturbedFrequencies (col,df) ;

        dZ = newElectrodes.impedances (col) - electrodes.impedances (col) ;

        newR = newR + dRdZ * dZ ;

    end % for jj

end % function
