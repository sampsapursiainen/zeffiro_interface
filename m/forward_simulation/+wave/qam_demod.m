%Copyright © 2021- Sampsa Pursiainen & GPU-ToRRe-3D Development Team
%See: https://github.com/sampsapursiainen/GPU-Torre-3D


function [data_val_inphase,data_val_quad,amp_val] = qam_demod(wave_val,carrier_cycles_per_pulse_cycle,pulse_length,t_data,varargin)

equalize_components = 1;

if carrier_cycles_per_pulse_cycle > 0 

if not(isempty(varargin))
        if varargin{1} == 1
    equalize_components = carrier_cycles_per_pulse_cycle;
        end
end


qam_resolution = 360;
phase_angle = [0:pi/2/qam_resolution:pi/2-pi/2/qam_resolution];

max_data_val = zeros(qam_resolution,1); 

for i = 1 : length(phase_angle)

carrier_1 = cos(2*pi*carrier_cycles_per_pulse_cycle*t_data/pulse_length+phase_angle(i));
carrier_2 = sin(2*pi*carrier_cycles_per_pulse_cycle*t_data/pulse_length+phase_angle(i));    
data_val = real(wave_val).*carrier_1 + imag(wave_val).*carrier_2;
max_data_val(i) = max(abs(data_val(:)));

end

[~, phase_angle_ind] = max(max_data_val);

phase_angle = phase_angle(phase_angle_ind)-pi/2;

carrier_1 = cos(2*pi*carrier_cycles_per_pulse_cycle*t_data/pulse_length+phase_angle);
carrier_2 = sin(2*pi*carrier_cycles_per_pulse_cycle*t_data/pulse_length+phase_angle);    
data_val_inphase = real(wave_val).*carrier_1 + imag(wave_val).*carrier_2;

carrier_1 = cos(2*pi*carrier_cycles_per_pulse_cycle*t_data/pulse_length+phase_angle+pi/2);
carrier_2 = sin(2*pi*carrier_cycles_per_pulse_cycle*t_data/pulse_length+phase_angle+pi/2);    
data_val_quad = real(wave_val).*carrier_1 + imag(wave_val).*carrier_2;

amp_val = sqrt(real(wave_val).^2 + imag(wave_val).^2);

scale_array = repmat(max(amp_val,[],2)./max(sqrt(data_val_inphase.^2+data_val_quad.^2),[],2),1,size(data_val,2));
data_val_inphase = equalize_components*scale_array.*data_val_inphase;
data_val_quad = scale_array.*data_val_quad;


else
    
data_val_inphase = real(wave_val);
data_val_quad = imag(wave_val);
amp_val = sqrt(real(wave_val).^2 + imag(wave_val).^2);
    
end
