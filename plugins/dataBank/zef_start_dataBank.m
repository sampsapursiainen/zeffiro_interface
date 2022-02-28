
zef.dataBank.app=zef_dataBank_app;

zef_dataBank_init;

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
%zef.dataBank.DataTableHashList=cell(0,0);
%zef.dataBank.workingHashes=cell(0,0);
%set button functions

zef.dataBank.app.addButton.ButtonPushedFcn='zef_dataBank_addButtonPress;';
zef.dataBank.app.combineButton.ButtonPushedFcn='[zef.L, zef.measurements] = zef_dataBank_combineLeadFields(zef.dataBank.tree, zef.dataBank.workingHashes,zef.dataBank.app.combineMenu.Value,zef.dataBank.var_starttime,zef.dataBank.var_endtime,zef.dataBank.var_sampling_frequency);';
zef.dataBank.app.StarttimeSpinner.ValueChangedFcn = 'zef_dataBank_update;';
zef.dataBank.app.EndtimeSpinner.ValueChangedFcn = 'zef_dataBank_update;';
zef.dataBank.app.SfreqSpinner.ValueChangedFcn = 'zef_dataBank_update;';
zef.dataBank.app.WorkingdataClear.MenuSelectedFcn = ' zef.dataBank.app.currentTable.Data = cell(0);zef.dataBank.workingHashes=cell(0);';
zef.dataBank.types={'data', 'noisedata', 'leadfield', 'reconstruction', 'gmm', 'custom', 'import'}; %%%% edit for new datatype!
zef.dataBank.app.Entrytype.Items=zef.dataBank.types;
zef.dataBank.app.Entrytype.ValueChangedFcn = '[zef.dataBank.app.DataTable.Data, zef.dataBank.app.DataTable.ColumnName, zef.dataBank.DataTableHashList]=zef_databank_showAll(zef.dataBank.tree, zef.dataBank.app.Entrytype.Value);';

zef.dataBank.app.showButton.ButtonPushedFcn='[zef.dataBank.app.DataTable.Data, zef.dataBank.app.DataTable.ColumnName, zef.dataBank.DataTableHashList]=zef_databank_showAll(zef.dataBank.tree, zef.dataBank.app.Entrytype.Value);';
zef.dataBank.app.showcurrentButton.ButtonPushedFcn='[zef.dataBank.app.currentTable.Data, zef.dataBank.app.currentTable.ColumnName]=zef_dataBank_showCurrent(zef, zef.dataBank.app.Entrytype.Value);';
zef.dataBank.app.RefreshButton.ButtonPushedFcn='zef_dataBank_refreshTree;';

zef.dataBank.app.selectfolderButton.ButtonPushedFcn='zef_dataBank_saveFolderButtonPush;';

zef.dataBank.app.savetodiskSwitch.ValueChangedFcn='zef_dataBank_saveTreeNodeSwitchChange;';

zef.dataBank.app.FunctionsDropDown.ValueChangedFcn='zef_dataBank_FunctionsDropDown;';

%set functions for the import panel

zef.dataBank.app.importButton.ButtonPushedFcn='zef_dataBank_importNodeButtonPress;';
zef.dataBank.app.exportButton.ButtonPushedFcn='zef_dataBank_exportButtonPress;';

%set funtions for the treeMenu
%zef.dataBank.app.treeMenu.ContextMenuOpeningFcn ='gco';

zef.dataBank.app.loadMenu.MenuSelectedFcn='zef.dataBank.loadParents=false; zef_dataBank_getHashForMenu;zef_dataBank_setData;';
zef.dataBank.app.loadwithparentsMenu.MenuSelectedFcn='zef.dataBank.loadParents=true; zef_dataBank_getHashForMenu;zef_dataBank_setData;';
zef.dataBank.app.deleteMenu.MenuSelectedFcn='zef.dataBank.selectMultiple=false; zef_dataBank_getHashForMenu; zef.dataBank.tree=zef_dataBank_delete(zef.dataBank.tree, zef.dataBank.hash,zef.dataBank.save2disk); zef_dataBank_refreshTree,   zef.dataBank.selectMultiple=false;';
zef.dataBank.app.exportMenu.MenuSelectedFcn="disp('sorry, this is not implemented,yet')";
zef.dataBank.app.showinformationMenu.MenuSelectedFcn="disp('sorry, this is not implemented,yet')";
zef.dataBank.app.modifyMenu.MenuSelectedFcn=strcat('zef.dataBank.selectMultiple=true;', 'zef_dataBank_getHashForMenu;', ...
            'zef.dataBank.workingHashes=zef_dataBank_hashToWorkingSpace(zef.dataBank.hash, zef.dataBank.workingHashes);', ...
            '[zef.dataBank.app.currentTable.Data, zef.dataBank.app.currentTable.ColumnName]=zef_dataBank_WorkingSpaceInfo(zef.dataBank.tree, zef.dataBank.workingHashes);');
zef.dataBank.app.changeNameMenu.MenuSelectedFcn='zef_dataBank_startNameChange';
zef.dataBank.app.showinformationMenu.MenuSelectedFcn='zef_dataBank_getHashForMenu; disp(zef.dataBank.tree.(zef.dataBank.hash)); disp(zef.dataBank.tree.(zef.dataBank.hash).data);';

zef.dataBank.app.showworkingHashes.ButtonPushedFcn = '[zef.dataBank.app.currentTable.Data, zef.dataBank.app.currentTable.ColumnName]=zef_dataBank_WorkingSpaceInfo(zef.dataBank.tree, zef.dataBank.workingHashes);';
zef.dataBank.app.loadMenuData.MenuSelectedFcn='zef.dataBank.loadParents=false; zef_dataBank_getHashForMenu;zef_dataBank_setData;';
zef.dataBank.app.loadwithparentsMenuData.MenuSelectedFcn='zef.dataBank.loadParents=true; zef_dataBank_getHashForMenu;zef_dataBank_setData;';
zef.dataBank.app.showinformationMenuData.MenuSelectedFcn='zef_dataBank_getHashForTableMenu; disp(zef.dataBank.tree.(zef.dataBank.hash{1})); disp(zef.dataBank.tree.(zef.dataBank.hash{1}).data);';
zef.dataBank.app.deleteMenuData.MenuSelectedFcn=strcat('zef.dataBank.selectMultiple=false;', 'zef_dataBank_getHashForTableMenu;', ...
                'zef.dataBank.tree=zef_dataBank_delete(zef.dataBank.tree, zef.dataBank.hash, zef.dataBank.save2disk);','  zef_dataBank_refreshTree;', ...
                'zef.dataBank.selectMultiple=false;', ...
                '[zef.dataBank.app.DataTable.Data, zef.dataBank.app.DataTable.ColumnName, zef.dataBank.DataTableHashList]=zef_databank_showAll(zef.dataBank.tree, zef.dataBank.app.Entrytype.Value);');

zef.dataBank.app.modifyMenuData.MenuSelectedFcn=strcat('zef.dataBank.selectMultiple=true;', 'zef_dataBank_getHashForTableMenu;', ...
            'zef.dataBank.workingHashes=zef_dataBank_hashToWorkingSpace(zef.dataBank.hash, zef.dataBank.workingHashes);', ...
            '[zef.dataBank.app.currentTable.Data, zef.dataBank.app.currentTable.ColumnName]=zef_dataBank_WorkingSpaceInfo(zef.dataBank.tree, zef.dataBank.workingHashes);');

set(zef.dataBank.app.DataBank,'AutoResizeChildren','off');
zef.zeffiro_dataBank_current_size = get(zef.dataBank.app.DataBank,'Position');
zef.zeffiro_dataBank_relative_size = zef_get_relative_size(zef.dataBank.app.DataBank);
set(zef.dataBank.app.DataBank,'SizeChangedFcn','zef.zeffiro_dataBank_current_size = zef_change_size_function(zef.dataBank.app.DataBank,zef.zeffiro_dataBank_current_size,zef.zeffiro_dataBank_relative_size);');

% load all data and stuff

if ~isfield(zef.dataBank, 'tree')
    zef.dataBank.tree=[];
else
    zef_dataBank_hash2tree;
end

zef.dataBank.loadParents=false;
zef.dataBank.selectMultiple=false;

[zef.dataBank.app.currentTable.Data, zef.dataBank.app.currentTable.ColumnName]=zef_dataBank_showCurrent(zef, zef.dataBank.app.Entrytype.Value);
[zef.dataBank.app.DataTable.Data, zef.dataBank.app.DataTable.ColumnName, zef.dataBank.DataTableHashList]=zef_databank_showAll(zef.dataBank.tree, zef.dataBank.app.Entrytype.Value);

