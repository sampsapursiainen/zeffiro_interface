
%% make all reconstructions for data

%set all parameters!
% beamformer app needs to be open
%choose node to add to
%enjoy!

allHashes=fieldnames(zef.dataBank.tree);

allHashes=allHashes(startsWith(allHashes, 'node_1'));

for i=1:length(allHashes)
    if strcmp(zef.dataBank.tree.(allHashes{i}).type, 'data')
        zef.dataBank.hash=allHashes{i};
        zef_dataBank_setData;

        %mne
        [zef.reconstruction, zef.reconstruction_information]=zef_find_mne_reconstruction;
        zef.dataBank.tree=zef_dataBank_add(zef.dataBank.tree, zef.dataBank.hash, zef_dataBank_getData(zef, 'reconstruction'));

        %ramus
        zef_update_ramus_inversion_tool;
        [zef.reconstruction, zef.reconstruction_information]  = zef_ramus_iteration([]);%dipole
        zef.dataBank.tree=zef_dataBank_add(zef.dataBank.tree, zef.dataBank.hash, zef_dataBank_getData(zef, 'reconstruction'));

        %slorata
        [zef.reconstruction, zef.reconstruction_information]=zef_CSM_iteration;
        zef.dataBank.tree=zef_dataBank_add(zef.dataBank.tree, zef.dataBank.hash, zef_dataBank_getData(zef, 'reconstruction'));

        %dipole
        [zef.reconstruction, zef.reconstruction_information]=zef_dipoleScan;
        zef.dataBank.tree=zef_dataBank_add(zef.dataBank.tree, zef.dataBank.hash, zef_dataBank_getData(zef, 'reconstruction'));
        %beamformer

        if strcmp(zef.beamformer.estimation_attr.Value,'1')
            [zef.reconstruction,~, zef.reconstruction_information] = zef_beamformer;
        elseif strcmp(zef.beamformer.estimation_attr.Value,'2')
            [~,zef.reconstruction, zef.reconstruction_information] = zef_beamformer;
        else
            [zef.reconstruction,zef.bf_var_loc, zef.reconstruction_information] = zef_beamformer;
        end
        zef.dataBank.tree=zef_dataBank_add(zef.dataBank.tree, zef.dataBank.hash, zef_dataBank_getData(zef, 'reconstruction'));

    end
end
