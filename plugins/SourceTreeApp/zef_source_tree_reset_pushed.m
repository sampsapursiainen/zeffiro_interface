function zef_source_tree_reset_pushed(zef, ~, ~)
%ZEF_SOURCE_TREE_RESET_PUSHED Reset the entire source tree and related data.

zef = evalin('base','zef');

    % Delete all nodes from the UI tree
    delete(zef.h_source_tree.SourceTree.Children);

    % Remove stored source tree data
    if isfield(zef,'source_tree')
        zef = rmfield(zef,'source_tree');
        zef.h_source_tree.SourceParameters.Data = [];
    end

    % Remove global signal parameters
    if isfield(zef,'source_tree_signal_parameters')
        zef = rmfield(zef,'source_tree_signal_parameters');
        zef.source_tree_signal_parameters = zef_init_signal_general_data();
    end
    zef_update_signal_parameters_table(zef, zef.source_tree_signal_parameters);
   
    % Push updated zef back to base workspace
    assignin('base','zef', zef);
end
