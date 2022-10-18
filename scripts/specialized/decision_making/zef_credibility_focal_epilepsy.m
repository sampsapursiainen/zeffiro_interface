file_name = 'training_dataset_p1_10dB.mat';
folder_name = [fileparts(mfilename('fullpath')) filesep 'data'];

cred_val = 0.9;
reg_val = 1E-12;
max_iter = 1000;

load([folder_name filesep file_name],'training_data');

credibility_vec = [];
credibility_vec = zeros(size(training_data.max_points{1}{1},1),1);

for i = 1 : length(training_data.cluster_index_data)
    
    c_ind = zef_find_clusters(length(training_data.cluster_index_data),training_data.max_points{i}{1},reg_val,cred_val,max_iter);
    aux_array = accumarray(c_ind, ones(size(c_ind)));
    [~,max_ind] = max(aux_array);
    I = find(c_ind == max_ind);
    credibility_vec(I) = credibility_vec(I) + 1;
    
    %credibility_vec_aux = training_data.cluster_index_data{i}{1};
    
    %if max(credibility_vec_aux) > length(credibility_vec)
    %credibility_vec(max(credibility_vec_aux)) = 0;
    %end
    
    %credibility_vec(credibility_vec_aux) = credibility_vec(credibility_vec_aux) + 1;
        
end

credibility_vec = credibility_vec/length(training_data.cluster_index_data);