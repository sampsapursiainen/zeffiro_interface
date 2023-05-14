function zef = zef_dataBank_getHasForMenu(zef)

if nargin == 0
    zef = evalin('base','zef');
end

if isempty(zef.dataBank.app.Tree.SelectedNodes) %either no selected or no node in tree, either way start on first level

    disp('please select nodes');
    return;

else
    if size(zef.dataBank.app.Tree.SelectedNodes,1)>1

        if ~zef.dataBank.selectMultiple
            disp('cannot select multiple nodes');
            return;
        end

        for dbi=1:size(zef.dataBank.app.Tree.SelectedNodes,1)
            zef.dataBank.hash{dbi}=zef.dataBank.app.Tree.SelectedNodes(dbi).NodeData;
        end
    else

        zef.dataBank.hash=zef.dataBank.app.Tree.SelectedNodes.NodeData;
    end

end

if nargout == 0
    assignin('base','zef',zef);
end


end
