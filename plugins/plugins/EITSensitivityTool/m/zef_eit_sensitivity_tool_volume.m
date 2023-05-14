function tilavuus_vec = zef_eit_sensitivity_tool_volume

nodes = evalin('base','zef.nodes');
tetrahedra = evalin('base','zef.tetra');

tilavuus = zef_tetra_volume(nodes, tetrahedra, true);
tilavuus = tilavuus(:);
tilavuus_vec = accumarray(evalin('base','zef.eit_ind'),tilavuus(evalin('base','zef.brain_ind')),[size(evalin('base','zef.eit_count'),1) 1]);
