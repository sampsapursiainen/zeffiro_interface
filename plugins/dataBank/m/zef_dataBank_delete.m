function [tree] = zef_dataBank_delete(tree, parentHash)

hashNames=fieldnames(tree);


for i=1:length(hashNames)
    
    if startsWith(hashNames{i}, parentHash)
        tree=rmfield(tree, hashNames{i});
    end


end












