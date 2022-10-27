%Copyright © 2021- Sampsa Pursiainen & GPU-ToRRe-3D Development Team
%See: https://github.com/sampsapursiainen/GPU-Torre-3D

parameters;

if system_setting_index == 1
loop_constant = 2;
else
    loop_constant = 1;
end
    
for k = 1 : loop_constant*n_r

if exist(['./data_' int2str(folder_ind) '/point_' int2str(k) '_data_complex_' int2str(system_setting_index) '.mat']) || exist(['./data_' int2str(folder_ind) '/point_' int2str(k) '_data_complex.mat'])

if time_series_count > 1
u_data_aux = [];
du_dt_data_aux = [];
u_data_mat_aux = [];
f_data_mat_aux = [];
p_1_data_aux = [];
p_2_data_aux = [];
p_3_data_aux = [];
t_data_aux = [];
end


for time_series_id = 1 : time_series_count

[k time_series_id]

if time_series_count > 1
load([torre_dir '/data_' int2str(folder_ind) '/point_' int2str(k) '_data_complex_' int2str(time_series_id) '.mat']);
else
load([torre_dir '/data_' int2str(folder_ind) '/point_' int2str(k) '_data_complex.mat']);
end

if time_series_count > 1

u_data_aux = [u_data_aux u_data];
du_dt_data_aux = [du_dt_data_aux du_dt_data];
u_data_mat_aux = [u_data_mat_aux u_data_mat];
f_data_mat_aux = [f_data_mat_aux f_data_mat];
p_1_data_aux = [p_1_data_aux p_1_data];
p_2_data_aux = [p_2_data_aux p_2_data];
p_3_data_aux = [p_3_data_aux p_3_data];
t_data_aux = [t_data_aux t_data];

end

end

if time_series_count > 1

u_data = u_data_aux;
clear u_data_aux;
du_dt_data = du_dt_data_aux;
clear du_dt_data_aux;
u_data_mat = u_data_mat_aux;
clear u_data_mat_aux;
f_data_mat = f_data_mat_aux;
clear f_data_mat_aux;
p_1_data = p_1_data_aux;
clear p_1_data_aux;
p_2_data = p_2_data_aux;
clear p_2_data_aux;
p_3_data = p_3_data_aux;
clear p_3_data_aux;
t_data = t_data_aux;
clear t_data_aux;



[rec_data] = surface_integral(u_data, du_dt_data, p_1_data, p_2_data, p_3_data, t_data, t_shift, source_points, orbit_nodes, orbit_triangles);

end

rec_data_complex = rec_data;
[rec_data, rec_data_quad, rec_amp] = qam_demod(rec_data,carrier_cycles_per_pulse_cycle,pulse_length,t_data);
[u_data_mat,u_data_mat_quad] = qam_demod(u_data_mat,carrier_cycles_per_pulse_cycle,pulse_length,t_data);
[f_data_mat,f_data_mat_quad] = qam_demod(f_data_mat,carrier_cycles_per_pulse_cycle,pulse_length,t_data);

save([torre_dir '/data_' int2str(folder_ind) '/point_' int2str(k) '_data' '.mat'], 'rec_data', 'rec_amp', 'rec_data_quad', 'rec_data_complex', 'u_data_mat', 'u_data_mat_quad', 'f_data_mat', 'f_data_mat_quad', 't_data');

end
end
