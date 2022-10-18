data_ind = 1; 
snr_ind = 1; 
frame_number = 1; 

file_name = 'training_dataset_p1_10dB.mat';
folder_name = [fileparts(mfilename('fullpath')) filesep 'data'];

file_name = [folder_name filesep file_name];

load(file_name);

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
        rec{frame_number} = training_data.z_inverse_results{data_ind}{snr_ind}{rec_ind};
        rec_ind = rec_ind + 1;
    end
end

zef.resection_points = training_data.dipole_positions{data_ind}{snr_ind};