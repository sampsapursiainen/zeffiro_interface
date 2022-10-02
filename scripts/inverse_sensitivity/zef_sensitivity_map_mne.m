function sensitivity_map = zef_sensitivity_map_mne(project_struct, weighting_type, n_reconstructions, noise_level)

  arguments
      project_struct 
        weighting_type = 'sLORETA'
        n_reconstructions = 10
        noise_level = [-30]
  end
  
  weighting_type_cell = {'mne','dspm','sloreta'};
  weighting_type = find(ismember(weighting_type_cell,weighting_type));

sensitivity_map = struct;
sensitivity_map.weighting_type = weighting_type_cell{weighting_type}; 

project_struct = zef_minimum_norm_estimation(project_struct);

% 
project_struct.mne_number_of_frames = 3*size(project_struct.source_positions,1);
project_struct.mne_type = weighting_type;

for i = 1 : n_reconstructions
[sensitivity_map.dist_vec{i},sensitivity_map.angle_vec{i}, sensitivity_map.mag_vec{i}] = zef_rec_max_diff(project_struct,'zef_find_mne_reconstruction',noise_level);
end

sensitivity_map.dist_vec_avg = zeros(size(sensitivity_map.dist_vec{1}));
sensitivity_map.angle_vec_avg = zeros(size(sensitivity_map.angle_vec{1}));
sensitivity_map.mag_vec_avg = zeros(size(sensitivity_map.mag_vec{1}));

for i = 1 : n_reconstructions
sensitivity_map.dist_vec_avg = sensitivity_map.dist_vec_avg + sensitivity_map.dist_vec{i};
sensitivity_map.angle_vec_avg = sensitivity_map.angle_vec_avg + sensitivity_map.angle_vec{i};
sensitivity_map.mag_vec_avg = sensitivity_map.mag_vec_avg + sensitivity_map.mag_vec{i};
end

sensitivity_map.dist_vec_avg = sensitivity_map.dist_vec_avg/n_reconstructions;
sensitivity_map.angle_vec_avg = sensitivity_map.angle_vec_avg/n_reconstructions;
sensitivity_map.mag_vec_avg = sensitivity_map.mag_vec_avg/n_reconstructions;


end