function [processed_data] = zef_threshold_epoching(f, threshold_value, number_of_epochs, start_time, end_time, sampling_frequency)
%Copyright © 2018- Sampsa Pursiainen & ZI Development Team
%See: https://github.com/sampsapursiainen/zeffiro_interface
%This function processes the N-by-M data array f for N channels and M time
%steps. The other arguments can be controlled via the ZI user interface.
%The desctiption and argument definitions shown in ZI are listed below.
%Description: Averaging over epochs obtained via thresholding
%Input: 1 Threshold value (db) [Default: -6],
%2 Number of epochs [Default: ],
%3 Start time w.r.t. point (s) [Default: -0.18],
%4 End time w.r.t. point (s) [Default: 0.18],
%5 Sampling frequency (Hz) [Default: filter_sampling_rate]
%Output: Averaged data for epochs obtained via thresholding.

%Conversion between string and numeric data types.
if isstr(threshold_value)
threshold_value = str2num(threshold_value);
end
if isstr(number_of_epochs)
number_of_epochs = str2num(number_of_epochs);
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

if isempty(number_of_epochs)
    number_of_epochs = Inf;
end

f_db = f/max(abs(f(:)));
f_db = max(db(f_db));

start_time_ind =  sign(start_time)*min(max(1,round(abs(start_time)*sampling_frequency)),length_f);
end_time_ind =   sign(end_time)*min(max(1,round(abs(end_time)*sampling_frequency)),length_f);

epoch_data = zeros(size(f,1), end_time_ind-start_time_ind+1);

n_epochs = 0;

while size(f_db, 2) >= size(epoch_data,2) && max(f_db) >= threshold_value && n_epochs < number_of_epochs

    n_epochs = n_epochs + 1;
    epoch_point_ind = find(f_db >= threshold_value,1);
    epoch_data = epoch_data + f(:, start_time_ind+epoch_point_ind:end_time_ind+epoch_point_ind);

    f = f(:,end_time_ind+epoch_point_ind+1:end);
    f_db = f_db(:,end_time_ind+epoch_point_ind+1:end);

end

epoch_data = epoch_data/n_epochs;

processed_data = epoch_data;