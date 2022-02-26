
%this builds a uiTree in the databank.app from the databank.tree node
%hashcodes

%zef.dataBank.tree=zef_dataBank_reorderTree(zef.dataBank.tree);
%zef.dataBank.tree=zef_dataBank_sortTree(zef.dataBank.tree);

% if strcmp(zef.dataBank.save2disk, 'Off')
zef.dataBank.tree=zef_dataBank_sortTree(zef.dataBank.tree);
zef.dataBank.tree=zef_dataBank_rebuildTree(zef.dataBank.tree);

if strcmp(zef.dataBank.save2disk, 'On')
    zef.dataBank.tree= zef_dataBank_rebuildTreeSaveFile(zef.dataBank.tree);
end

zef.dataBank.hashList=fieldnames(zef.dataBank.tree);

for dbi=1:length(zef.dataBank.hashList)
    dbparent=zef.dataBank.app.Tree;

    zef.dataBank.hash=extractAfter(zef.dataBank.hashList{dbi}, 'node_');

    while contains(zef.dataBank.hash, '_')
    hashNumber=extractBefore(zef.dataBank.hash, '_');
    dbparent=dbparent.Children(str2double(hashNumber));
    zef.dataBank.hash=extractAfter(zef.dataBank.hash, '_');
    end
    newNode=uitreenode(dbparent, 'Text', zef.dataBank.tree.(zef.dataBank.hashList{dbi}).name, 'NodeData',zef.dataBank.tree.(zef.dataBank.hashList{dbi}).hash);
    newNode.ContextMenu=zef.dataBank.app.treeMenu;

end

expand(zef.dataBank.app.Tree, 'all');

clear dbparent newNode
