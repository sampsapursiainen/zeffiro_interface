function zef_plot_graph

g_list = evalin('base','zef.mesh_visualization_graph_list');
g_ind = evalin('base','zef.mesh_visualization_graph_selected');
p_ind =  evalin('base','zef.mesh_visualization_parameter_selected');
[~,v_name] = zef_get_profile_parameters(p_ind);

evalin('base',[g_list{2}{g_ind} '(' v_name ');']);

end