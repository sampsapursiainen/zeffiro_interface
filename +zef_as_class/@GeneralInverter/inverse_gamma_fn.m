%Copyright © 2018- Sampsa Pursiainen & ZI Development Team
%See: https://github.com/sampsapursiainen/zeffiro_interface
function prior_val = inverse_gamma_fn(x, shape, scale)

    prior_val = zef_as_class.GeneralInverter.gamma_fn(1./x,shape,1./scale) ./ (x.^2);

end
