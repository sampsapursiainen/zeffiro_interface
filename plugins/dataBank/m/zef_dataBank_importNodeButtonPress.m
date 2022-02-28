
if strcmp(zef.dataBank.app.typeDropDown.Value, 'Node')
    [savefile,savepath] = uigetfile('*','Select One or More Node Files','MultiSelect', 'on');
else
    [savefile,savepath] = uigetfile('*','Select a dataBank file','MultiSelect', 'off');
end

if isempty(zef.dataBank.app.Tree.SelectedNodes) %either no selected or no node in tree, either way start on first level

    newNode= uitreenode(zef.dataBank.app.Tree);
    dbParentHash='node';

else
    if size(zef.dataBank.app.Tree.SelectedNodes,1)>1
        disp('cannot add to multiple nodes!');
        return;
    end

    newNode=uitreenode(zef.dataBank.app.Tree.SelectedNodes);
    dbParentHash=zef.dataBank.app.Tree.SelectedNodes.NodeData;

end

if strcmp(zef.dataBank.app.typeDropDown.Value, 'Node')
     zef.dataBank.tree=zef_dataBank_importNode(zef.dataBank.tree, savepath, savefile, dbParentHash, zef.dataBank);
else
    zef.dataBank.tree=zef_dataBank_importDataBank(zef.dataBank.tree, savepath, savefile, dbParentHash, zef.dataBank);
end

 zef_dataBank_refreshTree;

clear savefile savepath dbParentHash

