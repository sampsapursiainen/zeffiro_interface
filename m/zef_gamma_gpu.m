%Copyright © 2018- Sampsa Pursiainen & ZI Development Team
%See: https://github.com/sampsapursiainen/zeffiro_interface
function [p_val] = zef_gamma_gpu(x, shape,scale)

p_val = (1./(scale.^shape.*gamma(shape))).*x.^(shape-1).*exp(-x./scale);

end
