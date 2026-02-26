function zef_source_tree_deletenode_pushed(~, ~, ~)
%ZEF_SOURCE_TREE_DELETENODE_PUSHED Delete currently selected tree node
% (and its children) and update zef.source_tree accordingly.
zef = evalin('base','zef');

    selected_node = zef_source_tree_get_selected(zef.h_source_tree.SourceTree);
    if isempty(selected_node) || ~isvalid(selected_node)
        uialert(ancestor(zef.h_source_tree.SourceTree,'figure'), ...
            'Select a node first (the node to delete).', ...
            'No selection');
        return;
    end

    % Optional: confirmation dialog (recommended to avoid accidental deletes)
    fig = ancestor(zef.h_source_tree.SourceTree,'figure');
    msg = sprintf('Delete node "%s" and all its children?', selected_node.Text);
    choice = uiconfirm(fig, msg, 'Confirm delete', ...
        'Options', {'Delete','Cancel'}, ...
        'DefaultOption', 2, 'CancelOption', 2);

    if ~strcmp(choice, 'Delete')
        return;
    end

    % Delete node + subtree and rebuild struct
    zef.source_tree = zef_cbtreenode_delete_node(selected_node);

    % Reflect change to base workspace if you use that workflow
    assignin('base','zef', zef);
end
