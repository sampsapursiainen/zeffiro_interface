function zef_plot_dpq(type)

dpq_table = evalin('base','zef.dynamical_plot_queue_table');

for dpq_ind = 1 : size(dpq_table,1)

if str2num(dpq_table{dpq_ind,2})
if isequal(dpq_table{dpq_ind,3},type)

evalin('caller', dpq_table{dpq_ind,1});

end
end
end
end
