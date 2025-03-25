function [f,t] = zef_getTimeStep(f_data, f_ind, zef)
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
  
if isfield(zef,'inv_time_3')
    time_step = eval(['zef.inv_time_3']);
else
    time_step = Inf;
end

sampling_freq = eval(['zef.inv_sampling_frequency']);

size_Data=size(f_data,2);

if not(isfield(zef,'inv_time_2'))
zef.inv_time_2 = 0;
end

if size_Data>1
    if eval(['zef.inv_time_2']) >=0 && eval(['zef.inv_time_1']) >= 0 && 1 + sampling_freq*eval(['zef.inv_time_1']) <= size_Data
        t_ind = max(1, 1 + floor(sampling_freq*eval(['zef.inv_time_1'])+sampling_freq*(f_ind - 1)*time_step)) : ...
            min(size_Data, 1 + floor(sampling_freq*(eval(['zef.inv_time_1']) + eval(['zef.inv_time_2']))+sampling_freq*(f_ind - 1)*time_step));
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

end
