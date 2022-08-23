number_of_points = 10000;
grey_matter_ind = 15;

surface_triangles = zef_get_surface_triangles(zef.tetra,zef.sigma(:,2),grey_matter_ind);
nodes_ind_aux = unique(surface_triangles);
nodes_ind_aux = nodes_ind_aux([1:floor(length(nodes_ind_aux)/(number_of_points-1)):length(nodes_ind_aux)],:);

distance_vec = zeros(length(nodes_ind_aux),1);

surface_triangles_w = zef.reuna_t{compartment_ind-1};
surface_nodes_w = zef.reuna_p{compartment_ind-1};

surface_triangles_g = zef.reuna_t{compartment_ind};
surface_nodes_g = zef.reuna_p{compartment_ind};

surface_triangles_wg = [surface_triangles_w; surface_triangles_g+size(surface_nodes_w,1)];
surface_nodes_wg = [surface_nodes_w; surface_nodes_g];

d  =  zef_distance_to_mesh(zef.nodes(nodes_ind_aux,:), surface_nodes_wg, surface_triangles_wg);

figure(1); [a, b] = hist(d,1000); set(gca,'xlim',[0 3]);
figure(2); c = cumsum(a); plot(b,c./max(c)); set(gca,'xlim',[0 3],'xgrid','on','ygrid','on')
