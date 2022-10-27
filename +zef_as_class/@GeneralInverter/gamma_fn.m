%Copyright © 2018- Sampsa Pursiainen & ZI Development Team
%See: https://github.com/sampsapursiainen/zeffiro_interface
function prior_val = gamma_fn(x, shape, scale)

    prior_val = (1./(scale.^shape.*gamma(shape))) .* x.^(shape-1) .* exp(-x./scale);

end
