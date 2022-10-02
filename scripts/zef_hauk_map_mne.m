function hauk_map = zef_hauk_map_mne(project_struct, weighting_type, n_reconstructions, noise_level)

  arguments
      project_struct 
        weighting_type = 'sLORETA'
        n_reconstructions = 1
        noise_level = [-30]
  end
  
  weighting_type_cell = {'mne','dspm','sloreta'};
  weighting_type = find(ismember(weighting_type_cell,weighting_type));

hauk_map = struct;
hauk_map.weighting_type = weighting_type_cell{weighting_type}; 

project_struct = zef_minimum_norm_estimation(project_struct);

% 
project_struct.mne_number_of_frames = 3*size(project_struct.source_positions,1);
project_struct.mne_type = weighting_type;

for i = 1 : n_reconstructions
[hauk_map.dist_vec{i},hauk_map.angle_vec{i}, hauk_map.mag_vec{i}] = zef_rec_max_diff(project_struct,'zef_find_mne_reconstruction',noise_level);
end

hauk_map.dist_vec_avg = zeros(size(hauk_map.dist_vec{1}));
hauk_map.angle_vec_avg = zeros(size(hauk_map.angle_vec{1}));
hauk_map.mag_vec_avg = zeros(size(hauk_map.mag_vec{1}));

for i = 1 : n_reconstructions
hauk_map.dist_vec_avg = hauk_map.dist_vec_avg + hauk_map.dist_vec{i};
hauk_map.angle_vec_avg = hauk_map.angle_vec_avg + hauk_map.angle_vec{i};
hauk_map.mag_vec_avg = hauk_map.mag_vec_avg + hauk_map.mag_vec{i};
end

hauk_map.dist_vec_avg = hauk_map.dist_vec_avg/n_reconstructions;
hauk_map.angle_vec_avg = hauk_map.angle_vec_avg/n_reconstructions;
hauk_map.mag_vec_avg = hauk_map.mag_vec_avg/n_reconstructions;


end