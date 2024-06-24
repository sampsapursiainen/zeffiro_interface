tic
nodes = zef.nodes ;

tetra = zef.tetra ;

tetV = core.tetraVolume (nodes, tetra,true) ;

volumeCurrentI = zef.brain_ind ;

electrodeI = [ 4 , 8 ; 3 , 7 ]' ;

Nec = numel (electrodeI) ;

sourceN = 5000 ;

eps0 = 8.8541878188e-12 ;

epsabs = zef.epsilon .* eps0 ;

freq = 1000 ;

angFreq = 2 * pi * freq ;

conductivity = zef.sigma (:,1) - 1i * epsabs * angFreq  ;

% C = 1.66 to 6.65 μF

capacitance = 3.5e-6 ;

inductance = 0 ;

Z = core.impedanceFromRwLC (2e3,1000,inductance,capacitance) ;

electrodes = core.ElectrodeSet ( positions=zef.sensors(:,1:3)' / 1e3, impedances=Z, outerRadii=1e-3 ) ;

disp ("Positioning sources…")

[ ~, sourceTetI ] = core.positionSources ( nodes', tetra (volumeCurrentI,:)', sourceN ) ;

attachSensorsTo = "surface" ;

disp("Attaching sensors to the head " + attachSensorsTo + "…")

superNodes = core.SuperNode.fromMeshAndPos (nodes',tetra',electrodes.positions,nodeRadii=electrodes.outerRadii,attachNodesTo=attachSensorsTo) ;

disp ("Computing volume currents…") ;

[G1, G2, G3] = core.tensorNodeGradient (nodes, tetra, tetV, core.reshapeTensor (conductivity), volumeCurrentI) ;

G = [ G1 ; G2 ; G3 ] ;

%%

[ A, B, C, T, S, invS, R ] = matricesDependingOnZ (nodes, tetra, tetV, conductivity, electrodes, superNodes) ;

disp ("Computing derivative of R…")

Ms = core.electrodeMassMatrix ( size (A,1), superNodes ) ;

Bs = core.electrodeBasisFnMean ( size (A,1), superNodes ) ;

for eI = 1 : numel (electrodeI)

    col = electrodeI (eI) ;

    dAdZ = core.dAdZ ( Ms{col}, electrodes.impedances(col), superNodes(col).totalSurfaceArea ) ;

    invAdAdZ = core.invAY (A,dAdZ) ;

    dBdZ = core.dBdZ ( Bs{col}, electrodes.impedances(col) ) ;

    invAdBdZ = core.invAY (A,dBdZ) ;

    %%

    dCdZ = core.dCdZ ( electrodes.impedances(col), col, numel(superNodes) ) ;

    dCHdZ = core.dCHdZ ( electrodes.impedances(col), col, numel(superNodes) ) ;

    dSdZ = core.dSdZ ( dCdZ, dCHdZ, Bs{col}, T, B, invAdAdZ, invAdBdZ ) ;

    dRdZ = core.dRdZ ( invAdAdZ, R, invAdBdZ, invS, dSdZ ) ;

    disp ("Computing new R with linearization…")

    dFreqs = [ 1, 3, 9, 27, 81, 243, 729, 2187 ] ;

    dAngFreqs = dFreqs .* 2 * pi ;

    linAngFreqs = angFreq + dAngFreqs ;

    %%

    disp ("Generating file names…") ;

    fileNames = strings ( 1, numel (dAngFreqs) ) ;

    for ii = 1 : numel (dAngFreqs)

        dFreq = dFreqs (ii) ;

        fileNames (ii) = "linR_ele=" + col + "_df=" + dFreq + "Hz.mat" ;

    end % for ii

    %%

    disp ("Comparing computed and linearized resistivity matrices in a loop…")

    for ii = 1 : numel (dAngFreqs)

        iiAngFreq = linAngFreqs (ii) ;

        dAngFreq = dAngFreqs (ii) ;

        Zcol = electrodes.impedances (col) ;

        Zii = core.impedanceFromRwLC ( real (Zcol), iiAngFreq, inductance, capacitance ) ;

        dZ = Zii - Zcol ;

        newRLin = R + dRdZ * dZ ;

        fileName = fileNames (ii) ;

        disp ( newline + fileName ) ;

        mf = matfile (fileName, Writable=true) ;

        disp ("Computing new R with updated impedances…")

        newElectrodes = core.ElectrodeSet ( positions=zef.sensors(:,1:3)' / 1e3, impedances=[electrodes.impedances(1:col-1) ; Z+dZ ; electrodes.impedances(col+1:end)], outerRadii=1e-3 ) ;

        [ ~, ~, ~, ~, ~, ~, newR ] = matricesDependingOnZ (nodes, tetra, tetV, conductivity, newElectrodes, superNodes) ;

        disp ("Computing lead fields…") ;

        newL = - G * newR ;

        newLcopy = newL ;

        newLLin = - G * newRLin ;

        newLLinCopy = newLLin ;

        disp ("Interspersing lead field xyz-components…") ;

        Nvc = numel (volumeCurrentI) ;

        newL (1:3:end,:) = newLcopy (1:Nvc,:) ;
        newL (2:3:end,:) = newLcopy (Nvc+1:2*Nvc,:) ;
        newL (3:3:end,:) = newLcopy (2*Nvc+1:3*Nvc,:) ;

        newLLin (1:3:end,:) = newLLinCopy (1:Nvc,:) ;
        newLLin (2:3:end,:) = newLLinCopy (Nvc+1:2*Nvc,:) ;
        newLLin (3:3:end,:) = newLLinCopy (2*Nvc+1:3*Nvc,:) ;

        disp ("Saving new Rs and Ls to file " + fileName + "…") ;

        mf.newRLin = newRLin ;

        mf.newR = newR ;

        mf.newLLin = newLLin ;

        mf.newL = newL ;

        % disp ("Plotting differences…")

        % Rdiff = abs ( newR - newRLin ) ;

        % fig = figure (ii) ;

        % title ("dZ=" + dZ) ;

        % xlabel ("rows") ;

        % ylabel ("cols") ;

        % colormap ("jet") ;

        % imagesc(log10(Rdiff)) ;

        % colorbar ;

        % figure (ii)

    end % for

    %%

    % disp ("Picturing differences between computed and linearized lead fields…") ;

    % for ii = 1 : numel (fileNames)

    %     fileName = fileNames (ii) ;

    %     mf = matfile (fileName) ;

    %     newL = mf.newL ;

    %     newLLin = mf.newLLin ;

    %     Ldiff = abs ( newLLin' - newL' ) ;

    %     fig = figure (ii) ;

    %     title ("dω=" + dZ) ;

    %     xlabel ("rows") ;

    %     ylabel ("cols") ;

    %     colormap ("jet") ;

    %     imagesc(log10(Ldiff)) ;

    %     colorbar ;

    %     figure (ii)

    % end % for

end % for eI
toc
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

function out = cellSum (cellArray)
%
% Sums together (for example) sparse arrays stored in a cell array.
%
    Nc = numel (cellArray) ;

    out = cellArray {1} ;

    for ii = 2 : Nc

        out = out + cellArray {ii} ;

    end % for

end % function
