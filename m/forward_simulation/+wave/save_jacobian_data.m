%Copyright © 2021- Sampsa Pursiainen & GPU-ToRRe-3D Development Team
%See: https://github.com/sampsapursiainen/GPU-Torre-3D


function save_jacobian_data(aux_mat, j, torre_dir)

save([torre_dir '/system_data/aux_mat_' int2str(j)],'aux_mat')

end
