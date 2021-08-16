function data_table = zef_dpq_delete

data_table = evalin('base','zef.h_dynamical_plot_queue_table.Data');

aux_ind = setdiff([1 : size(data_table,1)]', zef.dpq_selected);

data_table = data_table(aux_ind,:);

end