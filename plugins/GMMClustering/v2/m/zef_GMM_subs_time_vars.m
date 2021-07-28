%function for changing time serie parameters temporarly for GMM visualization
%Input char 'in' means replacing inv_... parameters with the ones saved to
%GMM structure and 'out' changes them back. parameter are temporarly placed
%on workspace with names like zef_temp_time_1

function zef_GMM_subs_time_vars(char_var)
if evalin('base','isfield(zef.GMM,''time_variables'')')
if evalin('base','~isempty(zef.GMM.time_variables)')
if strcmp(char_var,'in')
    evalin('base','zef_temp_time_1 = zef.inv_time_1;');
    evalin('base','zef_temp_time_2 = zef.inv_time_2;');
    evalin('base','zef_temp_time_3 = zef.inv_time_3;');
    evalin('base','zef_temp_sampling_frequency = zef.inv_sampling_frequency;');
    
    evalin('base','zef.inv_time_1 = zef.GMM.time_variables.time_1;');
    evalin('base','zef.inv_time_2 = zef.GMM.time_variables.time_2;');
    evalin('base','zef.inv_time_3 = zef.GMM.time_variables.time_3;');
    evalin('base','zef.inv_sampling_frequency = zef.GMM.time_variables.sampling_frequency;');
elseif strcmp(char_var,'out')
    evalin('base','zef.inv_time_1 = zef_temp_time_1;');
    evalin('base','zef.inv_time_2 = zef_temp_time_2;');
    evalin('base','zef.inv_time_3 = zef_temp_time_3;');
    evalin('base','zef.inv_sampling_frequency = zef_temp_sampling_frequency;');
    evalin('base','clear zef_temp_time_1 zef_temp_time_2 zef_temp_time_3 zef_temp_sampling_frequency;');
end
end
end

end
