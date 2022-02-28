function [processed_data] = zef_define_time_interval(f, start_time, end_time, sampling_frequency)
%Copyright © 2018- Sampsa Pursiainen & ZI Development Team
%See: https://github.com/sampsapursiainen/zeffiro_interface
%This function processes the N-by-M data array f for N channels and M time
%steps. The other arguments can be controlled via the ZI user interface.
%The desctiption and argument definitions shown in ZI are listed below.
%Description: Define time interval
%Input: 1 Start time (s) [Default: 0], 2 End time (s) [Default: Inf],
%3 Sampling frequency (Hz) [Default: filter_sampling_rate]
%Output: Data limited to the given time interval.

%Conversion between string and numeric data types.
if isstr(start_time)
start_time = str2num(start_time);
end
if isstr(end_time)
end_time = str2num(end_time);
end
if isstr(sampling_frequency)
sampling_frequency = str2num(sampling_frequency);
end
%End of conversion.

length_f = size(f,2);

start_time_ind = min(max(1,1 + round(start_time*sampling_frequency)),length_f);
end_time_ind =   min(max(1,1 + round(end_time*sampling_frequency)),length_f);

processed_data = f(:,start_time_ind:end_time_ind);