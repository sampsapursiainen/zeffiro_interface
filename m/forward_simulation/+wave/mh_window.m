%Copyright © 2021- Sampsa Pursiainen & GPU-ToRRe-3D Development Team
%See: https://github.com/sampsapursiainen/GPU-Torre-3D


function [mh_vec, d_mh_vec, d_2_mh_vec] = mh_window(t, T, carrier_cycles_per_pulse_cycle,carrier_mode)

ones_vec = ones(size(t));
T_ind = find(t>T);
ones_vec(T_ind) = 0; 
T_ind = find(t<0);
ones_vec(T_ind) = 0; 

sigma_scale = 0.1;
sigma = sigma_scale*T;

mh_vec_sin = (-(3.^(1./2).*exp(-(T./2 - t).^2./(2.*sigma.^2)).*(T - 2.*t))./(3.*sigma.^(1./2).*pi.^(1./4))).*sin(carrier_cycles_per_pulse_cycle.*2.*pi.*t./T);
d_mh_vec_sin = (2.*3.^(1./2).*exp(-(T./2 - t).^2./(2.*sigma.^2)).*sin((2.*pi.*carrier_cycles_per_pulse_cycle.*t)./T))./(3.*sigma.^(1./2).*pi.^(1./4)) - (3.^(1./2).*exp(-(T./2 - t).^2./(2.*sigma.^2)).*sin((2.*pi.*carrier_cycles_per_pulse_cycle.*t)./T).*(T - 2.*t).^2)./(6.*sigma.^(5./2).*pi.^(1./4)) - (2.*3.^(1./2).*carrier_cycles_per_pulse_cycle.*pi.^(3./4).*exp(-(T./2 - t).^2./(2.*sigma.^2)).*cos((2.*pi.*carrier_cycles_per_pulse_cycle.*t)./T).*(T - 2.*t))./(3.*T.*sigma.^(1./2));
d_2_mh_vec_sin = (3.^(1./2).*exp(-(T./2 - t).^2./(2.*sigma.^2)).*sin((2.*pi.*carrier_cycles_per_pulse_cycle.*t)./T).*(T - 2.*t))./(3.*sigma.^(5./2).*pi.^(1./4)) + (3.^(1./2).*exp(-(T./2 - t).^2./(2.*sigma.^2)).*sin((2.*pi.*carrier_cycles_per_pulse_cycle.*t)./T).*(4.*T - 8.*t))./(6.*sigma.^(5./2).*pi.^(1./4)) - (3.^(1./2).*exp(-(T./2 - t).^2./(2.*sigma.^2)).*sin((2.*pi.*carrier_cycles_per_pulse_cycle.*t)./T).*(T - 2.*t).^3)./(12.*sigma.^(9./2).*pi.^(1./4)) + (8.*3.^(1./2).*carrier_cycles_per_pulse_cycle.*pi.^(3./4).*exp(-(T./2 - t).^2./(2.*sigma.^2)).*cos((2.*pi.*carrier_cycles_per_pulse_cycle.*t)./T))./(3.*T.*sigma.^(1./2)) - (2.*3.^(1./2).*carrier_cycles_per_pulse_cycle.*pi.^(3./4).*exp(-(T./2 - t).^2./(2.*sigma.^2)).*cos((2.*pi.*carrier_cycles_per_pulse_cycle.*t)./T).*(T - 2.*t).^2)./(3.*T.*sigma.^(5./2)) + (4.*3.^(1./2).*carrier_cycles_per_pulse_cycle.^2.*pi.^(7./4).*exp(-(T./2 - t).^2./(2.*sigma.^2)).*sin((2.*pi.*carrier_cycles_per_pulse_cycle.*t)./T).*(T - 2.*t))./(3.*T.^2.*sigma.^(1./2));
 
mh_vec_cos = (-(3.^(1./2).*exp(-(T./2 - t).^2./(2.*sigma.^2)).*(T - 2.*t))./(3.*sigma.^(1./2).*pi.^(1./4))).*cos(carrier_cycles_per_pulse_cycle.*2.*pi.*t./T);
d_mh_vec_cos = (2.*3.^(1./2).*exp(-(T./2 - t).^2./(2.*sigma.^2)).*cos((2.*pi.*carrier_cycles_per_pulse_cycle.*t)./T))./(3.*sigma.^(1./2).*pi.^(1./4)) - (3.^(1./2).*exp(-(T./2 - t).^2./(2.*sigma.^2)).*cos((2.*pi.*carrier_cycles_per_pulse_cycle.*t)./T).*(T - 2.*t).^2)./(6.*sigma.^(5./2).*pi.^(1./4)) + (2.*3.^(1./2).*carrier_cycles_per_pulse_cycle.*pi.^(3./4).*exp(-(T./2 - t).^2./(2.*sigma.^2)).*sin((2.*pi.*carrier_cycles_per_pulse_cycle.*t)./T).*(T - 2.*t))./(3.*T.*sigma.^(1./2));
d_2_mh_vec_cos = (3.^(1./2).*exp(-(T./2 - t).^2./(2.*sigma.^2)).*cos((2.*pi.*carrier_cycles_per_pulse_cycle.*t)./T).*(T - 2.*t))./(3.*sigma.^(5./2).*pi.^(1./4)) + (3.^(1./2).*exp(-(T./2 - t).^2./(2.*sigma.^2)).*cos((2.*pi.*carrier_cycles_per_pulse_cycle.*t)./T).*(4.*T - 8.*t))./(6.*sigma.^(5./2).*pi.^(1./4)) - (3.^(1./2).*exp(-(T./2 - t).^2./(2.*sigma.^2)).*cos((2.*pi.*carrier_cycles_per_pulse_cycle.*t)./T).*(T - 2.*t).^3)./(12.*sigma.^(9./2).*pi.^(1./4)) - (8.*3.^(1./2).*carrier_cycles_per_pulse_cycle.*pi.^(3./4).*exp(-(T./2 - t).^2./(2.*sigma.^2)).*sin((2.*pi.*carrier_cycles_per_pulse_cycle.*t)./T))./(3.*T.*sigma.^(1./2)) + (4.*3.^(1./2).*carrier_cycles_per_pulse_cycle.^2.*pi.^(7./4).*exp(-(T./2 - t).^2./(2.*sigma.^2)).*cos((2.*pi.*carrier_cycles_per_pulse_cycle.*t)./T).*(T - 2.*t))./(3.*T.^2.*sigma.^(1./2)) + (2.*3.^(1./2).*carrier_cycles_per_pulse_cycle.*pi.^(3./4).*exp(-(T./2 - t).^2./(2.*sigma.^2)).*sin((2.*pi.*carrier_cycles_per_pulse_cycle.*t)./T).*(T - 2.*t).^2)./(3.*T.*sigma.^(5./2));
 

 if carrier_cycles_per_pulse_cycle == 0;
 amplitude_scale = (2/(sqrt(3*sigma)*pi^(1/4)));
 elseif carrier_cycles_per_pulse_cycle >= 1 && carrier_cycles_per_pulse_cycle < 3
 amplitude_scale = 10*(2/(sqrt(3*sigma)*pi^(1/4)))*sigma_scale;    
 else
 amplitude_scale = 3.8108*(2/(sqrt(3*sigma)*pi^(1/4)))*carrier_cycles_per_pulse_cycle*sigma_scale;
 end
 
 if isequal(carrier_mode,'complex')
mh_vec = complex(mh_vec_cos, mh_vec_sin)/amplitude_scale;
d_mh_vec = complex(d_mh_vec_cos, d_mh_vec_sin)/amplitude_scale;
d_2_mh_vec = complex(d_2_mh_vec_cos, d_2_mh_vec_sin)/amplitude_scale;
elseif isequal(carrier_mode,'cos')
 mh_vec = mh_vec_cos/amplitude_scale;
 d_mh_vec = d_mh_vec_cos/amplitude_scale;
d_2_mh_vec = d_2_mh_vec_cos/amplitude_scale;
elseif isequal(carrier_mode,'sin')
mh_vec = mh_vec_sin/amplitude_scale;
d_mh_vec = d_mh_vec_sin/amplitude_scale;
d_2_mh_vec = d_2_mh_vec_sin/amplitude_scale;
end

mh_vec = mh_vec.*ones_vec;
d_mh_vec = d_mh_vec.*ones_vec;
d_2_mh_vec = d_2_mh_vec.*ones_vec;

end
