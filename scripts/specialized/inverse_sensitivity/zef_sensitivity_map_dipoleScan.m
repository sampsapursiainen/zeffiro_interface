function hauk_map = zef_hauk_map_mne(project_struct, n_reconstructions, noise_level)

  arguments
        project_struct 
        n_reconstructions = 10
        noise_level = [-30]
  end
  

hauk_map = struct;

project_struct = zef_dipole_start(project_struct);

% 
project_struct.number_of_frames = 3*size(project_struct.source_positions,1);

for i = 1 : n_reconstructions
[hauk_map.dist_vec{i},hauk_map.angle_vec{i}, hauk_map.mag_vec{i}] = zef_rec_max_diff(project_struct,'zef_dipoleScan',noise_level);
end

hauk_map.dist_vec_avg = zeros(size(hauk_map.dist_vec{1}));
hauk_map.angle_vec_avg = zeros(size(hauk_map.angle_vec{1}));
hauk_map.mag_vec_avg = zeros(size(hauk_map.mag_vec{1}));

hauk_map.dist_vec_std = zeros(size(hauk_map.dist_vec{1}));
hauk_map.angle_vec_std = zeros(size(hauk_map.angle_vec{1}));
hauk_map.mag_vec_std = zeros(size(hauk_map.mag_vec{1}));

for i = 1 : n_reconstructions
hauk_map.dist_vec_avg = hauk_map.dist_vec_avg + hauk_map.dist_vec{i};
hauk_map.angle_vec_avg = hauk_map.angle_vec_avg + hauk_map.angle_vec{i};
hauk_map.mag_vec_avg = hauk_map.mag_vec_avg + hauk_map.mag_vec{i};
end

hauk_map.dist_vec_avg = hauk_map.dist_vec_avg/n_reconstructions;
hauk_map.angle_vec_avg = hauk_map.angle_vec_avg/n_reconstructions;
hauk_map.mag_vec_avg = hauk_map.mag_vec_avg/n_reconstructions;

for i = 1 : n_reconstructions
hauk_map.dist_vec_std = hauk_map.dist_vec_std + (hauk_map.dist_vec{i} - hauk_map.dist_vec_avg).^2;
hauk_map.angle_vec_std = hauk_map.angle_vec_std + (hauk_map.angle_vec{i} - hauk_map.angle_vec_avg).^2;
hauk_map.mag_vec_std = hauk_map.mag_vec_std + (hauk_map.mag_vec{i} - hauk_map.mag_vec_avg).^2;
end

hauk_map.dist_vec_std = sqrt(hauk_map.dist_vec_std/(n_reconstructions-1));
hauk_map.angle_vec_std = sqrt(hauk_map.angle_vec_std/(n_reconstructions-1));
hauk_map.mag_vec_std = sqrt(hauk_map.mag_vec_std/(n_reconstructions-1));


end