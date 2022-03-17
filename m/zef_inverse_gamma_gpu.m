%Copyright © 2018- Sampsa Pursiainen & ZI Development Team
%See: https://github.com/sampsapursiainen/zeffiro_interface
function [p_val] = zef_inverse_gamma_gpu(x, shape,scale)

p_val = zef_gamma_gpu(1./x,shape,1./scale)./(x.^2);

end
