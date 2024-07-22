function [nodes,simplexes,J] = zef_get_submesh(nodes,simplexes,I)

if nargin == 3
simplexes = simplexes(I,:);
end

[J, ~, I_aux] = unique(simplexes);
simplexes(1:numel(simplexes)) = I_aux;
nodes = nodes(J,:);

end