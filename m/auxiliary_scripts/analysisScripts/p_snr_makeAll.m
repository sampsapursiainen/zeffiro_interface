
%open source simulation tool and select the correct source
%
%check the noise like below and update the values

%check max data without noise
%max(abs(zef.measurements),[],'all')
meg_max=0.0078; %%%%%%%%%%%%%%%%%%%%
eeg_max=0.6928; %%%%%%%%%%%

%  eegnode=zef.dataBank.tree.node_1_1;
%  megnode=zef.dataBank.tree.node_2_1;
%  meegnode=zef.dataBank.tree.node_3_1;

for BigIndex=1:3

 node_1=zef.dataBank.tree.node_1;
   node_1_1=zef.dataBank.tree.node_1_1;
    zef.dataBank.tree=[];
    zef.dataBank.tree.node_1=node_1;
    zef.dataBank.tree.node_1_1=node_1_1;

%load correct leadfield!

%%

%SNR=[-30 -25 -20 -15 -10 -5];
SNR=[-30 -20 -10];

Cnode='node_1';

 %zef.dipole_app.regType.Value='SVD';

zef.L=eegnode.data.L;

for snr_i=1:3

    SNR_now=SNR(snr_i);
    node_now=strcat('node_', num2str(snr_i));
    [zef.dataBank.tree, snr_node]=zef_dataBank_add(zef.dataBank.tree,Cnode , zef_dataBank_getData(zef, 'custom'));
    zef.dataBank.tree.(snr_node).name=strcat('SNR:_', num2str(SNR_now));

    %% make data
    zef.fss_bg_noise=SNR_now;
    for i=1:10

        zef_update_fss;
        zef.measurements = zef_find_source;
        %zef_dataBank_addButtonPress;
        [zef.dataBank.tree, newHash]=zef_dataBank_add(zef.dataBank.tree,snr_node , zef_dataBank_getData(zef, 'data'));

    end

    %% make all reconstructions for data

    %set all parameters!
    % beamformer app needs to be open
    %choose node to add to
    %enjoy!

    allHashes=fieldnames(zef.dataBank.tree);

    allHashes=allHashes(startsWith(allHashes, snr_node));

    for i=1:length(allHashes)
        if strcmp(zef.dataBank.tree.(allHashes{i}).type, 'data')
            zef.dataBank.hash=allHashes{i};
            zef_dataBank_setData;

            %mne
            zef.mne_snr=abs(SNR_now);
            [zef.reconstruction, zef.reconstruction_information]=zef_find_mne_reconstruction;
            zef.dataBank.tree=zef_dataBank_add(zef.dataBank.tree, zef.dataBank.hash, zef_dataBank_getData(zef, 'reconstruction'));

            %sLoreta
            zef.inv_snr=abs(SNR_now);
            [zef.reconstruction, zef.reconstruction_information] = zef_CSM_iteration;
            zef.dataBank.tree=zef_dataBank_add(zef.dataBank.tree, zef.dataBank.hash, zef_dataBank_getData(zef, 'reconstruction'));

            %ramus
            zef.h_ramus_snr.String=num2str(abs(SNR_now));
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

    for gmm_opt=1:3

        zef.GMM.paramters{23,2}={num2str(gmm_opt)};

                switch gmm_opt
            case 1
                meth='_kmeans_';
            case 2
                meth='_maxProb_';
            case 3
                meth='_maxComp_';
        end
    for  ii=[0.25,0.5, 0.75]

        %open gmm tool first and set the parameters

        zef.GMM.parameters{5,2}={num2str(ii)};

        allHashes=fieldnames(zef.dataBank.tree);

        allHashes=allHashes(startsWith(allHashes, snr_node));

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
    tree=zef.dataBank.tree;
    save(strcat('EegtreeAt_SNR_', num2str(SNR_now), '_',  num2str(BigIndex)), 'tree');

    node_1=zef.dataBank.tree.node_1;
    node_1_1=zef.dataBank.tree.node_1_1;
    zef.dataBank.tree=[];
    zef.dataBank.tree.node_1=node_1;
    zef.dataBank.tree.node_1_1=node_1_1;

end

%load correct leadfield!

%%

%SNR=[-30 -25 -20 -15 -10 -5];
SNR=[-30 -20 -10];
Cnode='node_1';

zef.dataBank.tree.node_1_1=megnode;
zef.L=megnode.data.L;

 zef.dipole_app.regType.Value='SVD';

for snr_i=1:3

    SNR_now=SNR(snr_i);
    node_now=strcat('node_', num2str(snr_i));
    [zef.dataBank.tree, snr_node]=zef_dataBank_add(zef.dataBank.tree,Cnode , zef_dataBank_getData(zef, 'custom'));
    zef.dataBank.tree.(snr_node).name=strcat('SNR:_', num2str(SNR_now));

    %% make data
    zef.fss_bg_noise=SNR_now;
    for i=1:10

        zef_update_fss;
        zef.measurements = zef_find_source;
        %zef_dataBank_addButtonPress;
        [zef.dataBank.tree, newHash]=zef_dataBank_add(zef.dataBank.tree,snr_node , zef_dataBank_getData(zef, 'data'));

    end

    %% make all reconstructions for data

    %set all parameters!
    % beamformer app needs to be open
    %choose node to add to
    %enjoy!

    allHashes=fieldnames(zef.dataBank.tree);

    allHashes=allHashes(startsWith(allHashes, snr_node));

    for i=1:length(allHashes)
        if strcmp(zef.dataBank.tree.(allHashes{i}).type, 'data')
            zef.dataBank.hash=allHashes{i};
            zef_dataBank_setData;

            %mne
            zef.mne_snr=abs(SNR_now);
            [zef.reconstruction, zef.reconstruction_information]=zef_find_mne_reconstruction;
            zef.dataBank.tree=zef_dataBank_add(zef.dataBank.tree, zef.dataBank.hash, zef_dataBank_getData(zef, 'reconstruction'));

            %sLoreta
            zef.inv_snr=abs(SNR_now);
            [zef.reconstruction, zef.reconstruction_information] = zef_CSM_iteration;
            zef.dataBank.tree=zef_dataBank_add(zef.dataBank.tree, zef.dataBank.hash, zef_dataBank_getData(zef, 'reconstruction'));

            %ramus
            zef.h_ramus_snr.String=num2str(abs(SNR_now));
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
        for gmm_opt=1:3

        zef.GMM.paramters{23,2}={num2str(gmm_opt)};

                switch gmm_opt
            case 1
                meth='_kmeans_';
            case 2
                meth='_maxProb_';
            case 3
                meth='_maxComp_';
        end

    for  ii=[0.25,0.5, 0.75]

        %open gmm tool first and set the parameters

        zef.GMM.parameters{5,2}={num2str(ii)};

        allHashes=fieldnames(zef.dataBank.tree);

        allHashes=allHashes(startsWith(allHashes, snr_node));

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
    tree=zef.dataBank.tree;
    save(strcat('MegtreeAt_SNR_', num2str(SNR_now),'_', num2str(BigIndex)), 'tree');

    node_1=zef.dataBank.tree.node_1;
    node_1_1=zef.dataBank.tree.node_1_1;
    zef.dataBank.tree=[];
    zef.dataBank.tree.node_1=node_1;
    zef.dataBank.tree.node_1_1=node_1_1;

end
clc

%load EEG and MEG leadfields

%load EEG data
%load MEG data
% the data is node_1_2_a for a=1:15

%nomalize and combine
%max(abs(meas_data),[],'all').*randn(size(meas_data))*bg_noise_level
%bg_noise_level = 10^(evalin('base','zef.fss_bg_noise')/20);    %background noise
%sensornoiseFactor=sqrt(10^(SNR/20))

%%

%save to databank

%compute as before

  node_1=zef.dataBank.tree.node_1;
    %node_1_1=zef.dataBank.tree.node_1_1;
    zef.dataBank.tree=[];
    zef.dataBank.tree.node_1=node_1;
    %zef.dataBank.tree.node_1_1=node_1_1;

 zef.dipole_app.regType.Value='1';

%SNR=[-30 -25 -20 -15 -10 -5];
SNR=[-30 -20 -10];

for snr_i=1:3

    std_eeg=sqrt(  10^(SNR(snr_i) /20)  *eeg_max                 );
    std_meg=sqrt(  10^(SNR(snr_i) /20)  *meg_max                 );

    snr_now=SNR(snr_i);
    a=strcat('./EegtreeAt_SNR_', num2str(snr_now),'_', num2str(BigIndex), '.mat'); %%%%%%%%%%%%%%%
    load(a);
    eeg_tree=tree;

    a=strcat('./MegtreeAt_SNR_', num2str(snr_now),'_',  num2str(BigIndex),'.mat');  %%%%%%%%%%%%%%%
    load(a);
    meg_tree=tree;

    L_eeg=eegnode.data.L/std_eeg;
    L_meg=megnode.data.L/std_meg;

    zef.L=[L_meg; L_eeg];

    [zef.dataBank.tree, newHash]=zef_dataBank_add(zef.dataBank.tree, 'node_1', zef_dataBank_getData(zef, 'leadfield'));
    [zef.dataBank.tree, newHash]=zef_dataBank_add(zef.dataBank.tree, 'node_1', zef_dataBank_getData(zef, 'custom'));

    for i=1:10

        node=strcat('node_1_2_', num2str(i));
        zef.measurements=[meg_tree.(node).data.measurements/std_meg; eeg_tree.(node).data.measurements/std_eeg];
    [zef.dataBank.tree, newHash]=zef_dataBank_add(zef.dataBank.tree, 'node_1_2', zef_dataBank_getData(zef, 'data'));

    end

    %% make all reconstructions for data

    %set all parameters!
    % beamformer app needs to be open
    %choose node to add to
    %enjoy!

    allHashes=fieldnames(zef.dataBank.tree);

    allHashes=allHashes(startsWith(allHashes, snr_node));

    for i=1:length(allHashes)
        if strcmp(zef.dataBank.tree.(allHashes{i}).type, 'data')
            zef.dataBank.hash=allHashes{i};
            zef_dataBank_setData;

            %mne
            zef.mne_snr=abs(SNR_now);
            [zef.reconstruction, zef.reconstruction_information]=zef_find_mne_reconstruction;
            zef.dataBank.tree=zef_dataBank_add(zef.dataBank.tree, zef.dataBank.hash, zef_dataBank_getData(zef, 'reconstruction'));

            %sLoreta
            zef.inv_snr=abs(SNR_now);
            [zef.reconstruction, zef.reconstruction_information] = zef_CSM_iteration;
            zef.dataBank.tree=zef_dataBank_add(zef.dataBank.tree, zef.dataBank.hash, zef_dataBank_getData(zef, 'reconstruction'));

            %ramus
            zef.h_ramus_snr.String=num2str(abs(SNR_now));
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

        for gmm_opt=1:3

        zef.GMM.paramters{23,2}={num2str(gmm_opt)};

        switch gmm_opt
            case 1
                meth='_kmeans_';
            case 2
                meth='_maxProb_';
            case 3
                meth='_maxComp_';
        end

    for  ii=[0.25, 0.5, 0.75]

        %open gmm tool first and set the parameters

        zef.GMM.parameters{5,2}={num2str(ii)};

        allHashes=fieldnames(zef.dataBank.tree);

        allHashes=allHashes(startsWith(allHashes, snr_node));

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
    tree=zef.dataBank.tree;
    save(strcat('MeegtreeAt_SNR_', num2str(snr_now),'_',  num2str(BigIndex)), 'tree');

    node_1=zef.dataBank.tree.node_1;
    %node_1_1=zef.dataBank.tree.node_1_1;
    zef.dataBank.tree=[];
    zef.dataBank.tree.node_1=node_1;
    %zef.dataBank.tree.node_1_1=node_1_1;

end

end

