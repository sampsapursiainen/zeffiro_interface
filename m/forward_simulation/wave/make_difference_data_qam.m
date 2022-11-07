%Copyright © 2021- Sampsa Pursiainen & GPU-ToRRe-3D Development Team
%See: https://github.com/sampsapursiainen/GPU-Torre-3D


load([torre_dir '/system_data/signal_configuration.mat']);
load([torre_dir '/system_data/mesh_1.mat']);

load([torre_dir '/signal_data/simulated_data_1.mat'])

system_setting_index = 1;
parameters;

if isequal(data_mode,'simulated')
load([torre_dir '/signal_data/simulated_data_2.mat'])
else
load([torre_dir '/signal_data/measured_data_2.mat'])
rec_data_2 = measured_data_2;
rec_data_quad_2 = measured_data_quad_2;
end;

t_data = t_vec(1:data_param:end);
ind_data_0 = find(t_data >= t_data_0,1);
ind_data_1 = find(t_data >= t_data_1,1);
if isempty(ind_data_1)
ind_data_1 = length(t_data);
end
t_data_difference = t_data(ind_data_0:data_resample_val:ind_data_1);
n_t_data = length(t_data_difference);

difference_data_mat = zeros(2*size(path_data,1)*(size(path_data,2)-1),n_t_data);

for  j = 1 :  size(path_data,1)
for k = 1 : size(path_data,2) - 1
if not(isequal(data_mode,'simulated'))
rec_data_2{j,k+1} = interp1(t_measured_2, rec_data_2{j,k+1}, t_data,'nearest');
rec_data_quad_2{j,k+1} = interp1(t_measured_2, rec_data_quad_2{j,k+1}, t_data,'nearest');
end
difference_data_mat(2*size(path_data,1)*(k-1)+2*j-1, :) = rec_data_2{j,k+1}(ind_data_0:data_resample_val:ind_data_1) - rec_data_1{j,k+1}(ind_data_0:data_resample_val:ind_data_1);
difference_data_mat(2*size(path_data,1)*(k-1)+2*j, :) = rec_data_quad_2{j,k+1}(ind_data_0:data_resample_val:ind_data_1) - rec_data_quad_1{j,k+1}(ind_data_0:data_resample_val:ind_data_1);

end 
end

save([torre_dir '/system_data/difference_data_qam.mat'], 'difference_data_mat', 't_data_difference', '-v7.3');

