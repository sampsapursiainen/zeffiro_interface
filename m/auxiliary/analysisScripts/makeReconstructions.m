%% make all reconstructions

%set all parameters!
% beamformer app needs to be open and set to 'Locations'
%choose node to add to
%enjoy!

%mne
[zef.reconstruction, zef.reconstruction_information]=zef_find_mne_reconstruction;
zef_dataBank_addButtonPress;

%sLoreta

[zef.reconstruction, zef.reconstruction_information]=zef_CSM_iteration;
zef_dataBank_addButtonPress;

%ramus
zef_update_ramus_inversion_tool;
[zef.reconstruction, zef.reconstruction_information]  = zef_ramus_iteration([]);
zef_dataBank_addButtonPress;

%dipole
[zef.reconstruction, zef.reconstruction_information]=zef_dipoleScan;
zef_dataBank_addButtonPress;

%beamformer
if strcmp(zef.beamformer.estimation_attr.Value,'1')
    [zef.reconstruction,~, zef.reconstruction_information] = zef_beamformer;
elseif strcmp(zef.beamformer.estimation_attr.Value,'2')
    [~,zef.reconstruction, zef.reconstruction_information] = zef_beamformer;
else; [zef.reconstruction,zef.bf_var_loc, zef.reconstruction_information] = zef_beamformer;
end
zef_dataBank_addButtonPress;
