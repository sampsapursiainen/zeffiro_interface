function [tree] = zef_dataBank_delete(tree, parentHash)

hashNames=fieldnames(tree);


for i=1:length(hashNames)
    
    if startsWith(hashNames{i}, parentHash)
        if isobject(tree.(hashNames{i}).data)
            delete(tree.(hashNames{i}).data.Properties.Source);
        end
 
        tree=rmfield(tree, hashNames{i});
    end
   
end







end










