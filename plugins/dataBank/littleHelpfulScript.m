%% repair the stupid databank
%mne reconstruction information is not updated

for i=1:length(zef.reconstructionTool.bankReconstruction)
    if ~strcmp(zef.reconstructionTool.bankReconstruction{i}.reconstruction_information.tag, zef.reconstructionTool.bankInfo{i,1}) %&& ...~strcmp(zef.reconstructionTool.bankReconstruction{i}.reconstruction_information.tag, 'bf')
        zef.reconstructionTool.bankReconstruction{i}.reconstruction_information=[];
        zef.reconstructionTool.bankReconstruction{i}.reconstruction_information.tag=zef.reconstructionTool.bankInfo{i,1};
        disp(i);
    end
end

%% import from the bank

%select the node in the databank first!
%remember to select reconstruction

for nodeIndex=11:15

zef.reconstructionTool.bankInfo{nodeIndex,7}=true;
zef_reconstructionTool_replace;
zef_dataBank_addButtonPress;



end




%% make gmm for every reconstruction

for  i=[0.25, 0.5, 0.75, 0.9]
zef.GMMcluster_threshold =i;
%open gmm tool first and set the parameters
allHashes=fieldnames(zef.dataBank.tree);
for i=1:length(allHashes)
    if strcmp(zef.dataBank.tree.(allHashes{i}).type, 'reconstruction')
        zef.dataBank.hash=allHashes{i};
        zef_dataBank_setData;
        [zef.GMM.model,zef.GMM.dipoles] = zef_GMModeling;
        
        [zef.dataBank.tree, newHash]=zef_dataBank_add(zef.dataBank.tree, allHashes{i}, zef_dataBank_getData(zef, 'gmm'));
        
        zef.dataBank.tree.(newHash).name=strcat('gmm_8_', num2str(100*zef.GMMcluster_threshold));
        if strcmp(zef.dataBank.save2disk, 'On')
            nodeData=zef.dataBank.tree.(newHash).data;
            folderName=strcat(zef.dataBank.folder, newHash);
            save(folderName, '-struct', 'nodeData');
            zef.dataBank.tree.(newHash).data=matfile(folderName);
            
            clear nodeData folderName
        end
        
        
    end
end

end

%% make all reconstructions

%set all parameters!
% beamformer app needs to be open
%choose node to add to
%enjoy!


%mne
[zef.reconstruction, zef.reconstruction_information]=zef_find_mne_reconstruction;
zef_dataBank_addButtonPress;


%ramus
zef_update_ramus_inversion_tool; 
[zef.reconstruction, zef.reconstruction_information]  = zef_ramus_iteration([]);%dipole
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














































