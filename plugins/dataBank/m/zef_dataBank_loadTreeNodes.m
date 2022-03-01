function [tree] = zef_dataBank_loadTreeNodes(tree)
%changes the data in the tree nodes from matFileObject to struct by loading
%the files

dbFieldNames=fieldnames(tree);

folder=extractBefore(tree.(dbFieldNames{1}).data.Properties.Source, 'node_');

for i=1:length(dbFieldNames)

    tree.(dbFieldNames{i}).data=load(tree.(dbFieldNames{i}).data.Properties.Source);

end
folder=strcat(folder, 'node_*');
delete(folder);

end

