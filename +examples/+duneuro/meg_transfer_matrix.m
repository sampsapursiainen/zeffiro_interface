
currentTime = datetime("now", Format="yyyy-MM-dd-HH-mm-ss-SSS") ;

HOME = getenv("HOME") ;

Documents = fullfile(HOME, "Documents") ;

matlabDir = fullfile(Documents,"MATLAB") ;

dataDir = fullfile(matlabDir, "example_data") ;

meshPath = fullfile(dataDir, "tet_volume_conductor.mat") ;

dipolePath = fullfile(dataDir, "tet_dipole_superficial.mat") ;

coilPath = fullfile(dataDir, "tet_meg_sensors.mat") ;

meshFile = matfile(meshPath) ;

dipoleFile = matfile(dipolePath) ;

coilFile = matfile(coilPath) ;

dipoles = [dipoleFile.dipole_position' ; dipoleFile.dipole_moment' ] ;

[driverConfig, ~] = zeffiro.duneuro.duneuroConfig(nodes=meshFile.nodes, elements=meshFile.elements, labels=meshFile.labels, tensors=meshFile.tensors, dipoles=dipoles) ;

driver = duneuro.duneuro_meeg(driverConfig) ;

driver.set_coils_and_projections(coilFile.coils, coilFile.projections) ;

megT = driver.compute_meg_transfer_matrix(driverConfig) ;

outputFileName = "duneuro.megT." + string(currentTime) + ".mat" ;

outputFile = matfile(outputFileName, Writable=true) ;

outputFile.eegT = megT ;
