function [processed_data] = zef_manual_epoching(f, epoch_points, start_time, end_time, sampling_frequency)
%Copyright © 2018- Sampsa Pursiainen & ZI Development Team
%See: https://github.com/sampsapursiainen/zeffiro_interface
%This function processes the N-by-M data array f for N channels and M time
%steps. The other arguments can be controlled via the ZI user interface.
%The desctiption and argument definitions shown in ZI are listed below.
%Description: Averaging over manually selected epochs
%Input: 1 Manually selected epoch points [Default: filter_epoch_points],
%2 Start time w.r.t. point (s) [Default: -0.18],
%3 End time w.r.t. point (s) [Default: 0.18],
%4 Sampling frequency (Hz) [Default: filter_sampling_rate]
%Output: Averaged data for the manually selected epochs.

%Conversion between string and numeric data types.
if isstr(epoch_points)
epoch_points = str2num(epoch_points);
end
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

epoch_point_ind = min(max(1,1 + round(epoch_points*sampling_frequency)),length_f);
start_time_ind =  sign(start_time)*min(max(1,round(abs(start_time)*sampling_frequency)),length_f);
end_time_ind =   sign(end_time)*min(max(1,round(abs(end_time)*sampling_frequency)),length_f);

epoch_data = zeros(size(f,1), end_time_ind-start_time_ind+1);

for i = 1 : length(epoch_points)

    epoch_data = epoch_data + f(:, start_time_ind+epoch_point_ind(i):end_time_ind+epoch_point_ind(i));

end

epoch_data = epoch_data/length(epoch_points);

processed_data = epoch_data;