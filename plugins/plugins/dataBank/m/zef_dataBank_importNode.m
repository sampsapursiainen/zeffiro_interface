function [tree] = zef_dataBank_importNode(tree, savePath, saveFile, parentHash, dataBank)

if ~iscell(saveFile)
    node=load(strcat(savePath, saveFile));
    [tree, hash]=zef_dataBank_add(tree, parentHash, node.data);
    tree.(hash).name=node.name;

    if strcmp(dataBank.save2disk, 'On')
    folderName=strcat(dataBank.folder, hash);
    data=node.data;
    save(folderName, '-struct', 'data');
    tree.(hash).data=matfile(folderName);
    end

else
    for i=1:length(saveFile)
        node=load(strcat(savePath, saveFile{i}));
        [tree, hash]=zef_dataBank_add(tree, parentHash, node.data);
        tree.(hash).name=node.name;

        if strcmp(dataBank.save2disk, 'On')
            folderName=strcat(dataBank.folder, hash);
            data=node.data;
            save(folderName, '-struct', 'data');
            tree.(hash).data=matfile(folderName);
        end
    end
end

end
