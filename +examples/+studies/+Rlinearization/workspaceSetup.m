% A script for retrieving values from zef and converting them to a suitable format.

electrodePos1 = zef.s2_points([23,27],:);

electrodePos2 = zef.s2_points([34,48],:);

f1 = 1000 ;

f2 = 1010 ;

superNodes1 = zefCore.SuperNode.fromMeshAndPos (zef.nodes',zef.tetra',electrodePos1',nodeRadii=1,attachNodesTo="surface") ;

superNodes2 = zefCore.SuperNode.fromMeshAndPos (zef.nodes',zef.tetra',electrodePos2',nodeRadii=1,attachNodesTo="surface") ;

ee1 = zefCore.ElectrodeSet (innerRadii=0,outerRadii=1,capacitances=3.5e-6,inductances=0,contactSurfaces=superNodes1,positions=[superNodes1.centralNodePos],impedances=2e3,frequencies=f1) ;

ee2 = zefCore.ElectrodeSet (innerRadii=0,outerRadii=1,capacitances=3.5e-6,inductances=0,contactSurfaces=superNodes2,positions=[superNodes2.centralNodePos],impedances=2e3,frequencies=f2) ;

conductivity = zefCore.reshapeTensor (zef.sigma(:,1)) ;

permittivity = zefCore.reshapeTensor (zef.epsilon(:,1)) ;

nodes = zef.nodes ;

tetra = zef.tetra ;

activeI = zef.brain_ind ;

sourceN = 5000 ;

[L1, L2, R1, R2] = examples.studies.Rlinearization.interferenceLeadFields (nodes, tetra, conductivity, permittivity, [ee1 , ee2], zef.brain_ind, sourceN) ;
