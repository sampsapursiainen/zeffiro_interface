function data_table = zef_dpq_delete

data_table = evalin('base','zef.h_dynamical_plot_queue_table.Data');

selected_ind = evalin('base','zef.dpq_selected');
aux_ind = setdiff([1 : size(data_table,1)]', selected_ind);

data_table = data_table(aux_ind,:);

if size(data_table,1) >= aux_ind
evalin('base',['zef.h_dynamical_plot_queue_script.Value = ''' data_table{aux_ind,1} ''';']);
evalin('base',['zef.h_dynamical_plot_queue_description.Value = ''' data_table{aux_ind,4} ''';']);
elseif aux_ind > 1
evalin('base',['zef.h_dynamical_plot_queue_script.Value = ''' data_table{aux_ind-1,1} ''';']);
evalin('base',['zef.h_dynamical_plot_queue_description.Value = ''' data_table{aux_ind-1,4} ''';']);
else
evalin('base',['zef.h_dynamical_plot_queue_script.Value = '' '';']);
evalin('base',['zef.h_dynamical_plot_queue_description.Value = '''';']);
end

end
