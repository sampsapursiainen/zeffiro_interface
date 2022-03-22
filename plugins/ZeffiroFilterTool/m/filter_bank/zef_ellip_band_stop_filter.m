function [processed_data] = zef_ellip_band_stop_filter(f, filter_order, ripple, attenuation, center_frequency, band_width, harmonic_filtering, sampling_frequency)
%Copyright © 2018- Sampsa Pursiainen & ZI Development Team
%See: https://github.com/sampsapursiainen/zeffiro_interface
%This function processes the N-by-M data array f for N channels and M time
%steps. The other arguments can be controlled via the ZI user interface.
%The desctiption and argument definitions shown in ZI are listed below.
%Description: Elliptic band-stop filter
%Input: 1 Polynomial order [Default: 3], 2 Peak-to-peak ripple (dB) [Default: 3],
%3 Attenuation (dB) [Default: 80], 4 Center frequency (Hz) [Default: 50],
%5 Band-width (Hz) [Default: 0.1], 6 Harmonic filtering (true/false) [Default: true],
%7 Sampling frequency (Hz) [Default: filter_sampling_rate]
%Output: Band-stop filtered data.

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
if isstr(center_frequency)
center_frequency = str2num(center_frequency);
end
if isstr(band_width)
band_width = str2num(band_width);
end
if isequal(lower(harmonic_filtering),'true')
harmonic_filtering = true;
elseif isequal(lower(harmonic_filtering),'false')
harmonic_filtering = false;
end
if isstr(sampling_frequency)
sampling_frequency = str2num(sampling_frequency);
end
%End of conversion.

if size(f,2) > 1 && center_frequency > 0

band_pass = (band_width/sampling_frequency)*[-1 1] + center_frequency/(sampling_frequency/2);
[bp_f_1,bp_f_2] = ellip(filter_order,ripple,attenuation,band_pass,'stop');
f = filter(bp_f_1,bp_f_2,f')';

if harmonic_filtering

k = 2;

h = waitbar(0,['Harmonic band-stop filter.']);

band_pass = (band_width/sampling_frequency)*[-1 1] + k*center_frequency/(sampling_frequency/2);

while band_pass(2) < 1

waitbar(k*center_frequency/(sampling_frequency/2),h,['Harmonic band-stop filter.']);

[bp_f_1,bp_f_2] = ellip(filter_order,ripple,attenuation,band_pass,'stop');
f = filter(bp_f_1,bp_f_2,f')';
k = k + 1;
band_pass = (band_width/sampling_frequency)*[-1 1] + k*center_frequency/(sampling_frequency/2);

end

close(h);

end
end

processed_data = f;
