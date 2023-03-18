function [nodes,tetra,J] = zef_get_submesh(nodes,tetra,I)

tetra = tetra(I,:);
[J, ~, I_aux] = unique(tetra);
tetra(1:numel(tetra)) = I_aux;
nodes = nodes(J,:);

end