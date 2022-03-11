
zef_dataBank_getHashForMenu;
[savefile,savepath] = uiputfile('*','Select a file');

if strcmp(zef.dataBank.app.typeDropDown.Value, 'Node')

    data=zef.dataBank.tree.(zef.dataBank.hash);
    if isobject(data.data)
        data.data=load(data.Properties.Source);
    end
    save(strcat(savepath, savefile), '-struct', 'data');
else
    tree=zef.dataBank.tree;
    save(strcat(savepath, savefile), '-struct', 'tree');
end

clear data savefile savepath tree
