
%% delete all x

dltType='gmm';

%dltType='reconstruction';

onlyIn='node';

allHashes=fieldnames(zef.dataBank.tree);
allHashes=allHashes(startsWith(allHashes, onlyIn));

i=1;

while i<=length(allHashes)

    if strcmp(zef.dataBank.tree.(allHashes{i}).type, dltType)
        zef.dataBank.hash=allHashes{i};
        zef.dataBank.tree=zef_dataBank_delete(zef.dataBank.tree, zef.dataBank.hash, 'false');
        %zef_dataBank_uiTreeDeleteHash(zef.dataBank.app.Tree, zef.dataBank.hash);
        allHashes=fieldnames(zef.dataBank.tree);
        allHashes=allHashes(startsWith(allHashes, onlyIn));

        i=1;
    else
        i=i+1;
    end

end
