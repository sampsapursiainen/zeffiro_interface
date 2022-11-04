%Copyright © 2021- Sampsa Pursiainen & GPU-ToRRe-3D Development Team
%See: https://github.com/sampsapursiainen/GPU-Torre-3D


function [u_data_mat, f_data_mat] = load_jacobian_data(path_data, data_name, torre_dir)

load([torre_dir '/' data_name '/point_' int2str(path_data(1)) '_data.mat'], 'u_data_mat'); 
load([torre_dir '/' data_name '/point_' int2str(path_data(2)) '_data.mat'], 'f_data_mat'); 

end
