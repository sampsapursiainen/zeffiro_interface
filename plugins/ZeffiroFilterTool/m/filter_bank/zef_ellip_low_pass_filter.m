function [processed_data] = zef_ellip_low_pass_filter(f, filter_order, ripple, attenuation, edge_frequency, sampling_frequency)
%Copyright © 2018- Sampsa Pursiainen & ZI Development Team
%See: https://github.com/sampsapursiainen/zeffiro_interface
%This function processes the N-by-M data array f for N channels and M time
%steps. The other arguments can be controlled via the ZI user interface.
%The desctiption and argument definitions shown in ZI are listed below.
%Description: Elliptic low-pass filter
%Input: 1 Polynomial order [Default: 3], 2 Peak-to-peak ripple (dB) [Default: 3],
%3 Attenuation (dB) [Default: 80], 4 Edge frequency (Hz) [Default: 0],
%5 Sampling frequency (Hz) [Default: filter_sampling_rate]
%Output: Low-pass filtered data.

%Conversion between string and numeric data types.
if isstr(filter_order)
filter_order = str2num(filter_order);
end
if isstr(ripple)
ripple = str2num(ripple);
end
if isstr(attenuation)
attenuation = str2num(attenuation);
end
if isstr(edge_frequency)
edge_frequency = str2num(edge_frequency);
end
if isstr(sampling_frequency)
sampling_frequency = str2num(sampling_frequency);
end
%End of conversion.

if size(f,2) > 1 && edge_frequency > 0
[lp_f_1,lp_f_2] = ellip(filter_order,ripple,attenuation,edge_frequency/(sampling_frequency/2));
f = filter(lp_f_1,lp_f_2,f')';
end

processed_data = f;
