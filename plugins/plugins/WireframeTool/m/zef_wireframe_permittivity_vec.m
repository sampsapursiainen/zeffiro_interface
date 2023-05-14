function p_vec = zef_wireframe_permittivity_vec(f_vec,p_val)

p_vec = (2.*f_vec.*(p_val - 1) + p_val + 2)./(2 + p_val - f_vec.*(p_val - 1));

end
