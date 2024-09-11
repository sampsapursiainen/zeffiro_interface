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
        kwargs.startFreq (1,1) double { mustBeNonnegative, mustBeFinite } = 1000
        kwargs.dFreqs (1,:) double  { mustBePositive, mustBeFinite } = [1, 10, 100, 1000,10000]
        kwargs.capacitance (1,1) double { mustBePositive, mustBeFinite } = 3.5e-6
        kwargs.solverTol (1,1) double { mustBePositive, mustBeFinite } = 1e-9
        kwargs.sourceTetraI (:,1) double { mustBePositive } = 1 : numel (volumeCurrentI)
        kwargs.sourceN (1,1) double { mustBePositive, mustBeInteger } = 5000
    end

    disp ("Positioning sources…")

    [ ~, sourceTetI ] = core.positionSources ( nodes', tetra (volumeCurrentI,:)', kwargs.sourceN ) ;

    tetV = core.tetraVolume (nodes, tetra,true) ;

    eps0 = 8.8541878188e-12 ;

    epsabs = epsilon .* eps0 ;

    angFreq = 2 * pi * kwargs.startFreq ;

    conductivity = sigma (:,1) - 1i * epsabs * angFreq  ;

    % C = 1.66 to 6.65 μF

    resistance = 2e3 ;

    inductance = 0 ;

    Zs = core.impedanceFromRwLC ( resistance, angFreq, inductance, kwargs.capacitance ) ;

    electrodes = core.ElectrodeSet ( positions=elePos, impedances=Zs, outerRadii=[superNodes.radius] ) ;

    disp("Computing stiffness matrix A…")

    conductivity = core.reshapeTensor (conductivity) ;

    iniA = core.stiffnessMat (nodes,tetra,tetV,conductivity);

    disp("Applying boundary conditions to A…")

    A = core.stiffMatBoundaryConditions ( iniA, Zs, superNodes ) ;

    disp("Computing electrode potential matrix B for real and imaginary parts…")

    B = core.potentialMat ( superNodes, Zs, size (nodes,1) );

    disp("Computing electrode impedance matrix C…")

    C = core.voltageMat (Zs);

    T = core.transferMatrix (A,B,tolerances=kwargs.pcgTol,useGPU=kwargs.useGPU) ;

    S = core.schurComplement (T, ctranspose(B), C) ;

    invS = S \ eye ( size (S) ) ;

    %%

    disp ("Computing initial matrices depending on Z...")

    tic ;

    [Lini, Rini, Gx, Gy, Gz] = core.tesLeadField ( T, S, nodes, tetra, tetV, volumeCurrentI, sourceTetI, conductivity ) ;

    toc ;

    G = [ Gx ; Gy ; Gz ] ;

    %%

    disp ("Saving initial matrices to their own files...")

    Rfile = matfile ("R.mat",Writable=true) ;
    Lfile = matfile ("L.mat",Writable=true) ;

    disp ("R...")
    Rfile.R = Rini ;
    disp ("L...")
    Lfile.L = Lini ;

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

            linR = Rini ;

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

                dRdZ = core.dRdZ ( invAdAdZ, Rini, invAdBdZ, invS, dSdZ ) ;

                newZs (col) = core.impedanceFromRwLC ( real ( newZs (col) ), iiAngFreq, inductance, kwargs.capacitance ) ;

                dZ = newZs (col) - Zs (col) ;

                linR = linR + dRdZ * dZ ;

            end % for jj

            disp ("Computing linearized lead field...")

            linL = core.intersperseArray (- G * linR, 1, 3) ;

            disp ("Computing new R directly with updated impedances…")

            disp("Applying boundary conditions to A…")

            newA = core.stiffMatBoundaryConditions ( iniA, newZs, superNodes ) ;

            disp("Computing electrode potential matrix B for real and imaginary parts…")

            newB = core.potentialMat ( superNodes, newZs, size (nodes,1) );

            disp("Computing electrode impedance matrix C…")

            newC = core.voltageMat (newZs);

            newT = core.transferMatrix (newA,newB,tolerances=kwargs.pcgTol,useGPU=kwargs.useGPU) ;

            newS = core.schurComplement (newT, ctranspose(newB), newC) ;

            [refL, refR, ~, ~, ~] = core.tesLeadField ( newT, newS, nodes, tetra, tetV, volumeCurrentI, sourceTetI, conductivity ) ;

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
