function h_contour = zef_plot_contour(rel_val,surf_func,triangles,nodes,varargin)

h_axes = gca;
hold_status = ishold(h_axes); 

min_val = min(surf_func,[],'all');
max_val = max(surf_func,[],'all');

I = find(surf_func <= min_val + rel_val*(max_val - min_val));
edges_aux = [triangles(I,[1 2]); triangles(I,[2 3]); triangles(I,[3 1])];
edges_aux = sort(edges_aux,2); 
edges_aux = sortrows(edges_aux);
ind_diff = sum(abs(edges_aux(1:end-1,:) - edges_aux(2:end,:)),2);
ind_diff = min([ind_diff ; 1],[1 ; ind_diff]);
I = find(ind_diff);
edges_aux = edges_aux(I,:);

if not(hold_status)
    hold on; 
end

h_contour = plot3(nodes(edges_aux,1),nodes(edges_aux,2),nodes(edges_aux,3),'*');

if not(hold_status)
    hold off; 
end

 


end