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

allHashes=allHashes(startsWith(allHashes, 'node_1'));



for i=1:length(allHashes)
    if strcmp(zef.dataBank.tree.(allHashes{i}).type, 'data')
        zef.dataBank.hash=allHashes{i};
        zef_dataBank_setData;
        
        
        
%         %mne
%         [zef.reconstruction, zef.reconstruction_information]=zef_find_mne_reconstruction;
%         zef.dataBank.tree=zef_dataBank_add(zef.dataBank.tree, zef.dataBank.hash, zef_dataBank_getData(zef, 'reconstruction'));
%         
        
        %ramus
        zef_update_ramus_inversion_tool;
        [zef.reconstruction, zef.reconstruction_information]  = zef_ramus_iteration([]);%dipole
        zef.dataBank.tree=zef_dataBank_add(zef.dataBank.tree, zef.dataBank.hash, zef_dataBank_getData(zef, 'reconstruction'));
        
        %slorata
        [zef.reconstruction, zef.reconstruction_information]=zef_CSM_iteration;
        zef.dataBank.tree=zef_dataBank_add(zef.dataBank.tree, zef.dataBank.hash, zef_dataBank_getData(zef, 'reconstruction'));

        
        
%         %dipole
%         [zef.reconstruction, zef.reconstruction_information]=zef_dipoleScan;
%         zef.dataBank.tree=zef_dataBank_add(zef.dataBank.tree, zef.dataBank.hash, zef_dataBank_getData(zef, 'reconstruction'));
%         %beamformer
%         
%         
%         if strcmp(zef.beamformer.estimation_attr.Value,'1')
%             [zef.reconstruction,~, zef.reconstruction_information] = zef_beamformer;
%         elseif strcmp(zef.beamformer.estimation_attr.Value,'2')
%             [~,zef.reconstruction, zef.reconstruction_information] = zef_beamformer;
%         else
%             [zef.reconstruction,zef.bf_var_loc, zef.reconstruction_information] = zef_beamformer;
%         end
%         zef.dataBank.tree=zef_dataBank_add(zef.dataBank.tree, zef.dataBank.hash, zef_dataBank_getData(zef, 'reconstruction'));
%         
        
        
    end
end

%% make gmm for every reconstruction

for gmm_opt=1:3
    
    zef.GMM.parameters{23,2}={num2str(gmm_opt)};
    
    switch gmm_opt
        case 1
            meth='_kmeans';
        case 2
            meth='_maxProb_';
        case 3
            meth='_maxComp_';
    end

for  ii=[0.25, 0.5, 0.75]

    
    %open gmm tool first and set the parameters
    
    zef.GMM.parameters{5,2}={num2str(ii)};
    
allHashes=fieldnames(zef.dataBank.tree);

allHashes=allHashes(startsWith(allHashes, 'node_'));



for i=1:length(allHashes)
    if strcmp(zef.dataBank.tree.(allHashes{i}).type, 'reconstruction')
        zef.dataBank.hash=allHashes{i};
        zef_dataBank_setData;
         [zef.GMM.model,zef.GMM.dipoles,zef.GMM.amplitudes,zef.GMM.time_variables] = zef_GMModeling;
        
        [zef.dataBank.tree, newHash]=zef_dataBank_add(zef.dataBank.tree, allHashes{i}, zef_dataBank_getData(zef, 'gmm'));
        
        zef.dataBank.tree.(newHash).name=strcat('gmm_4',meth, num2str(100*ii));
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
end

%% make all reconstructions

%set all parameters!
% beamformer app needs to be open
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




%% delete all x

dltType='gmm';


onlyIn='node';

allHashes=fieldnames(zef.dataBank.tree);
allHashes=allHashes(startsWith(allHashes, onlyIn));


i=1;

while i<=length(allHashes)
    
    
    
    if strcmp(zef.dataBank.tree.(allHashes{i}).type, dltType)
        zef.dataBank.hash=allHashes{i};
        zef.dataBank.tree=zef_dataBank_delete(zef.dataBank.tree, zef.dataBank.hash, 'false');
        %zef_dataBank_uiTreeDeleteHash(zef.dataBank.app.Tree, zef.dataBank.hash);
        allHashes=fieldnames(zef.dataBank.tree);
        allHashes=allHashes(startsWith(allHashes, onlyIn));
        
        i=1;
    else
        i=i+1;
    end
    
end



%%


%chose folder
zef.file_path='./dataNodes/';

zef.file_index=3; %1-jpg, 2-tiff, 3-png



allHashes=fieldnames(zef.dataBank.tree);

allHashes=allHashes(startsWith(allHashes, 'node_1'));

for nMod=1:length(allHashes)
    
    if strcmp(zef.dataBank.tree.(allHashes{nMod}).type, 'custom')
        modality=zef.dataBank.tree.(allHashes{nMod}).name;
        
        allHashesMod=allHashes(startsWith(allHashes, zef.dataBank.tree.(allHashes{nMod}).hash));
        
        for nRec=1:length(allHashesMod)
            if strcmp(zef.dataBank.tree.(allHashesMod{nRec}).type, 'reconstruction')
                rec=zef.dataBank.tree.(allHashesMod{nRec}).name;
                
                allHashesRec=allHashes(startsWith(allHashesMod, zef.dataBank.tree.(allHashesMod{nRec}).hash));
                
                
                
                
                
                
                
                for i=1:length(allHashesRec)
                    if strcmp(zef.dataBank.tree.(allHashesRec{i}).type, 'gmm')
                        zef.dataBank.hash=allHashesRec{i};
                        zef_dataBank_setData;
                        zef.file=strcat(modality,'_',rec,'_', zef.dataBank.tree.(allHashesRec{i}).name);
                        
                        if not(isequal(zef.file,0))
                            [zef.sensors,zef.reuna_p,zef.reuna_t,zef.reuna_p_inf] = process_meshes(zef.explode_everything);
                            print_meshes([]);
                            name=strcat(zef.file_path, zef.file, '.jpg');
                            exportgraphics(gca,name)
                            close gcf;
                        end
                    end
                end
            end
        end
        
        
    end
end


 




























