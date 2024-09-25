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
        superNodes (:,1) zefCore.SuperNode
        kwargs.electrodeI (:,:) double { mustBeInteger, mustBePositive, mustBeFinite } = transpose ( [ 4 , 8 ; 3 , 7 ] )
        kwargs.startFreq (1,1) double { mustBeNonnegative, mustBeFinite } = 1000
        kwargs.dFreqs (1,:) double  { mustBePositive, mustBeFinite } = [1, 10, 100, 1000,10000]
        kwargs.capacitance (1,1) double { mustBePositive, mustBeFinite } = 3.5e-6
        kwargs.solverTol (1,1) double { mustBePositive, mustBeFinite } = 1e-9
        kwargs.sourceTetraI (:,1) double { mustBePositive } = 1 : numel (volumeCurrentI)
        kwargs.sourceN (1,1) double { mustBePositive, mustBeInteger } = 5000
    end

    disp ("Positioning sources…")

    [ sourcePos, aggregationN, aggregationI, individualI ] = zefCore.positionSourcesRectGrid ( nodes, tetra, volumeCurrentI, kwargs.sourceN ) ;

    tetV = zefCore.tetraVolume (nodes, tetra,true) ;

    eps0 = 8.8541878188e-12 ;

    epsabs = epsilon .* eps0 ;

    angFreq = 2 * pi * kwargs.startFreq ;

    conductivity = sigma (:,1) - 1i * epsabs * angFreq  ;

    % C = 1.66 to 6.65 μF

    resistance = 2e3 * ones (numel(superNodes),1) ;

    inductance = 0 ;

    Zs = zefCore.impedanceFromRwLC ( resistance, angFreq, inductance, kwargs.capacitance ) ;

    electrodes = zefCore.ElectrodeSet ( positions=elePos, impedances=Zs, outerRadii=[superNodes.radius] ) ;

    disp("Computing stiffness matrix A…")

    conductivity = zefCore.reshapeTensor (conductivity) ;

    iniA = zefCore.stiffnessMat (nodes,tetra,tetV,conductivity);

    disp("Applying boundary conditions to A…")

    A = zefCore.stiffMatBoundaryConditions ( iniA, Zs, superNodes ) ;

    disp("Computing electrode potential matrix B for real and imaginary parts…")

    B = zefCore.potentialMat ( superNodes, Zs, size (nodes,1) );

    disp("Computing electrode impedance matrix C…")

    C = zefCore.impedanceMat (Zs);

    T = zefCore.transferMatrix (A,B,tolerances=kwargs.solverTol,useGPU=true) ;

    S = zefCore.schurComplement (T, ctranspose(B), C) ;

    invS = S \ eye ( size (S) ) ;

    %%

    disp ("Computing volume currents σ∇ψ…")

    [Gx, Gy, Gz] = zefCore.tensorNodeGradient (nodes, tetra, tetV, conductivity, volumeCurrentI) ;

    G = [ Gx ; Gy ; Gz ] ;

    disp ("Computing initial matrices depending on Z...")

    tic ;

    [Lini, Rini] = zefCore.tesLeadField ( T, S, Gx, Gy, Gz, aggregationI, aggregationN ) ;

    toc ;

    %%

    disp ("Saving initial matrices to their own files...")

    Rfile = matfile ("R.mat",Writable=true) ;
    Lfile = matfile ("L.mat",Writable=true) ;

    disp ("R...")
    Rfile.R = Rini ;
    disp ("L...")
    Lfile.L = Lini ;

    %%

    Ms = zefCore.electrodeMassMatrix ( size (A,1), superNodes ) ;

    Bs = zefCore.electrodeBasisFnMean ( size (A,1), superNodes ) ;

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

            linR = Rini ;

            disp ( newline + "linR = R") ;

            newZs = Zs ;

            for jj = 1 : numel (cols)

                col = cols (jj) ;

                disp ( newline + "  + dR/dZ" + col + " * dZ" + col + "...")

                dAdZ = zefCore.dAdZ ( Ms{col}, electrodes.impedances(col), superNodes(col).totalSurfaceArea ) ;

                invAdAdZ = zefCore.invAY (A,dAdZ) ;

                dBdZ = zefCore.dBdZ ( Bs{col}, electrodes.impedances(col) ) ;

                invAdBdZ = zefCore.invAY (A,dBdZ) ;

                dCdZ = zefCore.dCdZ ( electrodes.impedances(col), col, numel(superNodes) ) ;

                dCHdZ = zefCore.dCHdZ ( electrodes.impedances(col), col, numel(superNodes) ) ;

                dSdZ = zefCore.dSdZ ( dCdZ, dCHdZ, Bs{col}, T, B, invAdAdZ, invAdBdZ ) ;

                dRdZ = zefCore.dRdZ ( invAdAdZ, Rini, invAdBdZ, invS, dSdZ ) ;

                newZs (col) = zefCore.impedanceFromRwLC ( real ( newZs (col) ), iiAngFreq, inductance, kwargs.capacitance ) ;

                dZ = newZs (col) - Zs (col) ;

                linR = linR + dRdZ * dZ ;

            end % for jj

            disp ("Computing linearized lead field...")

            linL = transpose ( zefCore.intersperseArray (- G * linR, 1, 3) ) ;

            disp ("Computing new R directly with updated impedances…")

            disp("Applying boundary conditions to A…")

            newA = zefCore.stiffMatBoundaryConditions ( iniA, newZs, superNodes ) ;

            disp("Computing electrode potential matrix B for real and imaginary parts…")

            newB = zefCore.potentialMat ( superNodes, newZs, size (nodes,1) );

            disp("Computing electrode impedance matrix C…")

            newC = zefCore.impedanceMat (newZs);

            newT = zefCore.transferMatrix (newA,newB,tolerances=kwargs.solverTol,useGPU=true) ;

            newS = zefCore.schurComplement (newT, ctranspose(newB), newC) ;

            [refL, refR, ~, ~, ~] = zefCore.tesLeadField ( newT, newS, Gx, Gy, Gz, aggregationI, aggregationN ) ;

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
