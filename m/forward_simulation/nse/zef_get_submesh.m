function [nodes,tetra] = zef_get_submesh(nodes,tetra,I)

tetra = tetra(I,:);
[I_aux_1, I_aux_2, I_aux_3] = unique(tetra);
tetra(1:numel(tetra)) = I_aux_3;
nodes = nodes(I_aux_1,:);

end