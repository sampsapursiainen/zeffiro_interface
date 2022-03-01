%This is the startup script for beamformer app. One must add this as launch
%script to zeffiro_plugins file:
%Beamformer, inverse_tools, zef_beamformer_start

zef.beamformer = beamformer_app;

%_ Names of methods that are included in app _
zef_bf_names = {'Linearly constraint minimum variance (LCMV)'
                'Unit noise gain beamformer'
                'Unit-gain constraint beamformer'
                'Unit nosie gain scalar beamformer'
                };

zef.beamformer.bf_type.Items = zef_bf_names;
zef.beamformer.bf_type.ItemsData = strsplit(num2str(1:length(zef_bf_names)));
zef.beamformer.bf_type.Value = '1';
if ~isfield(zef,'bf_type')
    zef.bf_type = 1;
end

%_ Covariance calculation types _
%_ Covariance calculation types _
zef_bf_names = {'Full data, measurement based',
                'Full data, basic',
                'Pointwise, measurement based',
                'Pointwise, basic'
                };

zef.beamformer.cov_type.Items = zef_bf_names;
zef.beamformer.cov_type.ItemsData = strsplit(num2str(1:length(zef_bf_names)));
zef.beamformer.cov_type.Value = '1';
if ~isfield(zef,'cov_type')
    zef.cov_type = 1;
end

%_ Names of leadfield regularization methods _
zef_bf_names = {'Basic'
                'Pseudoinverse'};

zef.beamformer.L_reg_type.Items = zef_bf_names;
zef.beamformer.L_reg_type.ItemsData = strsplit(num2str(1:length(zef_bf_names)));
zef.beamformer.L_reg_type.Value = '1';
if ~isfield(zef,'L_reg_type')
    zef.L_reg_type = 1;
end

%_ Names of leadfield normalizations _
zef_bf_names = {'Matrix norm'
                'Column norm'
                'Row norm'
                'None'};

zef.beamformer.normalize_leadfield.Items = zef_bf_names;
zef.beamformer.normalize_leadfield.ItemsData = strsplit(num2str(1:length(zef_bf_names)));
zef.beamformer.normalize_leadfield.Value = '1';
if ~isfield(zef,'normalize_leadfield')
    zef.normalize_leadfield = 1;
end

%_ Initial values _
zef.beamformer.inv_cov_lambda.Value = '5e-2';
zef.beamformer.inv_leadfield_lambda.Value = '1e-3';
zef.beamformer.inv_snr.Value = '30';
zef.beamformer.inv_sampling_frequency.Value = '1025';
zef.beamformer.inv_low_cut_frequency.Value = '7';
zef.beamformer.inv_high_cut_frequency.Value = '9';
zef.beamformer.inv_time_1.Value = '0';
zef.beamformer.inv_time_2.Value = '0';
zef.beamformer.number_of_frames.Value = '0';
zef.beamformer.inv_time_3.Value = '0';
zef.beamformer.inv_data_segment.Value = '1';

if ~isfield(zef,'inv_cov_lambda')
    zef.inv_cov_lambda = 5e-2;
end
if ~isfield(zef,'inv_leadfield_lambda')
    zef.inv_leadfield_lambda = 1e-3;
end

%set parameters if saved in ZI:
%(Naming concept: zef.beamformer."field" = zef."field")
zef_props = properties(zef.beamformer);
for zef_i = 1:length(zef_props)
    if isfield(zef,zef_props{zef_i})
        zef.beamformer.(zef_props{zef_i}).Value = num2str(zef.(zef_props{zef_i}));
    end
end
clear zef_props zef_i zef_bf_names

if zef.L_reg_type==2 || zef.L_reg_type==3
    zef.beamformer.inv_leadfield_lambda.Enable = 'off';
end

%_ Functions _
zef.beamformer.bf_type.ValueChangedFcn = 'zef.bf_type = str2num(zef.beamformer.bf_type.Value);';
zef.beamformer.inv_cov_lambda.ValueChangedFcn = 'zef.inv_cov_lambda = str2num(zef.beamformer.inv_cov_lambda.Value);';
zef.beamformer.inv_leadfield_lambda.ValueChangedFcn = 'zef.inv_leadfield_lambda = str2num(zef.beamformer.inv_leadfield_lambda.Value);';
zef.beamformer.cov_type.ValueChangedFcn = 'zef.cov_type = str2num(zef.beamformer.cov_type.Value); if zef.cov_type==0; zef.beamformer.inv_cov_lambda.Enable = ''off''; else; zef.beamformer.inv_cov_lambda.Enable = ''on''; end;';
zef.beamformer.L_reg_type.ValueChangedFcn = 'zef.L_reg_type = str2num(zef.beamformer.L_reg_type.Value); if zef.L_reg_type==2 || zef.L_reg_type==3; zef.beamformer.inv_leadfield_lambda.Enable = ''off''; else; zef.beamformer.inv_leadfield_lambda.Enable = ''on''; end;';
zef.beamformer.inv_snr.ValueChangedFcn = 'zef.inv_snr = str2num(zef.beamformer.inv_snr.Value);';
zef.beamformer.inv_sampling_frequency.ValueChangedFcn = 'zef.inv_sampling_frequency = str2num(zef.beamformer.inv_sampling_frequency.Value);';
zef.beamformer.inv_low_cut_frequency.ValueChangedFcn = 'zef.inv_low_cut_frequency = str2num(zef.beamformer.inv_low_cut_frequency.Value);';
zef.beamformer.inv_high_cut_frequency.ValueChangedFcn = 'zef.inv_high_cut_frequency = str2num(zef.beamformer.inv_high_cut_frequency.Value);';
zef.beamformer.inv_time_1.ValueChangedFcn = 'zef.inv_time_1 = str2num(zef.beamformer.inv_time_1.Value);';
zef.beamformer.inv_time_2.ValueChangedFcn = 'zef.inv_time_2 = str2num(zef.beamformer.inv_time_2.Value);';
zef.beamformer.number_of_frames.ValueChangedFcn = 'zef.number_of_frames = str2num(zef.beamformer.number_of_frames.Value);';
zef.beamformer.inv_time_3.ValueChangedFcn = 'zef.inv_time_3 = str2num(zef.beamformer.inv_time_3.Value);';
zef.beamformer.inv_data_segment.ValueChangedFcn = 'zef.inv_data_segment = str2num(zef.beamformer.inv_data_segment.Value);';
zef.beamformer.normalize_data.ValueChangedFcn = 'zef.normalize_data = str2num(zef.beamformer.normalize_data.Value);';
zef.beamformer.normalize_leadfield.ValueChangedFcn = 'zef.normalize_leadfield = str2num(zef.beamformer.normalize_leadfield.Value);';
zef.beamformer.StartButton.ButtonPushedFcn = 'if strcmp(zef.beamformer.estimation_attr.Value,''1''); [zef.reconstruction,~, zef.reconstruction_information] = zef_beamformer; elseif strcmp(zef.beamformer.estimation_attr.Value,''2''); [~,zef.reconstruction, zef.reconstruction_information] = zef_beamformer; else; [zef.reconstruction,zef.bf_var_loc, zef.reconstruction_information] = zef_beamformer; end;';
zef.beamformer.CloseButton.ButtonPushedFcn = 'delete(zef.beamformer);';

%set fonts
set(findobj(zef.beamformer.UIFigure.Children,'-property','FontSize'),'FontSize',zef.font_size);
