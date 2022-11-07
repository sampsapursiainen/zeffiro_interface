%Copyright © 2021- Sampsa Pursiainen & GPU-ToRRe-3D Development Team
%See: https://github.com/sampsapursiainen/GPU-Torre-3D


function [bh_vec, d_bh_vec] = bh_window(t, T, carrier_cycles_per_pulse_cycle, carrier_mode)

ones_vec = ones(size(t));
T_ind = find(t>T);
ones_vec(T_ind) = 0; 
T_ind = find(t<0);
ones_vec(T_ind) = 0; 

a_0 = 0.35875;
a_1 = 0.48829;
a_2 = 0.14128;
a_3 = 0.01168;

if carrier_cycles_per_pulse_cycle == 0 
bh_vec_cos = (2*pi/T)*(a_0 - a_1.*cos(2.*pi.*t./T) + a_2.*cos(4.*pi.*t./T) - a_3.*cos(6.*pi.*t./T));
bh_vec_sin = zeros(size(bh_vec_cos));
d_bh_vec_cos = ((2.*a_1.*pi.*sin((2.*pi.*t)./T))./T - (4.*a_2.*pi.*sin((4.*pi.*t)./T))./T + (6.*a_3.*pi.*sin((6.*pi.*t)./T))./T);
d_bh_vec_sin = bh_vec_cos;
else
bh_vec_sin = (a_0 - a_1.*cos(2.*pi.*t./T) + a_2.*cos(4.*pi.*t./T) - a_3.*cos(6.*pi.*t./T)).*sin(carrier_cycles_per_pulse_cycle.*2.*pi.*t./T);
d_bh_vec_sin = sin((2.*pi.*carrier_cycles_per_pulse_cycle.*t)./T).*((2.*a_1.*pi.*sin((2.*pi.*t)./T))./T - (4.*a_2.*pi.*sin((4.*pi.*t)./T))./T + (6.*a_3.*pi.*sin((6.*pi.*t)./T))./T) + (2.*carrier_cycles_per_pulse_cycle.*pi.*cos((2.*pi.*carrier_cycles_per_pulse_cycle.*t)./T).*(a_0 - a_1.*cos((2.*pi.*t)./T) + a_2.*cos((4.*pi.*t)./T) - a_3.*cos((6.*pi.*t)./T)))./T;
bh_vec_cos = (a_0 - a_1.*cos(2.*pi.*t./T) + a_2.*cos(4.*pi.*t./T) - a_3.*cos(6.*pi.*t./T)).*cos(carrier_cycles_per_pulse_cycle.*2.*pi.*t./T);
d_bh_vec_cos = cos((2.*pi.*carrier_cycles_per_pulse_cycle.*t)./T).*((2.*a_1.*pi.*sin((2.*pi.*t)./T))./T - (4.*a_2.*pi.*sin((4.*pi.*t)./T))./T + (6.*a_3.*pi.*sin((6.*pi.*t)./T))./T) - (2.*carrier_cycles_per_pulse_cycle.*pi.*sin((2.*pi.*carrier_cycles_per_pulse_cycle.*t)./T).*(a_0 - a_1.*cos((2.*pi.*t)./T) + a_2.*cos((4.*pi.*t)./T) - a_3.*cos((6.*pi.*t)./T)))./T;
end

if carrier_cycles_per_pulse_cycle == 0
amplitude_scale = 2*pi/T;
else
amplitude_scale = 2*pi*carrier_cycles_per_pulse_cycle/T;
end
 
 if isequal(carrier_mode,'complex')
 bh_vec = complex(bh_vec_cos, bh_vec_sin)/amplitude_scale;
 d_bh_vec = complex(d_bh_vec_cos, d_bh_vec_sin)/amplitude_scale;
elseif isequal(carrier_mode,'cos')
 bh_vec = bh_vec_cos/amplitude_scale;
 d_bh_vec = d_bh_vec_cos/amplitude_scale;
elseif isequal(carrier_mode,'sin')
 bh_vec = bh_vec_sin/amplitude_scale;
 d_bh_vec = d_bh_vec_sin/amplitude_scale;
end

bh_vec = bh_vec.*ones_vec;
d_bh_vec = d_bh_vec.*ones_vec;

end
