
if size(zef.dataBank.app.Tree.SelectedNodes,1)>1

    for dbk=1:size(zef.dataBank.app.Tree.SelectedNodes,1)
        zef.dataBank.app.Tree.SelectedNodes(dbk).delete;
    end

else

    zef.dataBank.app.Tree.SelectedNodes.delete;

end

clear dbk;

