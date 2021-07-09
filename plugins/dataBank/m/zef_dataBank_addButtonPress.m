

dbtype=zef.dataBank.app.Entrytype.Value;

if isempty(zef.dataBank.app.Tree.SelectedNodes) %either no selected or no node in tree, either way start on first level
    
    newNode= uitreenode(zef.dataBank.app.Tree, 'Text', dbtype);
    dbParentHash='node';

else
    if size(zef.dataBank.app.Tree.SelectedNodes,1)>1
        disp('cannot add to multiple nodes!');
        return;
    end
    
    newNode=uitreenode(zef.dataBank.app.Tree.SelectedNodes, 'Text', dbtype);
    dbParentHash=zef.dataBank.app.Tree.SelectedNodes.NodeData;

end


[zef.dataBank.tree, newNode.NodeData]=zef_dataBank_add(zef.dataBank.tree, dbParentHash, zef_dataBank_getData(zef, dbtype));

newNode.ContextMenu=zef.dataBank.app.treeMenu;

if isempty(zef.dataBank.app.Tree.SelectedNodes)
expand(zef.dataBank.app.Tree, 'all');
else
expand(zef.dataBank.app.Tree.SelectedNodes);
end

clear dbtype dbParentHash newNode;














