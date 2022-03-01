%This is the startup script for MUSIC app. One must add this as launch
%script to zeffiro_plugins file:
%MUSIC, inverse_tools, MUSIC_app_start

zef.RAPMUSIC = RAPMUSIC_app;

%_ Initial values _
zef.RAPMUSIC.RAPMUSIC_leadfield_lambda.Value = '1e-3';
zef.RAPMUSIC.inv_snr.Value = '30';
zef.RAPMUSIC.RAPMUSIC_n_dipoles.Value = '8';
zef.RAPMUSIC.inv_sampling_frequency.Value = '1025';
zef.RAPMUSIC.inv_low_cut_frequency.Value = '7';
zef.RAPMUSIC.inv_high_cut_frequency.Value = '9';
zef.RAPMUSIC.inv_time_1.Value = '0';
zef.RAPMUSIC.inv_time_2.Value = '0';
zef.RAPMUSIC.number_of_frames.Value = '0';
zef.RAPMUSIC.inv_time_3.Value = '0';

if ~isfield(zef,'RAPMUSIC_leadfield_lambda')
    zef.RAPMUSIC_leadfield_lambda = 1e-3;
end
if ~isfield(zef,'RAPMUSIC_n_dipoles')
    zef.RAPMUSIC_n_dipoles = 8;
end

%set parameters if saved in ZI:
%(Naming concept: zef.RAPMUSIC."field" = zef."field")
zef_props = properties(zef.RAPMUSIC);
for zef_i = 1:length(zef_props)
    if isfield(zef,zef_props{zef_i})
        zef.RAPMUSIC.(zef_props{zef_i}).Value = num2str(zef.(zef_props{zef_i}));
    end
end
clear zef_props zef_i

%_ Functions _
zef.RAPMUSIC.inv_hyperprior.ValueChangedFcn = 'zef.inv_hyperprior = str2num(zef.RAPMUSIC.inv_hyperprior.Value);';
zef.RAPMUSIC.RAPMUSIC_leadfield_lambda.ValueChangedFcn = 'zef.RAPMUSIC_leadfield_lambda = str2num(zef.RAPMUSIC.RAPMUSIC_leadfield_lambda.Value);';
zef.RAPMUSIC.inv_snr.ValueChangedFcn = 'zef.inv_snr = str2num(zef.RAPMUSIC.inv_snr.Value);';
zef.RAPMUSIC.RAPMUSIC_n_dipoles.ValueChangedFcn = 'zef.RAPMUSIC_n_dipoles = str2num(zef.RAPMUSIC.RAPMUSIC_n_dipoles.Value);';
zef.RAPMUSIC.inv_sampling_frequency.ValueChangedFcn = 'zef.inv_sampling_frequency = str2num(zef.RAPMUSIC.inv_sampling_frequency.Value);';
zef.RAPMUSIC.inv_low_cut_frequency.ValueChangedFcn = 'zef.inv_low_cut_frequency = str2num(zef.RAPMUSIC.inv_low_cut_frequency.Value);';
zef.RAPMUSIC.inv_high_cut_frequency.ValueChangedFcn = 'zef.inv_high_cut_frequency = str2num(zef.RAPMUSIC.inv_high_cut_frequency.Value);';
zef.RAPMUSIC.inv_time_1.ValueChangedFcn = 'zef.inv_time_1 = str2num(zef.RAPMUSIC.inv_time_1.Value);';
zef.RAPMUSIC.inv_time_2.ValueChangedFcn = 'zef.inv_time_2 = str2num(zef.RAPMUSIC.inv_time_2.Value);';
zef.RAPMUSIC.number_of_frames.ValueChangedFcn = 'zef.number_of_frames = str2num(zef.RAPMUSIC.number_of_frames.Value);';
zef.RAPMUSIC.inv_time_3.ValueChangedFcn = 'zef.inv_time_3 = str2num(zef.RAPMUSIC.inv_time_3.Value);';
zef.RAPMUSIC.normalize_data.ValueChangedFcn = 'zef.normalize_data = str2num(zef.RAPMUSIC.normalize_data.Value);';
zef.RAPMUSIC.StartButton.ButtonPushedFcn = 'zef.reconstruction = RAP_MUSIC_iteration;';
zef.RAPMUSIC.CloseButton.ButtonPushedFcn = 'delete(zef.RAPMUSIC);';

%set fonts
set(findobj(zef.RAPMUSIC.UIFigure.Children,'-property','FontSize'),'FontSize',zef.font_size);