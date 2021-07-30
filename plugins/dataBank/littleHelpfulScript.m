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

%open gmm tool first and set the parameters
allHashes=fieldnames(zef.dataBank.tree);
for i=1:length(allHashes)
    if strcmp(zef.dataBank.tree.(allHashes{i}).type, 'reconstruction')
        zef.dataBank.hash=allHashes{i};
        zef_dataBank_setData;
        [zef.GMM.model,zef.GMM.dipoles] = zef_GMModeling;
        
        [zef.dataBank.tree, newHash]=zef_dataBank_add(zef.dataBank.tree, allHashes{i}, zef_dataBank_getData(zef, 'gmm'));
        
        zef.dataBank.tree.(newHash).name='gmm_8_50';
        if strcmp(zef.dataBank.save2disk, 'On')
            nodeData=zef.dataBank.tree.(newHash).data;
            folderName=strcat(zef.dataBank.folder, newHash);
            save(folderName, '-struct', 'nodeData');
            zef.dataBank.tree.(newHash).data=matfile(folderName);
            
            clear nodeData folderName
        end
        
        
    end
end


%%

zef_dipole_start;
zef_ramus_iteration

