function [f,t] = zef_getTimeStepClassObj(f_data, f_ind, zef, ClassObj)
%zef_getTimeStep gets the time windows and segments of f_data that are
%specified in the zef.inv_time* parameters. f_ind gives the number of the given window (first, second, third ...)
% if there is only one time step, f_data is returned.
%Should the specified time steps exceed the data length, an empty array is
%returned.
%If a window is specified, averaging can be applied. The behavior is
%specified in Optional_averaging_bool, with a default of true

if nargin < 3
zef = evalin('base','zef');
end

if isequal(zef.inv_data_mode,'filtered_temporal')
  
time_step = ClassObj.time_step;


sampling_freq = ClassObj.sampling_frequency;

size_Data=size(f_data,2);


if size_Data>1
    if ClassObj.time_window >=0 && ClassObj.time_start >= 0 && 1 + sampling_freq*ClassObj.time_start <= size_Data
        t_ind = max(1, 1 + floor(sampling_freq*ClassObj.time_start + sampling_freq*(f_ind - 1)*time_step)) : ...
            min(size_Data, 1 + floor(sampling_freq*(ClassObj.time_start + ClassObj.time_window)+sampling_freq*(f_ind - 1)*time_step));
        f = f_data(:, t_ind);
        t = (double(t_ind)-1)./sampling_freq;
    end
else
    f=f_data;
end

if isfield(zef,'inv_time_interval_averaging')
if zef.inv_time_interval_averaging
    f = mean(f,2);
end
end

elseif isequal(zef.inv_data_mode,'raw')
    
   f = f_data(:,f_ind);
    
end

if size(f,2) > 1
    f = mean(f,2);
end

end
