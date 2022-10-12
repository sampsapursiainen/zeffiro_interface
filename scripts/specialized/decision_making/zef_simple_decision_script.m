% Calculates the mean of the 50 rec of the project file
frame_number = 1; 
n_max_iter = 10000;
tol_val = 1e-15;

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

z_max_concentration = zef_newton_concentration(z_max_points,z_mean_point,tol_val,n_max_iter);

z_concentration= zeros(length(z_inverse_results),1);

z_avg = zeros(size(z_inverse_results{1}));

aux_vec = sqrt(sum((z_max_points - z_max_concentration).^2,2)); 

for k = 1 : length(z_inverse_results)

z_avg = z_avg + z_inverse_results{k}.*(1./(aux_vec(k).^3));

end

total_concentration = sum(1./(aux_vec.^3));

z_avg = z_avg./total_concentration;

zef.reconstruction = z_avg;

z_avg_max_point = zef_rec_maximizer(z_avg,zef.source_positions);

dist_vec = sqrt(sum((z_max_points - z_avg_max_point).^2,2)); 
[~,I] = sort(dist_vec); 
avg_concentration = sum(1./(dist_vec.^3));
avg_radius = (length(z_inverse_results)./avg_concentration).^(1/3);

A=alphaShape(zef.resection_points(:,1), zef.resection_points(:,2), zef.resection_points(:,3),3.4);
[AF, AP]=alphaTriangulation(A);
dist_resection = zef_distance_to_resection(z_max_points,AP,AF);

z_concentration = zeros(length(z_inverse_results),1);
for k = 1 : length(z_inverse_results)

aux_vec = sqrt(sum((z_max_points - z_max_points(k,:)).^2,2)); 
J = setdiff([1:length(z_inverse_results)],k);
z_concentration(k) = sum(1./(aux_vec(J).^3));

end

z_concentration = ((length(z_inverse_results)-1)./z_concentration).^(1/3);

result_cell = [z_inverse_info(I,:) mat2cell(dist_vec(I),ones(length(z_inverse_results),1))  mat2cell(dist_resection(I),ones(length(z_inverse_results),1))  mat2cell(z_concentration(I),ones(length(z_inverse_results),1))];

result_cell = [{'none'} {'max. concentration'} {0} {zef_distance_to_resection(z_avg_max_point,AP,AF)} {avg_radius}; result_cell];

h_f = figure(1); clf;
h_f.Units = 'normalized';
h_t = uitable; 
h_t.Units = 'normalized';
h_t.Position = [0.05 0.05 0.9 0.9];
h_t.Units = 'pixels';
h_t.RowName = '';
h_t.ColumnWidth = repmat({h_t.Position(3)/size(result_cell,2)},1,size(result_cell,2));
h_t.Data = result_cell;
h_t.ColumnName = [{'Data'} {'Method'} {'Dist. max. p.'} {'Dist. resect.'} {'Deviation'}];

