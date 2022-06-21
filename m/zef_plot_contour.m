function [h_contour,h_text] = zef_plot_contour(rel_val,surf_func,triangles,nodes,varargin)


if evalin('base','zef.show_contour')

tau = 1;
n_iter = 10;
line_width = 2;
if not(isempty(varargin))
n_iter = varargin{1};
if length(varargin) > 1
tau = varargin{2};
end
end

h_axes = gca;
hold_status = ishold(h_axes);
c_map = lines(length(rel_val));
h_contour_old = findobj(h_axes.Children,'-regexp','Tag','contour*');
delete(h_contour_old);

surf_func = (1/3)*(surf_func(triangles(:,1),:) + surf_func(triangles(:,2),:) + surf_func(triangles(:,3),:));

min_val = min(surf_func,[],'all');
max_val = max(surf_func,[],'all');

nodes_orig = nodes;

for j = 1 : length(rel_val)
    
nodes = nodes_orig;
thresh_val = min_val + rel_val(j)*(max_val - min_val);
I = find(surf_func <= thresh_val);
edges_aux = [triangles(I,[1 2]); triangles(I,[2 3]); triangles(I,[3 1])];
edges_aux = sort(edges_aux,2); 
edges_aux = sortrows(edges_aux);
ind_diff = sum(abs(edges_aux(1:end-1,:) - edges_aux(2:end,:)),2);
ind_diff = min([ind_diff ; 1],[1 ; ind_diff]);
I = find(ind_diff);
edges_aux = edges_aux(I,:);

[nodes_edge_1,~,nodes_edge_1_ind] = unique(edges_aux);
nodes_edge_2 = [1 : length(nodes_edge_1)]';
nodes_edge_3 = zeros(length(nodes_edge_1),1);
edges_contour = cell(0);
edges_aux_ind = reshape(nodes_edge_1_ind,size(edges_aux));

E = sparse([edges_aux_ind(:,2); edges_aux_ind(:,1)],[edges_aux_ind(:,1) ; edges_aux_ind(:,2)],ones(2*size(edges_aux,1),1),length(nodes_edge_1),length(nodes_edge_1));
nodes_found = 0;
node_ind = [];

if not(hold_status)
    hold on; 
end

loop_start = 0;
while ismember(0,nodes_edge_3) 
    
   if isempty(node_ind)
   node_ind = find(not(ismember(nodes_edge_2,nodes_edge_3)),1);

   if not(isempty(node_ind))
   nodes_found = nodes_found + 1;
   nodes_edge_3(nodes_found) = node_ind;
   loop_start = loop_start + 1;
   edges_found = 1;
   edges_contour{loop_start} = zeros(size(edges_aux));
   end
   end   
   
   if not(isempty(node_ind))
   edges_contour{loop_start}(edges_found,1) = node_ind;
   node_neighbor = find(E(:,node_ind));
   node_ind = node_neighbor(find(not(ismember(node_neighbor,nodes_edge_3)),1));
   if not(isempty(node_ind))   
       %loop_nodes = loop_nodes + 1;
         nodes_found = nodes_found + 1;
       nodes_edge_3(nodes_found) = node_ind;
   edges_contour{loop_start}(edges_found,2) = node_ind;
   end
   end
   
   edges_found = edges_found + 1; 
    
end

for loop_start = 1 : length(edges_contour)
I = find(min(edges_contour{loop_start},[],2));
edges_contour{loop_start} = edges_contour{loop_start}(I,:);
size_edges = size(edges_contour{loop_start});
edges_contour{loop_start} = reshape(nodes_edge_1(edges_contour{loop_start}),size_edges);

for i = 1 : n_iter
nodes_mean = 0.5*(nodes(edges_contour{loop_start}(:,1),:)+nodes(edges_contour{loop_start}(:,2),:));
nodes(edges_contour{loop_start}(:,1),:) = (nodes(edges_contour{loop_start}(:,1),:) + tau*nodes_mean)/(1+tau);
nodes(edges_contour{loop_start}(:,2),:) = (nodes(edges_contour{loop_start}(:,2),:) + tau*nodes_mean)/(1+tau);
end

if size(edges_contour{loop_start},1) > 0 

edges_contour{loop_start} = edges_contour{loop_start}';
edges_contour{loop_start} = edges_contour{loop_start}(:);

h_contour(loop_start,j) = plot3(nodes(edges_contour{loop_start},1),nodes(edges_contour{loop_start},2),nodes(edges_contour{loop_start},3));
set(h_contour(loop_start,j),'linewidth',line_width)
set(h_contour(loop_start,j),'color',c_map(j,:))
set(h_contour(loop_start,j),'tag','contour')

uistack(h_contour(loop_start,j),'top');

if loop_start == 1
 h_text(j) = text(nodes(edges_contour{loop_start}(1,1),1),nodes(edges_contour{loop_start}(1,1),2),nodes(edges_contour{loop_start}(1,1),3),[sprintf('%0.3g',100*rel_val(j)) ' %']);
                    set(h_text(loop_start,j),'FontSize',evalin('base','zef.h_axes1.FontSize'));
h_text(j).Tag = 'contour_text';
uistack(h_text(j),'top');
end
end

end


end



 
if not(hold_status)
    hold off; 
end

else
h_contour = []; 
h_text = [];
end

end