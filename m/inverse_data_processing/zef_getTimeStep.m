function [f] = zef_getTimeStep(f_data, f_ind, Optional_averaging_bool)
%zef_getTimeStep gets the time windows and segments of f_data that are
%specified in the zef.inv_time* parameters. f_ind gives the number of the given window (first, second, third ...)
% if there is only one time step, f_data is returned.
%Should the specified time steps exceed the data length, an empty array is
%returned.
%If a window is specified, averaging can be applied. The behavior is
%specified in Optional_averaging_bool, with a default of true

if nargin<3
    Optional_averaging_bool=true;
end

sampling_freq = evalin('base','zef.inv_sampling_frequency');

size_Data=size(f_data,2);
%this part gives wrong values, because it uses the time step length?
if size_Data>1
    if evalin('base','zef.inv_time_2') >=0 && evalin('base','zef.inv_time_1') >= 0 && 1 + sampling_freq*evalin('base','zef.inv_time_1') <= size_Data
        f = f_data(:, max(1, 1 + floor(sampling_freq*evalin('base','zef.inv_time_1')+sampling_freq*(f_ind - 1)*evalin('base','zef.inv_time_3'))) : ...
            min(size_Data, 1 + floor(sampling_freq*(evalin('base','zef.inv_time_1') + evalin('base','zef.inv_time_2'))+sampling_freq*(f_ind - 1)*evalin('base','zef.inv_time_3'))));
    end
else
    f=f_data;
end

if Optional_averaging_bool && size(f,2) > 1
    f = mean(f,2);
end

end

