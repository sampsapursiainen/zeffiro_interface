function [cluster_centres, dipole_moments, index_vec, GMModel, MahalanobisD] = zef_cluster_reconstruction(zef)

n_clusters = zef.GMModel.max_n_clusters; 
if iscell(zef.reconstruction)
rec_vec = zef.reconstruction{zef.GMModel.frame_number};
else 
rec_vec = zef.reconstruction;
end
pos_data = zef.source_positions; 
cred_val = zef.GMModel.credibility; 
n_dynamic_levels = zef.GMModel.n_dynamic_levels;
reg_val =  zef.GMModel.reg_param; 
max_iter = zef.GMModel.max_n_iter; 
tol_val = zef.GMModel.tol_val;

cluster_data = [];
rec_aux = reshape(rec_vec,3,numel(rec_vec)/3)';
rec_amp = sum(rec_aux.^2,2);
rec_amp = rec_amp/max(rec_amp); 

J = find(rec_amp <= 1/n_dynamic_levels);

for i = 2 : n_dynamic_levels+1
    
    I = find(rec_amp <= i/n_dynamic_levels);
    I = setdiff(I,J);
    cluster_data = [cluster_data ; [pos_data(I,:) rec_aux(I,:)]];

end

[index_vec,MahalanobisD,GMModel] = zef_find_clusters(n_clusters,cluster_data,reg_val,cred_val,max_iter,tol_val);

aux_array_1 =  accumarray(index_vec,rec_aux(index_vec,1));
aux_array_2 =  accumarray(index_vec,rec_aux(index_vec,1));
aux_array_3 =  accumarray(index_vec,rec_aux(index_vec,1));

dipole_moments = [aux_array_1 aux_array_2 aux_array_3];

cluster_centres = GMModel.mu(:,1:3);

end