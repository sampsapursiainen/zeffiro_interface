function data_table = zef_dpq_delete(zef)

if nargin == 0
zef = eval('base','zef');
end

data_table = eval('zef.h_dynamical_plot_queue_table.Data');

selected_ind = eval('zef.dpq_selected');
aux_ind = setdiff([1 : size(data_table,1)]', selected_ind);

data_table = data_table(aux_ind,:);

if size(data_table,1) >= aux_ind
eval(['zef.h_dynamical_plot_queue_script.Value = ''' data_table{aux_ind,1} ''';']);
eval(['zef.h_dynamical_plot_queue_description.Value = ''' data_table{aux_ind,4} ''';']);
elseif aux_ind > 1
eval(['zef.h_dynamical_plot_queue_script.Value = ''' data_table{aux_ind-1,1} ''';']);
eval(['zef.h_dynamical_plot_queue_description.Value = ''' data_table{aux_ind-1,4} ''';']);
else
eval(['zef.h_dynamical_plot_queue_script.Value = '' '';']);
eval(['zef.h_dynamical_plot_queue_description.Value = '''';']);
end

end
