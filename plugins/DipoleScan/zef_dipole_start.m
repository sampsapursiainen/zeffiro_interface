%This is the startup script for dipole_app app. One must add this as launch
%script to zeffiro_plugins file:
%dipoleScan, inverse_tools, zef_dipole_start

zef.dipole_app = dipole_app;
appName='dipole_app';

%_ Names of leadfield regularization methods _
% zef_bf_names = {'Basic'
%                 '2nd order Taylor minimum error'
%                 'Pseudoinverse'};
%
% zef.beamformer.L_reg_type.Items = zef_bf_names;
% zef.beamformer.L_reg_type.ItemsData = strsplit(num2str(1:length(zef_bf_names)));
% zef.beamformer.L_reg_type.Value = '1';
% if ~isfield(zef,'L_reg_type')
%     zef.L_reg_type = 1;
% end

%Import or set initial values

zef.inv_names={'inv_leadfield_lambda', 'inv_snr', 'inv_sampling_frequency', 'inv_low_cut_frequency',...
    'inv_high_cut_frequency', 'inv_time_1', 'inv_time_2', 'number_of_frames', 'inv_time_3', 'inv_data_segment'...
    'normalize_leadfield', 'L_reg_type'};
zef.inv_default={1e-3, 30, 2400, 2, 80, 0, 0, 0, 0, 1, 1, 1};
for invNames=1:length(zef.inv_names)
    if ~isfield(zef,zef.inv_names{invNames})
        zef.(zef.inv_names{invNames})=zef.inv_default{invNames};
    end
    %if isfield(zef.(appName),zef.inv_names{invNames})
%        zef.(appName).(zef.inv_names{invNames}).Value=zef.(zef.inv_names{invNames});
    %end
end

% % this is quite elegant
%
% %set parameters if saved in ZI:
% %(Naming concept: zef.(app)."field" = zef."field")
 zef_props = properties(zef.(appName));
for zef_i = 1:length(zef_props)
    if isfield(zef,zef_props{zef_i})
        zef.(appName).(zef_props{zef_i}).Value = num2str(zef.(zef_props{zef_i}));
    end
end
clear zef_props zef_i

if zef.L_reg_type==2 || zef.L_reg_type==3
    zef.dipole.inv_leadfield_lambda.Enable = 'off';
end

%_ Functions _
zef.dipole_app.dipole_type.ValueChangedFcn = 'zef.dipole_type = str2num(zef.dipole_app.dipole_type.Value);';
%zef.dipole_app.inv_leadfield_lambda.ValueChangedFcn = 'zef.inv_leadfield_lambda = str2num(zef.dipole_app.inv_leadfield_lambda.Value);';
%zef.dipole_app.L_reg_type.ValueChangedFcn = 'zef.L_reg_type = str2num(zef.dipole_app.L_reg_type.Value); if zef.L_reg_type==2 || zef.L_reg_type==3; zef.dipole_app.inv_leadfield_lambda.Enable = ''off''; else; zef.dipole_app.inv_leadfield_lambda.Enable = ''on''; end;';
zef.dipole_app.inv_snr.ValueChangedFcn = 'zef.inv_snr = str2num(zef.dipole_app.inv_snr.Value);';
zef.dipole_app.inv_sampling_frequency.ValueChangedFcn = 'zef.inv_sampling_frequency = str2num(zef.dipole_app.inv_sampling_frequency.Value);';
zef.dipole_app.inv_low_cut_frequency.ValueChangedFcn = 'zef.inv_low_cut_frequency = str2num(zef.dipole_app.inv_low_cut_frequency.Value);';
zef.dipole_app.inv_high_cut_frequency.ValueChangedFcn = 'zef.inv_high_cut_frequency = str2num(zef.dipole_app.inv_high_cut_frequency.Value);';
zef.dipole_app.inv_time_1.ValueChangedFcn = 'zef.inv_time_1 = str2num(zef.dipole_app.inv_time_1.Value);';
zef.dipole_app.inv_time_2.ValueChangedFcn = 'zef.inv_time_2 = str2num(zef.dipole_app.inv_time_2.Value);';
zef.dipole_app.number_of_frames.ValueChangedFcn = 'zef.number_of_frames = str2num(zef.dipole_app.number_of_frames.Value);';
zef.dipole_app.inv_time_3.ValueChangedFcn = 'zef.inv_time_3 = str2num(zef.dipole_app.inv_time_3.Value);';
zef.dipole_app.inv_data_segment.ValueChangedFcn = 'zef.inv_data_segment = str2num(zef.dipole_app.inv_data_segment.Value);';
zef.dipole_app.normalize_data.ValueChangedFcn = 'zef.normalize_data = str2num(zef.dipole_app.normalize_data.Value);';
zef.dipole_app.normalize_leadfield.ValueChangedFcn = 'zef.normalize_leadfield = str2num(zef.dipole_app.normalize_leadfield.Value);';

zef.dipole_app.StartButton.ButtonPushedFcn = '[zef.reconstruction, zef.reconstruction_information]=zef_dipoleScan;';
zef.dipole_app.CloseButton.ButtonPushedFcn = 'delete(zef.dipole_app);';

%set fonts
%set(findobj(zef.dipole_app.UIFigure.Children,'-property','FontSize'),'FontSize',zef.font_size);
