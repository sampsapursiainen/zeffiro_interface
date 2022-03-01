function data_table = zef_dpq_add

data_table = evalin('base','zef.h_dynamical_plot_queue_table.Data');

data_table(end+1,:) =  {'',true,'static',''};

end