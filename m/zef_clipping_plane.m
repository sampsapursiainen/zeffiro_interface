function clipped_nodes_ind = zef_clipping_plane(nodes, clipping_plane, varargin)

clipped = 0;
if length(varargin) > 0
    aux_node_ind = varargin{1};
    clipped = 1;
end

if length(clipping_plane{4}) == 1

if clipped
clipped_nodes_ind = intersect(aux_node_ind,find(sum(nodes.*repmat([clipping_plane{1} clipping_plane{2} clipping_plane{3}],size(nodes,1),1),2) >= clipping_plane{4}));
else
clipped_nodes_ind = find(sum(nodes.*repmat([clipping_plane{1} clipping_plane{2} clipping_plane{3}],size(nodes,1),1),2) >= clipping_plane{4});
end

elseif length(clipping_plane{4}) == 2

if clipped
clipped_nodes_ind = intersect(aux_node_ind,find(sum(nodes.*repmat([clipping_plane{1} clipping_plane{2} clipping_plane{3}],size(nodes,1),1),2) >= clipping_plane{4}(1)));
clipped_nodes_ind = intersect(clipped_nodes_ind,find(sum(nodes.*repmat([clipping_plane{1} clipping_plane{2} clipping_plane{3}],size(nodes,1),1),2) <= clipping_plane{4}(2)));
else
clipped_nodes_ind = find(sum(nodes.*repmat([clipping_plane{1} clipping_plane{2} clipping_plane{3}],size(nodes,1),1),2) >= clipping_plane{4}(1));
clipped_nodes_ind = intersect(clipped_nodes_ind,find(sum(nodes.*repmat([clipping_plane{1} clipping_plane{2} clipping_plane{3}],size(nodes,1),1),2) <= clipping_plane{4}(2)));
end

end
