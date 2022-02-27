function zef_forward_simulation_table_selection(hObject,eventdata,handles)

forward_simulation_selected = eventdata.Indices(:,1);
forward_simulation_column_selected = eventdata.Indices(1,2);
forward_simulation_selected = unique(forward_simulation_selected);
forward_simulation_selected = forward_simulation_selected(:)';
evalin('base',['zef.forward_simulation_selected =[' num2str(forward_simulation_selected) '];']);
evalin('base',['zef.forward_simulation_column_selected =[' num2str(forward_simulation_column_selected) '];']);
aux_char = char(evalin('base',['zef.h_forward_simulation_table.Data{' num2str(forward_simulation_selected(1)) ',' num2str(forward_simulation_column_selected) '}']));
evalin('base',['zef.h_forward_simulation_script.Value = ''' aux_char ''';']);

end