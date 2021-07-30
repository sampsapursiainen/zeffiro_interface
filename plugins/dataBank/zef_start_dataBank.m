

zef.dataBank.app=zef_dataBank_app;


%intitial values

if ~isfield(zef.dataBank, 'folder')
    zef.dataBank.save2disk='Off';
else
    if ~isfield(zef.dataBank, 'save2disk')
        zef.dataBank.save2disk='Off';
    end
    zef.dataBank.app.DataFolder.Text=zef.dataBank.folder;
    zef.dataBank.app.savetodiskSwitch.Enable=true;
    zef.dataBank.app.savetodiskSwitch.Value=zef.dataBank.save2disk;
end
zef.dataBank.DataTableHashList=cell(0,0);
zef.dataBank.workingHashes=cell(0,0);
%set button functions
    
zef.dataBank.app.addButton.ButtonPushedFcn='zef_dataBank_addButtonPress;';

zef.dataBank.types={'data', 'leadfield', 'reconstruction', 'gmm', 'custom'}; %%%% edit for new datatype!
zef.dataBank.app.Entrytype.Items=zef.dataBank.types;









zef.dataBank.app.showButton.ButtonPushedFcn='[zef.dataBank.app.DataTable.Data, zef.dataBank.app.DataTable.ColumnName, zef.dataBank.DataTableHashList]=zef_databank_showAll(zef.dataBank.tree, zef.dataBank.app.Entrytype.Value);';
zef.dataBank.app.showcurrentButton.ButtonPushedFcn='[zef.dataBank.app.currentTable.Data, zef.dataBank.app.currentTable.ColumnName]=zef_dataBank_showCurrent(zef, zef.dataBank.app.Entrytype.Value);';

zef.dataBank.app.selectfolderButton.ButtonPushedFcn=strcat( "zef.dataBank.folder=uigetdir('', 'select folder for the databank');","zef.dataBank.folder=strcat(zef.dataBank.folder, zef.dataBank.folder(1));" ,...
 "zef.dataBank.app.savetodiskSwitch.Enable=true;", "zef.dataBank.app.DataFolder.Text=zef.dataBank.folder;");

zef.dataBank.app.savetodiskSwitch.ValueChangedFcn='zef_dataBank_saveTreeNodeSwitchChange;';



%set funtions for the treeMenu
%zef.dataBank.app.treeMenu.ContextMenuOpeningFcn ='gco';

zef.dataBank.app.loadMenu.MenuSelectedFcn='zef.dataBank.loadParents=false; zef_dataBank_getHashForMenu;zef_dataBank_setData;';
zef.dataBank.app.loadwithparentsMenu.MenuSelectedFcn='zef.dataBank.loadParents=true; zef_dataBank_getHashForMenu;zef_dataBank_setData;';
zef.dataBank.app.deleteMenu.MenuSelectedFcn='zef.dataBank.selectMultiple=false; zef_dataBank_getHashForMenu; zef.dataBank.tree=zef_dataBank_delete(zef.dataBank.tree, zef.dataBank.hash); zef_dataBank_delete_uitree; zef.dataBank.selectMultiple=false;';
zef.dataBank.app.exportMenu.MenuSelectedFcn="disp('sorry, this is not implemented,yet')";
zef.dataBank.app.showinformationMenu.MenuSelectedFcn="disp('sorry, this is not implemented,yet')";
zef.dataBank.app.modifyMenu.MenuSelectedFcn=strcat('zef.dataBank.selectMultiple=true;', 'zef_dataBank_getHashForMenu;', ...
            'zef.dataBank.workingHashes=zef_dataBank_hashToWorkingSpace(zef.dataBank.hash, zef.dataBank.workingHashes);', ...
            '[zef.dataBank.app.currentTable.Data, zef.dataBank.app.currentTable.ColumnName]=zef_dataBank_WorkingSpaceInfo(zef.dataBank.tree, zef.dataBank.workingHashes);');



zef.dataBank.app.loadMenuData.MenuSelectedFcn='zef.dataBank.loadParents=false; zef_dataBank_getHashForMenu;zef_dataBank_setData;';
zef.dataBank.app.loadwithparentsMenuData.MenuSelectedFcn='zef.dataBank.loadParents=true; zef_dataBank_getHashForMenu;zef_dataBank_setData;';

zef.dataBank.app.deleteMenuData.MenuSelectedFcn=strcat('zef.dataBank.selectMultiple=false;', 'zef_dataBank_getHashForTableMenu;', ...
                'zef.dataBank.tree=zef_dataBank_delete(zef.dataBank.tree, zef.dataBank.hash);','  zef_dataBank_uiTreeDeleteHash(zef.dataBank.app.Tree, zef.dataBank.hash);', ...
                'zef.dataBank.selectMultiple=false;', ...
                '[zef.dataBank.app.DataTable.Data, zef.dataBank.app.DataTable.ColumnName, zef.dataBank.DataTableHashList]=zef_databank_showAll(zef.dataBank.tree, zef.dataBank.app.Entrytype.Value);');
        
zef.dataBank.app.modifyMenuData.MenuSelectedFcn=strcat('zef.dataBank.selectMultiple=true;', 'zef_dataBank_getHashForTableMenu;', ...
            'zef.dataBank.workingHashes=zef_dataBank_hashToWorkingSpace(zef.dataBank.hash, zef.dataBank.workingHashes);', ...
            '[zef.dataBank.app.currentTable.Data, zef.dataBank.app.currentTable.ColumnName]=zef_dataBank_WorkingSpaceInfo(zef.dataBank.tree, zef.dataBank.workingHashes);');


zef.dataBank.app.exportMenuData.MenuSelectedFcn="disp('sorry, this is not implemented,yet')";
zef.dataBank.app.showinformationMenuData.MenuSelectedFcn="disp('sorry, this is not implemented,yet')";



% load all data and stuff

if ~isfield(zef.dataBank, 'tree')
    zef.dataBank.tree=[];
else
    zef_dataBank_hash2tree;
end

zef.dataBank.loadParents=false;
zef.dataBank.selectMultiple=false;



