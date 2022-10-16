% Calculates the mean of the 50 rec of the project file
frame_number = 1; 
tol_val = 1e-6;
cred_val = 0.9;
max_iter = 1000;

z_inverse_results = cell(0);
z_inverse_info = cell(0);

data_tree = zef.dataBank.tree;
rec_ind = 1;

fn = fieldnames(data_tree);
for k=1:numel(fn)
    node = data_tree.(fn{k});
    if (strcmp(node.type, 'custom'))
        data_type = node.name;
    end
    if (strcmp(node.type, 'reconstruction'))
        rec_name = node.name;
        rec = node.data.reconstruction;
        number_of_frames = size(rec,2);
        z_inverse_results{rec_ind} = rec{frame_number};
        z_inverse_info(rec_ind,:) = [{data_type}  {rec_name}];
        rec_ind = rec_ind + 1;
    end
end

z_max_points = zeros(length(z_inverse_results),3);

for k = 1 : length(z_inverse_results)

    z_max_points(k,:) = zef_rec_maximizer(z_inverse_results{k},zef.source_positions);
    
end

z_mean_point = mean(z_max_points);

I_aux = zef_find_clusters(size(z_max_points,1),z_max_points,tol_val,cred_val,max_iter);
[~,max_ind] = max(accumarray(I_aux,ones(size(I_aux))));
J_aux = find(I_aux==max_ind);
z_cluster_mean = mean(z_max_points(J_aux,:),1);
z_inverse_results = z_inverse_results(J_aux);
z_inverse_info = z_inverse_info(J_aux,:);
z_max_points = z_max_points(J_aux,:);

z_avg = zeros(length(z_inverse_results{1}),1);
aux_vec = sqrt(sum((z_max_points - z_cluster_mean).^2,2)); 

for k = 1 : length(z_inverse_results)

z_avg = z_avg + z_inverse_results{k}.*(1./(aux_vec(k).^3));

end

z_avg = z_avg./sum(1./(aux_vec.^3));
zef.reconstruction = z_avg;
z_avg_max_point = zef_rec_maximizer(z_avg,zef.source_positions);
dist_vec = sqrt(sum((z_max_points - z_avg_max_point).^2,2)); 
[~,I] = sort(dist_vec); 
I_concentration = find(dist_vec > 0);
avg_concentration = sum(1./(dist_vec(I_concentration).^3));
n_concentration = length(I_concentration);
avg_radius = (n_concentration./avg_concentration).^(1/3);

if size(zef.resection_points,1) > 1
A=alphaShape(zef.resection_points(:,1), zef.resection_points(:,2), zef.resection_points(:,3),3.4);
[AF, AP]=alphaTriangulation(A);
dist_resection = zef_distance_to_resection(z_max_points,AP,AF);
dist_avg_resection = zef_distance_to_resection(z_avg_max_point,AP,AF);
else
dist_resection = zef_distance_to_resection(z_max_points,zef.resection_points);
dist_avg_resection = zef_distance_to_resection(z_avg_max_point,zef.resection_points);
end

z_concentration = zeros(length(z_inverse_results),1);
for k = 1 : length(z_inverse_results)

aux_vec = sqrt(sum((z_max_points - z_max_points(k,:)).^2,2)); 
I_concentration = find(aux_vec > 0);
z_concentration(k) = sum(1./aux_vec(I_concentration).^3);
n_concentration = length(I_concentration);
z_concentration(k) = (n_concentration./z_concentration(k)).^(1/3);

end


result_cell = [z_inverse_info(I,:) mat2cell(dist_vec(I),ones(length(z_inverse_results),1))  mat2cell(dist_resection(I),ones(length(z_inverse_results),1))  mat2cell(z_concentration(I),ones(length(z_inverse_results),1))];

result_cell = [{'none'} {'Cluster Centre'} {0} {dist_avg_resection} {avg_radius}; result_cell];

h_f = uifigure('Visible',zef.use_display); 
h_f.Name = 'ZEFFIRO Interface: Clustering results';
h_f.Units = 'normalized';
h_t = uitable('Parent',h_f); 
h_t.Units = 'normalized';
h_t.Position = [0.05 0.05 0.9 0.9];
h_t.Units = 'pixels';
h_t.RowName = '';
h_t.ColumnWidth = repmat({h_t.Position(3)/size(result_cell,2)},1,size(result_cell,2));
h_t.Units = 'normalized';
h_t.Data = result_cell;
h_t.ColumnName = [{'Data'} {'Method'} {'Dist. max. p.'} {'Dist. resect.'} {'Deviation'}];
zef_set_size_change_function(h_f,1,0)
