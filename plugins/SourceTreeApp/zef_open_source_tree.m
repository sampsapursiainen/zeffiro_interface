function zef = zef_open_source_tree(zef)

zef.h_source_tree = zef_source_tree_app;
delete(zef.h_source_tree.SourceTree.Children);
if isfield(zef, 'source_tree')
zef_rebuild_source_tree(zef.h_source_tree.SourceTree, zef.source_tree);
end
if not(isfield(zef,'source_tree_signal_parameters'))
zef.source_tree_signal_parameters = zef_init_signal_general_data();
else 
aux_struct = zef_init_signal_general_data();
zef.source_tree_signal_parameters = mergeStructs(zef.source_tree_signal_parameters,aux_struct);
end;
zef_update_signal_parameters_table(zef, zef.source_tree_signal_parameters);
zef.h_source_tree.SourceParameters.ColumnEditable = [false true];
zef.h_source_tree.SignalParameters.ColumnEditable = [false true];
 zef.h_source_tree.SourceTree.Editable ='on';

zef.h_source_tree.ResettreeButton.ButtonPushedFcn = ...
    @(btn,evt) zef_source_tree_reset_pushed([], btn, evt);

 zef.h_source_tree.AddrootButton.ButtonPushedFcn = ...
    @(btn,evt) zef_source_tree_addroot_pushed([], btn, evt);

  zef.h_source_tree.DeletenodeButton.ButtonPushedFcn = ...
    @(btn,evt) zef_source_tree_deletenode_pushed([], btn, evt);

   zef.h_source_tree.PlotsourceButton.ButtonPushedFcn = ...
    @zef_PlotSourceButton_Callback;

 zef.h_source_tree.SimulatesignalButton.ButtonPushedFcn = 'zef_source_tree_simulate_signal_pushed;';

 zef.h_source_tree.PlotsignalButton.ButtonPushedFcn = 'zef_source_tree_plot_signal_pushed';

 zef.h_source_tree.AddnodeButton.ButtonPushedFcn = @(btn,evt) zef_source_tree_addnode_pushed([], btn, evt);

 zef.h_source_tree.SimulatemeasurementsButton.ButtonPushedFcn = '[zef, zef.measurements] = zef_simulate_measurements_from_source_tree(zef, zef.source_tree, zef.source_tree_published);'

zef.h_source_tree.SourceParameters.CellEditCallback = ...
    @(tbl,evt) zef_source_tree_cell_edited([], tbl, evt, 'SourceParameters');

zef.h_source_tree.SignalParameters.CellEditCallback = ...
    @(tbl,evt) zef_source_tree_cell_edited([], tbl, evt, 'SignalParameters');

zef.h_source_tree.SourceTree.SelectionChangedFcn = @(src,evt) zef_source_tree_selection_changed([], src, evt);

zef.h_source_tree.SourceTree.NodeTextChangedFcn = 'zef.source_tree = zef_build_source_tree(zef.h_source_tree.SourceTree);;'

end

function C = mergeStructs(A,B)

C = A;

fnB = fieldnames(B);

for k = 1:numel(fnB)
    f = fnB{k};
    if ~isfield(C,f)
        C.(f) = B.(f);
    end
end

end
