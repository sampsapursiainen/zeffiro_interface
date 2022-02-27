%This is the startup script for MUSIC app. One must add this as launch
%script to zeffiro_plugins file:
%MUSIC, inverse_tools, MUSIC_app_start

zef.MUSIC = MUSIC_app;

%_ Names of methods that are included in app _
zef_MUSIC_names = {'Source projection',
                   'Noise out-projection'
                   };

zef.MUSIC.MUSIC_type.Items = zef_MUSIC_names;
zef.MUSIC.MUSIC_type.ItemsData = strsplit(num2str(1:length(zef_MUSIC_names)));
zef.MUSIC.MUSIC_type.Value = '1';
if ~isfield(zef,'MUSIC_type')
    zef.MUSIC_type = 1;
end

%_ Names of leadfield regularization methods _
zef_MUSIC_names = {'Basic',
                'Pseudoinverse'};

zef.MUSIC.MUSIC_L_reg_type.Items = zef_MUSIC_names;
zef.MUSIC.MUSIC_L_reg_type.ItemsData = strsplit(num2str(1:length(zef_MUSIC_names)));
zef.MUSIC.MUSIC_L_reg_type.Value = '1';
if ~isfield(zef,'MUSIC_L_reg_type')
    zef.MUSIC_L_reg_type = 1;
end

%_ Initial values _
zef.MUSIC.MUSIC_leadfield_lambda.Value = '1e-3';
zef.MUSIC.inv_snr.Value = '30';
zef.MUSIC.inv_sampling_frequency.Value = '1025';
zef.MUSIC.inv_low_cut_frequency.Value = '7';
zef.MUSIC.inv_high_cut_frequency.Value = '9';
zef.MUSIC.inv_time_1.Value = '0';
zef.MUSIC.inv_time_2.Value = '0';
zef.MUSIC.number_of_frames.Value = '0';
zef.MUSIC.inv_time_3.Value = '0';
zef.MUSIC.inv_data_segment.Value = '1';

if ~isfield(zef,'MUSIC_leadfield_lambda')
    zef.MUSIC_leadfield_lambda = 1e-3;
end

%set parameters if saved in ZI:
%(Naming concept: zef.MUSIC."field" = zef."field")
zef_props = properties(zef.MUSIC);
for zef_i = 1:length(zef_props)
    if isfield(zef,zef_props{zef_i})
        zef.MUSIC.(zef_props{zef_i}).Value = num2str(zef.(zef_props{zef_i}));
    end
end
clear zef_props zef_i

if zef.MUSIC_L_reg_type==2
    zef.MUSIC.MUSIC_leadfield_lambda.Enable = 'off';
end

%_ Functions _
zef.MUSIC.MUSIC_type.ValueChangedFcn = 'zef.MUSIC_type = str2num(zef.MUSIC.MUSIC_type.Value);';
zef.MUSIC.MUSIC_leadfield_lambda.ValueChangedFcn = 'zef.MUSIC_leadfield_lambda = str2num(zef.MUSIC.MUSIC_leadfield_lambda.Value);';
zef.MUSIC.MUSIC_L_reg_type.ValueChangedFcn = 'zef.MUSIC_L_reg_type = str2num(zef.MUSIC.MUSIC_L_reg_type.Value); if zef.MUSIC_L_reg_type==2 || zef.MUSIC_L_reg_type==3; zef.MUSIC.MUSIC_leadfield_lambda.Enable = ''off''; else; zef.MUSIC.MUSIC_leadfield_lambda.Enable = ''on''; end;';
zef.MUSIC.inv_snr.ValueChangedFcn = 'zef.inv_snr = str2num(zef.MUSIC.inv_snr.Value);';
zef.MUSIC.inv_sampling_frequency.ValueChangedFcn = 'zef.inv_sampling_frequency = str2num(zef.MUSIC.inv_sampling_frequency.Value);';
zef.MUSIC.inv_low_cut_frequency.ValueChangedFcn = 'zef.inv_low_cut_frequency = str2num(zef.MUSIC.inv_low_cut_frequency.Value);';
zef.MUSIC.inv_high_cut_frequency.ValueChangedFcn = 'zef.inv_high_cut_frequency = str2num(zef.MUSIC.inv_high_cut_frequency.Value);';
zef.MUSIC.inv_time_1.ValueChangedFcn = 'zef.inv_time_1 = str2num(zef.MUSIC.inv_time_1.Value);';
zef.MUSIC.inv_time_2.ValueChangedFcn = 'zef.inv_time_2 = str2num(zef.MUSIC.inv_time_2.Value);';
zef.MUSIC.number_of_frames.ValueChangedFcn = 'zef.number_of_frames = str2num(zef.MUSIC.number_of_frames.Value);';
zef.MUSIC.inv_time_3.ValueChangedFcn = 'zef.inv_time_3 = str2num(zef.MUSIC.inv_time_3.Value);';
zef.MUSIC.inv_data_segment.ValueChangedFcn = 'zef.inv_data_segment = str2num(zef.MUSIC.inv_data_segment.Value);';
zef.MUSIC.normalize_data.ValueChangedFcn = 'zef.normalize_data = str2num(zef.MUSIC.normalize_data.Value);';
zef.MUSIC.StartButton.ButtonPushedFcn = 'zef.reconstruction = MUSIC_iteration;';
zef.MUSIC.CloseButton.ButtonPushedFcn = 'delete(zef.MUSIC);';

%set fonts
set(findobj(zef.MUSIC.UIFigure.Children,'-property','FontSize'),'FontSize',zef.font_size);