function [nodes, tetra] = zef_optimize_mesh(nodes,tetra)

nodes_old = nodes;
tetra_old = tetra;

[tetra, optimizer_flag] = zef_tetra_turn(nodes, tetra, evalin('base','zef.mesh_optimization_parameter'));

if optimizer_flag == -1
nodes = nodes_old;
tetra = tetra_old;
errordlg('Mesh optimization failed.');
return;

end
