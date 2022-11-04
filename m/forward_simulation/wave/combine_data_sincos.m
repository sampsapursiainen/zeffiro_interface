%Copyright © 2021- Sampsa Pursiainen & GPU-ToRRe-3D Development Team
%See: https://github.com/sampsapursiainen/GPU-Torre-3D
 
parameters;

if system_setting_index == 1
loop_constant = 2;
else
    loop_constant = 1;
end

for k = 1 : loop_constant*n_r

if exist(['./data_' int2str(folder_ind) '/point_' int2str(k) '_data_cos_1.mat']) && exist(['./data_' int2str(folder_ind) '/point_' int2str(k) '_data_sin_1.mat'])

u_data_aux = [];
du_dt_data_aux = [];
u_data_mat_aux = [];
f_data_mat_aux = [];
p_1_data_aux = [];
p_2_data_aux = [];
p_3_data_aux = [];
t_data_aux = [];

for time_series_id = 1 : time_series_count

[k time_series_id]

load([torre_dir '/data_' int2str(folder_ind) '/point_' int2str(k) '_data_cos_' int2str(time_series_id) '.mat']);

u_data_cos = [u_data];
du_dt_data_cos = [du_dt_data];
u_data_mat_cos = [u_data_mat];
f_data_mat_cos = [f_data_mat];
p_1_data_cos = [p_1_data];
p_2_data_cos = [p_2_data];
p_3_data_cos = [p_3_data];

load([torre_dir '/data_' int2str(folder_ind) '/point_' int2str(k) '_data_sin_' int2str(time_series_id) '.mat']);

u_data_sin = [u_data];
du_dt_data_sin = [du_dt_data];
u_data_mat_sin = [u_data_mat];
f_data_mat_sin = [f_data_mat];
p_1_data_sin = [p_1_data];
p_2_data_sin = [p_2_data];
p_3_data_sin = [p_3_data];

u_data = complex(u_data_cos,u_data_sin);
du_dt_data = complex(du_dt_data_cos, du_dt_data_sin);
u_data_mat = complex(u_data_mat_cos, u_data_mat_sin); 
f_data_mat = complex(f_data_mat_cos, f_data_mat_sin);
p_1_data = complex(p_1_data_cos, p_1_data_sin);
p_2_data = complex(p_2_data_cos, p_2_data_sin);
p_3_data = complex(p_3_data_cos, p_3_data_sin);

u_data_aux = [u_data_aux u_data];
du_dt_data_aux = [du_dt_data_aux du_dt_data];
u_data_mat_aux = [u_data_mat_aux u_data_mat];
f_data_mat_aux = [f_data_mat_aux f_data_mat];
p_1_data_aux = [p_1_data_aux p_1_data];
p_2_data_aux = [p_2_data_aux p_2_data];
p_3_data_aux = [p_3_data_aux p_3_data];
t_data_aux = [t_data_aux t_data];

end

clear u_data_cos u_data_sin;
clear du_dt_data_cos du_dt_data_sin;
clear u_data_mat_cos u_data_mat_sin; 
clear f_data_mat_cos f_data_mat_sin;
clear p_1_data_cos p_1_data_sin;
clear p_2_data_cos p_2_data_sin;
clear p_3_data_cos p_3_data_sin;

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

rec_data_complex = rec_data;
[rec_data, rec_data_quad, rec_amp] = qam_demod(rec_data,carrier_cycles_per_pulse_cycle,pulse_length,t_data);
[u_data_mat,u_data_mat_quad] = qam_demod(u_data_mat,carrier_cycles_per_pulse_cycle,pulse_length,t_data);
[f_data_mat,f_data_mat_quad] = qam_demod(f_data_mat,carrier_cycles_per_pulse_cycle,pulse_length,t_data);

save([torre_dir '/data_' int2str(folder_ind) '/point_' int2str(k) '_data' '.mat'], 'rec_data', 'rec_amp', 'rec_data_quad', 'rec_data_complex', 'u_data_mat', 'u_data_mat_quad', 'f_data_mat', 'f_data_mat_quad', 't_data');

end
end
