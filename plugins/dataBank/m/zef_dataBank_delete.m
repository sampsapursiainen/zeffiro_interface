function [tree] = zef_dataBank_delete(tree, parentHash, save2disk)

hashNames=fieldnames(tree);

for i=1:length(hashNames)

    if startsWith(hashNames{i}, strcat(parentHash, '_')) || strcmp(hashNames{i}, parentHash) %only children should be deleted. node_11 should not be deleted by node_1
        if isobject(tree.(hashNames{i}).data)
            delete(tree.(hashNames{i}).data.Properties.Source);
        end

        tree=rmfield(tree, hashNames{i});
    end

end

tree=zef_dataBank_sortTree(tree);
tree=zef_dataBank_rebuildTree(tree);

if strcmp(save2disk, 'On')
    tree=zef_dataBank_rebuildTreeSaveFile(tree);
end

end

