%Copyright © 2021- Sampsa Pursiainen & GPU-ToRRe-3D Development Team
%See: https://github.com/sampsapursiainen/GPU-Torre-3D


function save_jacobian_data_complex(aux_mat_cos, aux_mat_sin, ind_vec, torre_dir)

save([torre_dir '/system_data/aux_mat_' int2str(ind_vec(1)) '_' int2str(ind_vec(2)) '.mat'],'aux_mat_cos', 'aux_mat_sin')

end
