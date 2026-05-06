function zef_source_tree_addroot_pushed(~, ~, ~)
%ZEF_SOURCE_TREE_ADDROOT_PUSHED Add a new root node to the source tree.
zef = evalin('base','zef');

    % Add child directly under the tree root
    zef_source_tree_add_child( ...
        zef.h_source_tree.SourceTree, 'NewNode');
      zef.source_tree = zef_build_source_tree(zef.h_source_tree.SourceTree);


    % Keep base workspace in sync (if this is your chosen model)
    assignin('base','zef', zef);
end