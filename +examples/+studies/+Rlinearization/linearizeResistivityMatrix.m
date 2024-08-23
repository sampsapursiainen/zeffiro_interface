function linearizeResistivityMatrix (nodes, tetra, elePos, volumeCurrentI, sigma, epsilon, superNodes, kwargs)
%
% linearizeResistivityMatrix(nodes, tetra, elePos, volumeCurrentI, sigma, epsilon, superNodes, kwargs)
%
% Runs a simulation where a resistivity matrix is first computed, then modified
% via its linearization and compared to another directly computed resistivity
% matrix in the point in the impedance space where the value f the linearly
% modified R was computed.
%
% TODO: add more arguments to allow furher parametrization, and other fixes.
%
    arguments
        nodes (:,3) double { mustBeFinite }
        tetra (:,4) double { mustBeInteger, mustBePositive, mustBeFinite }
        elePos (3,:) double { mustBeFinite }
        volumeCurrentI (:,1) double { mustBeInteger, mustBePositive, mustBeFinite }
        sigma (:,:) double { mustBeFinite }
        epsilon (:,:) double { mustBeFinite }
        superNodes (:,1) core.SuperNode
        kwargs.electrodeI (:,:) double { mustBeInteger, mustBePositive, mustBeFinite } = transpose ( [ 4 , 8 ; 3 , 7 ] )
        kwargs.startFreq (1,1) double { mustBePositive, mustBeFinite } = 1000
        kwargs.dFreqs (1,:) double  { mustBePositive, mustBeFinite } = [1, 10, 100, 1000,10000]
        kwargs.capacitance (1,1) double { mustBePositive, mustBeFinite } = 3.5e-6
        kwargs.solverTol (1,1) double { mustBePositive, mustBeFinite } = 1e-9
        kwargs.sourceTetraI (:,1) double { mustBePositive } = 1 : numel (volumeCurrentI)
    end

    tetV = core.tetraVolume (nodes, tetra,true) ;

    eps0 = 8.8541878188e-12 ;

    epsabs = epsilon .* eps0 ;

    angFreq = 2 * pi * kwargs.startFreq ;

    conductivity = sigma (:,1) - 1i * epsabs * angFreq  ;

    % C = 1.66 to 6.65 μF

    inductance = 0 ;

    Ne = size (elePos,2) ;

    Zs = core.impedanceFromRwLC (2e3*ones(Ne,1), angFreq, inductance, kwargs.capacitance) ;

    electrodes = core.ElectrodeSet ( positions=elePos, impedances=Zs, outerRadii=1e-3 ) ;

    %%

    disp ("Computing volume currents…") ;

    [G1, G2, G3] = core.tensorNodeGradient (nodes, tetra, tetV, core.reshapeTensor (conductivity), volumeCurrentI) ;

    G = [ G1 ; G2 ; G3 ] ;

    % disp( "Count numbers of source indices in output lead field." ) ;

    % uniqueSourceTetraI = unique ( kwargs.sourceTetraI ) ;

    % ustN = numel (uniqueSourceTetraI) ;

    % sourcesPerTetra = zeros ( ustN,1 ) ;

    % for ii = 1 : ustN

    %     sourcesPerTetra (ii) = sum ( kwargs.sourceTetraI == uniqueSourceTetraI (ii) ) ;

    % end % for

    %%

    disp ("Computing initial matrices depending on Z...")

    tic ;

    [ A, B, C, T, S, invS, R ] = matricesDependingOnZ (nodes, tetra, tetV, conductivity, electrodes, superNodes) ;

    toc ;

    keyboard

    %%

    disp ("Computing initial lead field...") ;

    L = intersperseRowsXYZ (- G * R) ;

    %%

    disp ("Saving initial matrices to their own files...")

    Afile = matfile ("A.mat",Writable=true) ;
    Bfile = matfile ("B.mat",Writable=true) ;
    Cfile = matfile ("C.mat",Writable=true) ;
    Tfile = matfile ("T.mat",Writable=true) ;
    Sfile = matfile ("S.mat",Writable=true) ;
    invSfile = matfile ("invS.mat",Writable=true) ;
    Rfile = matfile ("R.mat",Writable=true) ;
    Lfile = matfile ("L.mat",Writable=true) ;

    disp ("A...")
    Afile.A = A ;
    disp ("B...")
    Bfile.B = B ;
    disp ("C...")
    Cfile.C = C ;
    disp ("T...")
    Tfile.T = T ;
    disp ("S...")
    Sfile.S = S ;
    disp ("inv S...")
    invSfile.invS = invS ;
    disp ("R...")
    Rfile.R = R ;
    disp ("L...")
    Lfile.L = L ;

    %%

    Ms = core.electrodeMassMatrix ( size (A,1), superNodes ) ;

    Bs = core.electrodeBasisFnMean ( size (A,1), superNodes ) ;

    dAngFreqs = kwargs.dFreqs .* 2 * pi ;

    newAngFreqs = angFreq + dAngFreqs ;

    Ndf = numel ( kwargs.dFreqs ) ;

    %%

    disp ("Starting linearization of R...") ;

    for eI = 1 : size (kwargs.electrodeI,2)

        cols = kwargs.electrodeI (:,eI) ;

        eleIndStr = strjoin(string(cols),",") ;

        %%

        disp ("Generating file names…") ;

        fileNames = strings ( 1, numel (dAngFreqs) ) ;

        for ii = 1 : Ndf

            dFreq = kwargs.dFreqs (ii) ;

            fileNames (ii) = "ele=" + eleIndStr + "-df=" + dFreq + "Hz.mat" ;

        end % for ii

        %%

        disp ("Computing new R for electrodes " + eleIndStr + " via linearization...")

        for ii = 1 : Ndf

            fileName = fileNames (ii) ;

            disp ( newline + fileName ) ;

            iiAngFreq = newAngFreqs (ii) ;

            mf = matfile ( fileName, Writable=true ) ;

            linR = R ;

            disp ( newline + "linR = R") ;

            newZs = Zs ;

            for jj = 1 : numel (cols)

                col = cols (jj) ;

                disp ( newline + "  + dR/dZ" + col + " * dZ" + col + "...")

                dAdZ = core.dAdZ ( Ms{col}, electrodes.impedances(col), superNodes(col).totalSurfaceArea ) ;

                invAdAdZ = core.invAY (A,dAdZ) ;

                dBdZ = core.dBdZ ( Bs{col}, electrodes.impedances(col) ) ;

                invAdBdZ = core.invAY (A,dBdZ) ;

                dCdZ = core.dCdZ ( electrodes.impedances(col), col, numel(superNodes) ) ;

                dCHdZ = core.dCHdZ ( electrodes.impedances(col), col, numel(superNodes) ) ;

                dSdZ = core.dSdZ ( dCdZ, dCHdZ, Bs{col}, T, B, invAdAdZ, invAdBdZ ) ;

                dRdZ = core.dRdZ ( invAdAdZ, R, invAdBdZ, invS, dSdZ ) ;

                newZs (col) = core.impedanceFromRwLC ( real ( newZs (col) ), iiAngFreq, inductance, kwargs.capacitance ) ;

                dZ = newZs (col) - Zs (col) ;

                linR = linR + dRdZ * dZ ;

            end % for jj

            disp ("Computing new R directly with updated impedances…")

            newElectrodes = electrodes.withImpedances (newZs) ;

            [ ~, ~, ~, ~, ~, ~, refR ] = matricesDependingOnZ (nodes, tetra, tetV, conductivity, newElectrodes, superNodes) ;

            disp ("Computing lead fields…") ;

            refL = intersperseRowsXYZ (- G * refR) ;

            linL = intersperseRowsXYZ (- G * linR) ;

            disp ("Saving new Rs and Ls to file " + fileName + "…") ;

            disp ("linR...")

            mf.linR = linR ;

            disp ("refR...")

            mf.refR = refR ;

            disp ("linL...")

            mf.linL = linL ;

            disp ("refL...")

            mf.refL = refL ;

            disp ("Frequencies and electrodes...")

            mf.startFreq = kwargs.startFreq ;

            mf.dFreqs = kwargs.dFreqs (ii) ;

            mf.electrodeI = cols ;

        end % for ii

    end % for eI

end % function

%% Helper functions.

function [A, B, C, T, S, invS, R] = matricesDependingOnZ (nodes, tetra, tetV, conductivity, electrodes, superNodes)
%
% [A, B, C, T, S, invS, R] = matricesDependingOnZ (nodes, tetra, tetV, conductivity, volumeCurrentI, electrodes, superNodes)
%

    disp("Initializing impedances for sensors…")

    Z = electrodes.impedances ;

    disp("Computing stiffness matrix components reA and imA…")

    conductivity = core.reshapeTensor (conductivity) ;

    A = core.stiffnessMat (nodes,tetra,tetV,conductivity);

    disp("Applying boundary conditions to reA…")

    A = core.stiffMatBoundaryConditions ( A, Z, superNodes ) ;

    disp("Computing electrode potential matrix B for real and imaginary parts…")

    B = core.potentialMat ( superNodes, Z, size (nodes,1) );

    disp("Computing electrode voltage matrix C…")

    C = core.voltageMat (Z);

    disp("Computing transfer matrix and Schur complement for real part. This will take a (long) while.")

    T = core.transferMatrix (A,B,tolerances=1e-7,useGPU=true) ;

    disp ("Computing resistivity matrix R…") ;

    S = (C - ctranspose (B) * T) ;

    I = eye ( size (S) ) ;

    invS = S \ I ;

    R = T * invS ;

end % function

function M = intersperseRowsXYZ(M)

    Mcopy = M ;

    N = size (M,1) / 3 ;

    M (1:3:end,:) = Mcopy (1:N,:) ;
    M (2:3:end,:) = Mcopy (N+1:2*N,:) ;
    M (3:3:end,:) = Mcopy (2*N+1:3*N,:) ;

end % function

function M = intersperseColsXYZ(M)

    Mcopy = M ;

    N = size (M,1) / 3 ;

    M (:,1:3:end) = Mcopy (:,1:N) ;
    M (:,2:3:end) = Mcopy (:,N+1:2*N) ;
    M (:,3:3:end) = Mcopy (:,2*N+1:3*N) ;

end % function

function L = parcellateLeadField (L, uniqueSourceTetraI, sourcesPerTetra)
%
% L = parcellateLeadField (L, uniqueSourceTetraI, sourcesPerTetra)
%
% Restricts a given lead field to a given set of source positions and
% normalizes its rows based on how many sources were placed into each active
% element.
%
    arguments
        L (:,:) double { mustBeFinite }
        uniqueSourceTetraI (1,:) double { mustBePositive, mustBeInteger }
        sourcesPerTetra (1,:) double { mustBePositive, mustBeInteger }
    end

    % Restrict lead field to the wanted source positions.

    ustI = uniqueSourceTetraI ;

    restrI = intersperseRowsXYZ ( [ ustI ; (ustI+1) ; (ustI+2) ] ) ;

    L = L (restrI,:) ;

    % Normalize the rows based on how many sources there are in each active element.

    L = L ./ repelem ( sourcesPerTetra, 3, 1 ) ;

end % function
