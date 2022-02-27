function [tree] = zef_dataBank_importDataBank(tree, savePath, saveFile, parentHash, dataBank)

dataTree=load(strcat(savePath, saveFile));

dataTree=zef_dataBank_sortTree(dataTree);
dataTree=zef_dataBank_rebuildTree(dataTree);

data=dataTree.node_1.data;
[tree, firsthash]=zef_dataBank_add(tree, parentHash, data);
tree.(firsthash).name=dataTree.node_1.name;

        if strcmp(dataBank.save2disk, 'On')
            folderName=strcat(dataBank.folder, firsthash);
            save(folderName, '-struct', 'data');
            tree.(firsthash).data=matfile(folderName);
        end

 if strcmp(dataBank.save2disk, 'On')
    folderName=strcat(dataBank.folder, firsthash);
    save(folderName, '-struct', 'data');
    tree.(firsthash).data=matfile(folderName);
 end

     phash=str2double(regexp(parentHash, '(?<num>\d+)', 'match'));

    firsthash=str2double(regexp(firsthash, '(?<num>\d+)', 'match'));

    hashList=fieldnames(dataTree);

    correctionNumber=firsthash(end)-1;
 for i=2:length(hashList)
     hash=str2double(regexp(hashList{i}, '(?<num>\d+)', 'match'));
     hash(1)=hash(1)+correctionNumber;
     hash=[phash, hash];
     hash=zef_dataBank_number2hash(hash);

     tree.(hash)=dataTree.(hashList{i});
     tree.(hash).hash=hash;
     if strcmp(dataBank.save2disk, 'On')
         data=dataTree.(hashList{i}).data;
         folderName=strcat(dataBank.folder, hash);
         save(folderName, '-struct', 'data');
         tree.(hash).data=matfile(folderName);
     end

 end

end

