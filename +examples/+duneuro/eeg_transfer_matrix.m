
currentTime = datetime("now", Format="yyyy-MM-dd-HH-mm-ss-SSS") ;

HOME = getenv("HOME") ;

Documents = fullfile(HOME, "Documents") ;

matlabDir = fullfile(Documents,"MATLAB") ;

dataDir = fullfile(matlabDir, "example_data") ;

meshPath = fullfile(dataDir, "tet_volume_conductor.mat") ;

dipolePath = fullfile(dataDir, "tet_dipole_superficial.mat") ;

electrodePath = fullfile(dataDir, "tet_electrodes.mat") ;

meshFile = matfile(meshPath) ;

dipoleFile = matfile(dipolePath) ;

electrodeFile = matfile(electrodePath) ;

dipoles = [dipoleFile.dipole_position' ; dipoleFile.dipole_moment' ] ;

[driverConfig, electrodeConfig] = zeffiro.duneuro.duneuroConfig(nodes=meshFile.nodes, elements=meshFile.elements, labels=meshFile.labels, tensors=meshFile.tensors, dipoles=dipoles) ;

driver = duneuro.duneuro_meeg(driverConfig) ;

driver.set_electrodes(electrodeFile.electrodes,electrodeConfig) ;

eegT = zeffiro.duneuro.eeg_transfer_matrix(driverConfig, driver) ;

outputFileName = "duneuro.eegT." + string(currentTime) + ".mat" ;

outputFile = matfile(outputFileName, Writable=true) ;

outputFile.eegT = eegT ;
