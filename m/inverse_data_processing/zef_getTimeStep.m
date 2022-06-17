function [f,t] = zef_getTimeStep(f_data, f_ind, varargin)
%zef_getTimeStep gets the time windows and segments of f_data that are
%specified in the zef.inv_time* parameters. f_ind gives the number of the given window (first, second, third ...)
% if there is only one time step, f_data is returned.
%Should the specified time steps exceed the data length, an empty array is
%returned.
%If a window is specified, averaging can be applied. The behavior is
%specified in Optional_averaging_bool, with a default of true

Optional_averaging_bool=true;
object_string = 'inv';
if not(isempty(varargin))
 Optional_averaging_bool = varargin{1};
if length(varargin) > 1
object_string = varargin{2};
end 
end

if evalin('base',['isfield(zef,''' object_string '_time_3'')'])
    time_step = evalin('base',['zef.' object_string '_time_3']);
else
    time_step = Inf;
end

sampling_freq = evalin('base',['zef.' object_string '_sampling_frequency']);

size_Data=size(f_data,2);
%this part gives wrong values, because it uses the time step length?
if size_Data>1
    if evalin('base',['zef.' object_string '_time_2']) >=0 && evalin('base',['zef.' object_string '_time_1']) >= 0 && 1 + sampling_freq*evalin('base',['zef.' object_string '_time_1']) <= size_Data
        t_ind = max(1, 1 + floor(sampling_freq*evalin('base',['zef.' object_string '_time_1'])+sampling_freq*(f_ind - 1)*time_step)) : ...
            min(size_Data, 1 + floor(sampling_freq*(evalin('base',['zef.' object_string '_time_1']) + evalin('base',['zef.' object_string '_time_2']))+sampling_freq*(f_ind - 1)*time_step));
        f = f_data(:, t_ind);
        t = (double(t_ind)-1)./sampling_freq;
    end
else
    f=f_data;
end

if Optional_averaging_bool && size(f,2) > 1
    f = mean(f,2);
end

end
