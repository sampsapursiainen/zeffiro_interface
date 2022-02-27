function [tree] = zef_dataBank_saveTreeNodes(tree, folder)
%changes the data in the nodes of the tree from
% struct to matFileObject by saving to folder

dbFieldNames=fieldnames(tree);

for i=1:length(dbFieldNames)

    nodeData=tree.(dbFieldNames{i}).data;
    folderName=strcat(folder, dbFieldNames{i});
    save(folderName, '-struct', 'nodeData');
    tree.(dbFieldNames{i}).data=matfile(folderName);

end

end

