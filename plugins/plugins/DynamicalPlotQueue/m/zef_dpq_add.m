function data_table = zef_dpq_add(zef)

if nargin == 0
zef = evalin('base','zef');
end

data_table = eval('zef.h_dynamical_plot_queue_table.Data');

data_table(end+1,:) =  {'',true,'static',''};

end
