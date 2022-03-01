function zef_dpq_selection(hObject,eventdata,handles)

functions_selected = eventdata.Indices(:,1)';
evalin('base',['zef.dpq_selected = [' num2str(functions_selected) ']'';']);
evalin('base',['zef.h_dynamical_plot_queue_script.Value=zef.h_dynamical_plot_queue_table.Data{' num2str(functions_selected(1)) ',1};']);
evalin('base',['zef.h_dynamical_plot_queue_description.Value=zef.h_dynamical_plot_queue_table.Data{' num2str(functions_selected(1)) ',4};']);

end
