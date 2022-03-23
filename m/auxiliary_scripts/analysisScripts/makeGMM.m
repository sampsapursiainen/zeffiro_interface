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
