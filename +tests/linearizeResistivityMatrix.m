
nodes = zef.nodes ;

tetra = zef.tetra ;

tetV = core.tetraVolume (nodes, tetra,true) ;

volumeCurrentI = zef.brain_ind ;

sourceN = 5000 ;

eps0 = 8.8541878188e-12 ;

epsr = 164060 ;

epsabs = epsr * eps0 ;

freq = 1000 ;

angFreq = 2 * pi * freq ;

conductivity = zef.sigma (:,1) - 1i * epsabs * angFreq  ;

% C = 1.66 to 6.65 μF

capacitance = 1.66e-6 ;

inductance = 0 ;

Z = core.impedanceFromRwLC (2e3,1000,inductance,capacitance) ;

electrodes = core.ElectrodeSet ( positions=zef.sensors(:,1:3)' / 1e3, impedances=Z, outerRadii=1e-3 ) ;

disp ("Positioning sources…")

[ ~, sourceTetI ] = core.positionSources ( nodes', tetra (volumeCurrentI,:)', sourceN ) ;

attachSensorsTo = "surface" ;

disp("Attaching sensors to the head " + attachSensorsTo + "…")

superNodes = core.SuperNode.fromMeshAndPos (nodes',tetra',electrodes.positions,nodeRadii=electrodes.outerRadii,attachNodesTo=attachSensorsTo) ;

%%

[ A, B, C, T, S, invS, R ] = matricesDependingOnZ (nodes, tetra, tetV, conductivity, electrodes, superNodes) ;

disp ("Computing derivative of R…")

Ms = core.electrodeMassMatrix ( size (A,1), superNodes ) ;

Bs = core.electrodeBasisFnMean ( size (A,1), superNodes ) ;

col = 100 ;

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

dAngFreqs = [ 40, 80, 160, 320, 620 ] ;

linAngFreqs = angFreq + dAngFreqs ;

%%

for ii = 1 : numel (dAngFreqs)

    iiAngFreq = linAngFreqs (ii) ;

    dAngFreq = dAngFreqs (ii) ;

    Zcol = electrodes.impedances (col) ;

    Zii = core.impedanceFromRwLC ( real (Zcol), iiAngFreq, inductance, capacitance ) ;

    dZ = Zii - Zcol ;

    newRLin = R + dRdZ * dZ ;

    fileName = "linRdω=" + dAngFreq + "Hz.mat" ;

    disp ( newline + fileName ) ;

    mf = matfile (fileName, Writable=true) ;

    disp ("Computing new R with updated impedances…")

    newElectrodes = core.ElectrodeSet ( positions=zef.sensors(:,1:3)' / 1e3, impedances=[electrodes.impedances(1:col-1) ; Z+dZ ; electrodes.impedances(col+1:end)], outerRadii=1e-3 ) ;

    [ ~, ~, ~, ~, ~, ~, newR ] = matricesDependingOnZ (nodes, tetra, tetV, conductivity, newElectrodes, superNodes) ;

    mf.newRLin = newRLin ;

    mf.newR = newR ;

    disp ("Plotting differences…")

    Rdiff = abs ( newR - newRLin ) ;

    fig = figure (ii) ;

    title ("dZ=" + dZ) ;

    xlabel ("rows") ;

    ylabel ("cols") ;

    colormap ("hot") ;

    imagesc(log10(Rdiff)) ;

    colorbar ;

    figure (ii)

end % for

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
