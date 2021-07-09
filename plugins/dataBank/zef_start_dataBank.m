

zef.dataBank.app=zef_dataBank_app;

%set button functions
    
zef.dataBank.app.addButton.ButtonPushedFcn='zef_dataBank_addButtonPress;';

zef.dataBank.types={'data', 'leadfield', 'reconstruction', 'gmm', 'custom'}; %%%% edit for new datatype!
zef.dataBank.app.Entrytype.Items=zef.dataBank.types;

%set funtions for the treeMenu
%zef.dataBank.app.treeMenu.ContextMenuOpeningFcn ='gco';

zef.dataBank.app.loadMenu.MenuSelectedFcn='zef.dataBank.loadParents=false; zef_dataBank_getHashForMenu;zef_dataBank_setData;';
zef.dataBank.app.loadwithparentsMenu.MenuSelectedFcn='zef.dataBank.loadParents=true; zef_dataBank_getHashForMenu;zef_dataBank_setData;';
zef.dataBank.app.deleteMenu.MenuSelectedFcn='zef.dataBank.selectMultiple=true; zef_dataBank_getHashForMenu; zef.dataBank.tree=zef_dataBank_delete(zef.dataBank.tree, zef.dataBank.hash); zef_dataBank_delete_uitree; zef.dataBank.selectMultiple=false;';
zef.dataBank.app.exportMenu.MenuSelectedFcn="disp('sorry, this is not implemented,yet')";
zef.dataBank.app.showinformationMenu.MenuSelectedFcn="disp('sorry, this is not implemented,yet')";



% load all data and stuff

if ~isfield(zef.dataBank, 'tree')
    zef.dataBank.tree=[];
else
    zef_dataBank_hash2tree;
end

zef.dataBank.loadParents=false;
zef.dataBank.selectMultiple=false;



