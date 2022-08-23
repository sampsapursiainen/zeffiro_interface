function [f] = zef_getFilteredData(varargin)
%zef_getFilteredData reads the datafrom zef.measurement and applies the
%filter that are specified in zef.inv_low_cut_frequency and
%zef.inv_low_cut_frequency at a sampling frequency of
%zef.inv_sampling_frequency.
% f has the same size as the measurement

object_string = 'inv';
use_normalization = 0;
if not(isempty(varargin))
object_string = varargin{1};
if length(varargin) > 1
use_normalization = varargin{2};
end
end

f = evalin('base','zef.measurements');
high_pass = evalin('base',['zef.' object_string '_low_cut_frequency']);
low_pass = evalin('base',['zef.' object_string '_high_cut_frequency']);
sampling_freq = evalin('base',['zef.' object_string '_sampling_frequency']);

if use_normalization
switch evalin('base','zef.normalize_data')
    case 1
        data_norm = max(abs(f(:)));
    case 2
        data_norm = max(sqrt(sum(abs(f).^2)));
    case 3
        data_norm = sum(sqrt(sum(abs(f).^2)))/size(f,2);
    otherwise
        data_norm = 1;
end
f = f/data_norm;
end

filter_order = 3;
if size(f,2) > 1 && low_pass > 0
    [lp_f_1,lp_f_2] = ellip(filter_order,3,80,low_pass/(sampling_freq/2));
    f = filter(lp_f_1,lp_f_2,f')';
end
if size(f,2) > 1 && high_pass > 0
    [hp_f_1,hp_f_2] = ellip(filter_order,3,80,high_pass/(sampling_freq/2),'high');
    f = filter(hp_f_1,hp_f_2,f')';
end

end
