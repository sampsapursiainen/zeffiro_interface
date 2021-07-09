




dbFieldNames=fieldnames(zef.dataBank.tree.(zef.dataBank.hash).data);

for dbi=1:length(dbFieldNames)
    zef.(dbFieldNames{dbi})=zef.dataBank.tree.(zef.dataBank.hash).data.(dbFieldNames{dbi});
    
end

if zef.dataBank.loadParents
    
        zef.dataBank.hash=reverse(zef.dataBank.hash);
        zef.dataBank.hash=extractAfter(zef.dataBank.hash, '_');
        zef.dataBank.hash=reverse(zef.dataBank.hash);

        if ~strcmp(zef.dataBank.hash, 'node') 
            zef_dataBank_setData;
        end        
    
end
    
    
    









