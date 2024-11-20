%This is the startup script for KF app. One must add this as launch
%script to zeffiro_plugins file:
%Beamformer, inverse_tools, zef_KF_start

zef.KF = zef_kf_app;

%_ Initial values _
zef.KF.inv_snr.Value = '30';
zef.KF.inv_sampling_frequency.Value = '1025';
zef.KF.inv_low_cut_frequency.Value = '7';
zef.KF.inv_high_cut_frequency.Value = '9';
zef.KF.inv_time_1.Value = '0';
zef.KF.inv_time_2.Value = '0';
zef.KF.number_of_frames.Value = '0';
zef.KF.inv_time_3.Value = '0';
zef.KF.filter_type.Value = '1';
zef.KF.number_of_ensembles.Value = '100';
zef.KF.kf_number_of_noise_steps.Value = '4';


%set parameters if saved in ZI: 
%(Naming concept: zef.KF."field" = zef."field")
zef_props = properties(zef.KF);
for zef_i = 1:length(zef_props)
    if isfield(zef,zef_props{zef_i})
        zef.KF.(zef_props{zef_i}).Value = num2str(zef.(zef_props{zef_i}));
    elseif isprop(zef.KF.(zef_props{zef_i}),'Value')
        zef.(zef_props{zef_i}) = str2num(zef.KF.(zef_props{zef_i}).Value);
    end
end
clear zef_props zef_i

%_ Functions _
zef.KF.inv_snr.ValueChangedFcn = 'zef.inv_snr = str2num(zef.KF.inv_snr.Value);';
zef.KF.inv_sampling_frequency.ValueChangedFcn = 'zef.inv_sampling_frequency = str2num(zef.KF.inv_sampling_frequency.Value);';
zef.KF.inv_low_cut_frequency.ValueChangedFcn = 'zef.inv_low_cut_frequency = str2num(zef.KF.inv_low_cut_frequency.Value);';
zef.KF.inv_high_cut_frequency.ValueChangedFcn = 'zef.inv_high_cut_frequency = str2num(zef.KF.inv_high_cut_frequency.Value);';
zef.KF.inv_time_1.ValueChangedFcn = 'zef.inv_time_1 = str2num(zef.KF.inv_time_1.Value);';
zef.KF.inv_time_2.ValueChangedFcn = 'zef.inv_time_2 = str2num(zef.KF.inv_time_2.Value);';
zef.KF.number_of_frames.ValueChangedFcn = 'zef.number_of_frames = str2num(zef.KF.number_of_frames.Value);';
zef.KF.kf_number_of_noise_steps.ValueChangedFcn = 'zef.kf_number_of_noise_steps = str2num(zef.KF.kf_number_of_noise_steps.Value);';
zef.KF.number_of_ensembles.ValueChangedFcn = 'zef.number_of_ensembles = str2num(zef.KF.number_of_ensembles.Value);';
zef.KF.inv_time_3.ValueChangedFcn = 'zef.inv_time_3 = str2num(zef.KF.inv_time_3.Value);';
zef.KF.kf_smoothing.ValueChangedFcn = 'zef.kf_smoothing = str2num(zef.KF.kf_smoothing.Value);';
zef.KF.StartButton.ButtonPushedFcn = 'zef = zef_KF(zef);';
zef.KF.ApplyButton.ButtonPushedFcn = 'zef_props = properties(zef.KF); for zef_i = 1:length(zef_props); if isprop(zef.KF.(zef_props{zef_i}),''Value''); zef.(zef_props{zef_i}) = str2num(zef.KF.(zef_props{zef_i}).Value); end; end; clear zef_props zef_i;';
zef.KF.CloseButton.ButtonPushedFcn = 'delete(zef.KF);';
zef.KF.filter_type.ValueChangedFcn = 'zef.filter_type = str2num(zef.KF.filter_type.Value);';

%set fonts
set(findobj(zef.KF.UIFigure.Children,'-property','FontSize'),'FontSize',zef.font_size);
