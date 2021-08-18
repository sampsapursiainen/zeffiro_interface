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

%%
for i=1:15
zef_update_fss; 
zef.measurements = zef_find_source;
zef_dataBank_addButtonPress;
end



%% make all reconstructions for data

%set all parameters!
% beamformer app needs to be open
%choose node to add to
%enjoy!

    
allHashes=fieldnames(zef.dataBank.tree);

allHashes=allHashes(startsWith(allHashes, 'node_2'));



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

%% make gmm for every reconstruction


for  ii=[0, 0.25, 0.5, 0.75, 0.9]

    
    %open gmm tool first and set the parameters
    
    zef.GMM.parameters{5,2}={num2str(ii)};
    
allHashes=fieldnames(zef.dataBank.tree);

allHashes=allHashes(startsWith(allHashes, 'node_1_3'));



for i=1:length(allHashes)
    if strcmp(zef.dataBank.tree.(allHashes{i}).type, 'reconstruction')
        zef.dataBank.hash=allHashes{i};
        zef_dataBank_setData;
         [zef.GMM.model,zef.GMM.dipoles,zef.GMM.amplitudes,zef.GMM.time_variables] = zef_GMModeling;
        
        [zef.dataBank.tree, newHash]=zef_dataBank_add(zef.dataBank.tree, allHashes{i}, zef_dataBank_getData(zef, 'gmm'));
        
        zef.dataBank.tree.(newHash).name=strcat('gmm_8_', num2str(100*ii));
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




%% delete all x

dltType='gmm';


onlyIn='node';

allHashes=fieldnames(zef.dataBank.tree);
allHashes=allHashes(startsWith(allHashes, onlyIn));


i=1;

while i<=length(allHashes)
    
    
    
    if strcmp(zef.dataBank.tree.(allHashes{i}).type, dltType)
        zef.dataBank.hash=allHashes{i};
        zef.dataBank.tree=zef_dataBank_delete(zef.dataBank.tree, zef.dataBank.hash);
        %zef_dataBank_uiTreeDeleteHash(zef.dataBank.app.Tree, zef.dataBank.hash);
        allHashes=fieldnames(zef.dataBank.tree);
        allHashes=allHashes(startsWith(allHashes, onlyIn));
        
        i=1;
    else
        i=i+1;
    end
    
end
    
%% make gmm for every reconstruction Quantile version


for  ii=[0.1 0.25, 0.5, 0.75, 0.9]

    
    %open gmm tool first and set the parameters
    
    
allHashes=fieldnames(zef.dataBank.tree);

allHashes=allHashes(startsWith(allHashes, 'node_1_3'));



for i=1:length(allHashes)
    if strcmp(zef.dataBank.tree.(allHashes{i}).type, 'reconstruction')
        zef.dataBank.hash=allHashes{i};
        zef_dataBank_setData;
        
        
        values=nan(length(zef.reconstruction{1})/3,1);
        j=1;
        for k=1:3:length(zef.reconstruction{1})
            values(j)=zef.reconstruction{1}(k)^2+zef.reconstruction{1}(k+1)^2+zef.reconstruction{1}(k+2)^2;
            j=j+1;
        end

        zef.GMM.parameters{5,2}={num2str(quantile(values, ii))};
        
        
        
        [zef.GMM.model,zef.GMM.dipoles,zef.GMM.amplitudes,zef.GMM.time_variables] = zef_GMModeling;
        
        [zef.dataBank.tree, newHash]=zef_dataBank_add(zef.dataBank.tree, allHashes{i}, zef_dataBank_getData(zef, 'gmm'));
        
        zef.dataBank.tree.(newHash).name=strcat('gmm_10_quantile', num2str(100*ii));
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


