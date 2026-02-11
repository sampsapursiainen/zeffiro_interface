function selected_node = zef_source_tree_get_selected(treeObj)

sel = treeObj.SelectedNodes;
    if isempty(sel)
        error('zef_cbtreenode_add_child:NoSelection', ...
              'SelectedNodes is empty. Select a parent node first.');
    end

    selected_node = sel(1);

end