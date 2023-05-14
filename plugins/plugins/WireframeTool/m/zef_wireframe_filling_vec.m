function [filling_vec] = zef_wireframe_filling_vec(eps_vec_1, eps_vec_2)

filling_vec = - (real(eps_vec_2) - real(eps_vec_1).*(real(eps_vec_2) + 2) + 2)./(2.*real(eps_vec_2) + real(eps_vec_1).*(real(eps_vec_2) - 1) - 2);

end
