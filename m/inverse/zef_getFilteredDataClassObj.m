function [f] = zef_getFilteredDataClassObj(zef,ClassObj)
%zef_getFilteredData reads the datafrom zef.measurement and applies the
%filter that are specified in zef.inv_low_cut_frequency and
%zef.inv_low_cut_frequency at a sampling frequency of
%zef.inv_sampling_frequency.
% f has the same size as the measurement

if (nargin == 0)
zef = evalin('base','zef');
end 

if isequal(zef.inv_data_mode,'filtered_temporal') %what is this???

    f = eval('zef.measurements');
    
high_pass = ClassObj.low_cut_frequency;
low_pass = ClassObj.high_cut_frequency;
sampling_freq = ClassObj.sampling_frequency;

switch ClassObj.data_normalization_method
    case "maximum entry"
        data_norm = max(abs(f(:)));
    case "maximum column norm"
        data_norm = max(sqrt(sum(abs(f).^2)));
    case "average column norm"
        data_norm = sum(sqrt(sum(abs(f).^2)))/size(f,2);
    otherwise
        data_norm = 1;
end
f = f/data_norm;

filter_order = 3;
if size(f,2) > 1 && low_pass > 0
    [lp_f_1,lp_f_2] = ellip(filter_order,3,80,low_pass/(sampling_freq/2));
    f = filter(lp_f_1,lp_f_2,f')';
end
if size(f,2) > 1 && high_pass > 0
    [hp_f_1,hp_f_2] = ellip(filter_order,3,80,high_pass/(sampling_freq/2),'high');
    f = filter(hp_f_1,hp_f_2,f')';
end

elseif isequal(zef.inv_data_mode,'raw')
    
    f = eval('zef.measurements');

end

end