% Calculates the mean of the 50 rec of the project file
training_data_file_name = 'training_dataset_p1_10dB.mat';
training_data = [];
load([fileparts(mfilename('fullpath')) filesep 'data' filesep training_data_file_name]);

%cred_val = 0.6827;

cred_val = [         0.9600
    0.9400
    0.9400
    1.0000
    1.0000
    1.0000
    0.9800
    0.8600
    1.0000
    0.9200
    1.0000
    1.0000
    1.0000
    0.9000
    1.0000
    1.0000
    0.8400
    1.0000
    1.0000
    0.9800
    0.9000
    1.0000
    1.0000
    1.0000
    0.9800
    0.7200
    0.8200];

cred_val = [cred_val ;  cred_val];

clustering_mode = 'ClusterCentres';%'MaxPoints'
frame_number = 1; 
tol_val = 1e-6;
reg_val = 1e-3;

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
z_cluster_centres = zeros(length(z_inverse_results),3);
z_max_deviations = zeros(length(z_inverse_results),1);
z_mean_deviations = zeros(length(z_inverse_results),1);

for k = 1 : length(z_inverse_results)

    z_max_points(k,:) = zef_rec_maximizer(z_inverse_results{k},zef.source_positions);
    [z_cluster_centres_aux,z_dipole_moments_aux,~,GMModel] = zef_cluster_reconstruction(100, z_inverse_results{k}, zef.source_positions, 0.95, 4, 1e-5, 10000, 1E-3);
    
    [~, max_ind] = max(sqrt(sum(z_dipole_moments_aux.^2,2)));
    z_cluster_centres(k,:) = z_cluster_centres_aux(max_ind,:);
    z_max_deviations(k,:) = max(sqrt(eigs(GMModel.Sigma(:,:,max_ind))));
    z_mean_deviations(k,:) = (mean(sqrt(eigs(GMModel.Sigma(:,:,max_ind)))));
    
end


z_ref_points = [z_max_points; z_cluster_centres];
z_inverse_info = [z_inverse_info repmat({'Maximum point'},size(z_inverse_info,1),1); z_inverse_info repmat({'Cluster centre'},size(z_inverse_info,1),1) ];
z_inverse_results = [z_inverse_results z_inverse_results];
z_mean_deviations = [zeros(size(z_max_deviations)); z_mean_deviations];
z_max_deviations = [zeros(size(z_max_deviations)); z_max_deviations];


z_mean_point = mean(z_ref_points);

[I_aux,MahalanobisD,GMModel] = zef_find_clusters(size(z_ref_points,1),z_ref_points,reg_val,cred_val,max_iter,tol_val);
[~,max_ind] = max(accumarray(I_aux,ones(size(I_aux))));
J_aux = find(I_aux==max_ind);
z_cluster_mean = GMModel.mu(max_ind,:);
z_cluster_deviation = max(sqrt(eigs(GMModel.Sigma(:,:,max_ind))));
z_inverse_results = z_inverse_results(J_aux);
z_inverse_info = z_inverse_info(J_aux,:);
z_ref_points_full = z_ref_points;
z_ref_points = z_ref_points(J_aux,:);
z_max_deviations = z_max_deviations(J_aux,:);
z_mean_deviations = z_mean_deviations(J_aux,:);

z_final = zeros(length(z_inverse_results{1}),1);

for k = 1 : length(z_inverse_results)

z_final = z_final + z_inverse_results{k};

end

z_final_max_point = zef_rec_maximizer(z_final,zef.source_positions); 
[z_cluster_centres_aux,z_dipole_moments_aux,~,GMModel] = zef_cluster_reconstruction(100, z_inverse_results{k}, zef.source_positions, 0.95, 4, 1e-5, 10000, 1E-3);
  [~, max_ind] = max(sqrt(sum(z_dipole_moments_aux.^2,2)));
  %  z_final_cluster_centre = z_cluster_centres_aux(max_ind,:);
    z_final_max_deviation = max(sqrt(eigs(GMModel.Sigma(:,:,max_ind)))); 
    z_final_mean_deviation = (mean(sqrt(eigs(GMModel.Sigma(:,:,max_ind))))); 
%dist_vec_final = sqrt(sum((z_final_cluster_centre - z_final_max_point).^2,2)); 

dist_vec = sqrt(sum((z_ref_points - z_final_max_point).^2,2)); 
[~,I] = sort(dist_vec); 

if size(zef.resection_points,1) > 1
A=alphaShape(zef.resection_points(:,1), zef.resection_points(:,2), zef.resection_points(:,3),3.4);
[AF, AP]=alphaTriangulation(A);
dist_resection = zef_distance_to_resection(z_ref_points,AP,AF);
dist_final_resection_max = zef_distance_to_resection(z_final_max_point,AP,AF);
else
dist_resection = zef_distance_to_resection(z_ref_points,zef.resection_points);
dist_final_resection_max = zef_distance_to_resection(z_final_max_point,zef.resection_points);
end

result_cell = [z_inverse_info(I,:) mat2cell(dist_vec(I),ones(length(z_inverse_results),1))  mat2cell(dist_resection(I),ones(length(z_inverse_results),1))  mat2cell(z_max_deviations(I),ones(length(z_inverse_results),1)) mat2cell(z_mean_deviations(I),ones(length(z_inverse_results),1))];
result_cell = [ {'cluster'} {'Final result'}  {'Max Point'} {0} {dist_final_resection_max} {z_final_max_deviation} {z_final_mean_deviation}; result_cell];


h_f_1 = uifigure('Visible',zef.use_display); 
h_f_1.Name = 'ZEFFIRO Interface: Clustering table';
h_f_1.Units = 'normalized';
h_t = uitable('Parent',h_f_1); 
h_t.Units = 'normalized';
h_t.Position = [0.05 0.05 0.9 0.9];
h_t.Units = 'pixels';
h_t.RowName = '';
h_t.ColumnWidth = repmat({h_t.Position(3)/size(result_cell,2)},1,size(result_cell,2));
h_t.Units = 'normalized';
h_t.Data = result_cell;
h_t.ColumnName = [{'Data'} {'Method'} {'Type'} {'Dist. reference'} {'Dist. resection'} {'Max. deviation'} {'Mean deviation'}];
zef_set_size_change_function(h_f_1,1,0)

h_f_2 = uifigure('Visible',zef.use_display);
h_f_2.Name = 'ZEFFIRO Interface: Clustering plot';
h_a = axes(h_f_2);
I = find(ismember(h_t.Data(:,3),'Cluster centre'))
plot(h_a,1:length(I),cell2mat(h_t.Data(I,4)));
deviation_data = cell2mat(h_t.Data(I,7));
for i = 2 : length(deviation_data)
deviation_data(i) = max(deviation_data(i-1),deviation_data(i));
end
hold(h_a,'on')
h_fill = fill(h_a,[1:length(I) length(I):-1:1]',[cell2mat(h_t.Data(I,4)) ;flipud(cell2mat(h_t.Data(I,4))+deviation_data)],'b')
h_fill.FaceAlpha = 0.2;
h_fill.EdgeColor = 'none';
h_fill = fill(h_a,[1:length(I) length(I):-1:1]',[cell2mat(h_t.Data(I,4)) ;flipud(cell2mat(h_t.Data(I,4))-deviation_data)],'b','HandleVisibility','off')
h_fill.FaceAlpha = 0.2;
h_fill.EdgeColor = 'none';
h_fill = fill(h_a,[1:length(I) length(I):-1:1]',[cell2mat(h_t.Data(I,4)) ;flipud(cell2mat(h_t.Data(I,4))+2*deviation_data)],'m')
h_fill.FaceAlpha = 0.1;
h_fill.EdgeColor = 'none';
h_fill = fill(h_a,[1:length(I) length(I):-1:1]',[cell2mat(h_t.Data(I,4)) ;flipud(cell2mat(h_t.Data(I,4))-2*deviation_data)],'m','HandleVisibility','off')
h_fill.FaceAlpha = 0.1;
h_fill.EdgeColor = 'none';
plot(h_a,1:length(I),cell2mat(h_t.Data(I,5)),'rs-');
set(h_a,'ylim',[0 1.05*max(cell2mat(h_t.Data(I,4))+2*deviation_data)])
set(h_a,'xlim',[1 length(I)])
pbaspect(h_a,[1 1 1])
h_legend = legend(h_a,'Distance to centre','68 % credibility','90 % credibility','Distance to resection','Location','NorthWest');
