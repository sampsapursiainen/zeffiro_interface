%Copyright © 2021- Sampsa Pursiainen & GPU-ToRRe-3D Development Team
%See: https://github.com/sampsapursiainen/GPU-Torre-3D

parameters;

if not(exist('gpu_id'))
gpu_id = default_gpu_id;
end

max_plot_val = 0;
gpuDevice(gpu_id);


if compute_in_pieces == 1
time_series_id_vec = [time_series_id];
else
time_series_id_vec = [1 : time_series_count];
end

for time_series_id = time_series_id_vec

load([torre_dir '/system_data/mesh_' int2str(system_setting_index) '.mat'])
load([torre_dir '/system_data/system_data_' int2str(system_setting_index) '.mat'])
if exist([torre_dir '/system_data/interp_mat_' int2str(system_setting_index) '.mat'])
load([torre_dir '/system_data/interp_mat_' int2str(system_setting_index) '.mat']);
end

compute_data_gpu;

end

