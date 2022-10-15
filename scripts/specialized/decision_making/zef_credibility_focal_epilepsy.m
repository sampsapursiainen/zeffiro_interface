file_name = 'training_dataset_p1_10dB.mat';
folder_name = [fileparts(mfilename('fullpath')) filesep 'data'];

load([folder_name filesep file_name],'training_data');

credibility_vec = [];

for i = 1 : length(training_data.cluster_index_data)
    
    credibility_vec_aux = training_data.cluster_index_data{i}{1};
    
    if max(credibility_vec_aux) > length(credibility_vec)
    credibility_vec(max(credibility_vec_aux)) = 0;
    end
    
    credibility_vec(credibility_vec_aux) = credibility_vec(credibility_vec_aux) + 1;
        
end

credibility_vec = credibility_vec/length(training_data.cluster_index_data);