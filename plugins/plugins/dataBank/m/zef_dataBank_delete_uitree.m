zef = zef_dataBank_delete_uitree(zef)

if nargin == 0
zef = evalin('base','zef')
end

if size(zef.dataBank.app.Tree.SelectedNodes,1)>1

    for dbk=1:size(zef.dataBank.app.Tree.SelectedNodes,1)
        zef.dataBank.app.Tree.SelectedNodes(dbk).delete;
    end

else

    zef.dataBank.app.Tree.SelectedNodes.delete;

end

clear dbk;

if nargout == 0
assignin('base','zef',zef);
end

end
