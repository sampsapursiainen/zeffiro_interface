function zef_plot_graph

zef = evalin('base','zef');
g_list = eval('zef.mesh_visualization_graph_list');
g_ind = eval('zef.mesh_visualization_graph_selected');
p_ind =  eval('zef.mesh_visualization_parameter_selected');
[~,v_name] = zef_get_profile_parameters(zef,p_ind);

eval([g_list{2}{g_ind} '(' v_name ');']);

end
