%This is the startup function for KF app. 
%Beamformer, inverse_tools, zef_KF_start
function zef = zef_kf_open_window(zef)

if nargin == 0
    zef = evalin('base','zef');
end

zef.KF = zef_kf_app;

zef.KF.filter_type.Items = {'No standardization'  'Spatiotemporal standardization'  'Spatial standardization'};
zef.KF.filter_type.ItemsData = {'1'  '3'  '4' };

zef.KF.standardization_exponent.Items = {'1/2' '1' '5/4' '3/2' '7/4' '2'};
zef.KF.standardization_exponent.ItemsData = {'0.5'  '1' '1.25' '1.5' '1.75' '2'};

%_ Initial values _
if isfield(zef,'inv_snr')
zef.KF.inv_snr.Value = num2str(zef.inv_snr);
else
zef.KF.inv_snr.Value = '30';
end

if isfield(zef,'standardization_exponent')
zef.KF.standardization_exponent.Value = num2str(zef.standardization_exponent);
else
zef.KF.standardization_exponent.Value = zef.KF.standardization_exponent.ItemsData{2};
end

if isfield(zef,'inv_sampling_frequency')
zef.KF.inv_sampling_frequency.Value = num2str(zef.inv_sampling_frequency);
else
zef.KF.inv_sampling_frequency.Value = '1025';
end

if isfield(zef,'inv_low_cut_frequency')
zef.KF.inv_low_cut_frequency.Value = num2str(zef.inv_low_cut_frequency);
else
zef.KF.inv_low_cut_frequency.Value = '7';
end

if isfield(zef,'inv_high_cut_frequency')
zef.KF.inv_high_cut_frequency.Value = num2str(zef.inv_high_cut_frequency);
else
zef.KF.inv_high_cut_frequency.Value = '9';
end

if isfield(zef,'inv_time_1')
zef.KF.inv_time_1.Value = num2str(zef.inv_time_1);
else
zef.KF.inv_time_1.Value = '0';
end

if isfield(zef,'inv_time_2')
zef.KF.inv_time_2.Value = num2str(zef.inv_time_2);    
else
    zef.KF.inv_time_2.Value = '0';
end

if isfield(zef,'number_of_frames')
zef.KF.number_of_frames.Value = num2str(zef.number_of_frames);
else
zef.KF.number_of_frames.Value = '0';
end

if isfield(zef,'inv_time_3')
zef.KF.inv_time_3.Value = num2str(zef.inv_time_3);
else
zef.KF.inv_time_3.Value = '0';
end

if isfield(zef,'filter_type')
zef.KF.filter_type.Value = num2str(zef.filter_type);
else
zef.KF.filter_type.Value = '1';
end

if isfield(zef,'number_of_ensembles')
zef.KF.number_of_ensembles.Value = num2str(zef.number_of_ensembles);
else
zef.KF.number_of_ensembles.Value = '100';
end

if isfield(zef,'normalize_data')
zef.KF.normalize_data.Value = num2str(zef.normalize_data);
else
zef.KF.normalize_data.Value = 1;
end

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
zef.KF.standardization_exponent.ValueChangedFcn = 'zef.standardization_exponent = str2num(zef.KF.standardization_exponent.Value);';
zef.KF.inv_snr.ValueChangedFcn = 'zef.inv_snr = str2num(zef.KF.inv_snr.Value);';
zef.KF.normalize_data.ValueChangedFcn = 'zef.normalize_data = zef.KF.normalize_data.Value;';
zef.KF.inv_sampling_frequency.ValueChangedFcn = 'zef.inv_sampling_frequency = str2num(zef.KF.inv_sampling_frequency.Value);';
zef.KF.inv_low_cut_frequency.ValueChangedFcn = 'zef.inv_low_cut_frequency = str2num(zef.KF.inv_low_cut_frequency.Value);';
zef.KF.inv_high_cut_frequency.ValueChangedFcn = 'zef.inv_high_cut_frequency = str2num(zef.KF.inv_high_cut_frequency.Value);';
zef.KF.inv_time_1.ValueChangedFcn = 'zef.inv_time_1 = str2num(zef.KF.inv_time_1.Value);';
zef.KF.inv_time_2.ValueChangedFcn = 'zef.inv_time_2 = str2num(zef.KF.inv_time_2.Value);';
zef.KF.number_of_frames.ValueChangedFcn = 'zef.number_of_frames = str2num(zef.KF.number_of_frames.Value);';
zef.KF.inv_time_3.ValueChangedFcn = 'zef.inv_time_3 = str2num(zef.KF.inv_time_3.Value);';
zef.KF.kf_smoothing.ValueChangedFcn = 'zef.kf_smoothing = str2num(zef.KF.kf_smoothing.Value);';
zef.KF.StartButton.ButtonPushedFcn = 'zef = zef_KF(zef);';
zef.KF.ApplyButton.ButtonPushedFcn = 'zef_props = properties(zef.KF); for zef_i = 1:length(zef_props); if isprop(zef.KF.(zef_props{zef_i}),''Value''); zef.(zef_props{zef_i}) = str2num(zef.KF.(zef_props{zef_i}).Value); end; end; clear zef_props zef_i;';
zef.KF.CloseButton.ButtonPushedFcn = 'delete(zef.KF);';
zef.KF.filter_type.ValueChangedFcn = 'zef.filter_type = str2num(zef.KF.filter_type.Value);';

%set fonts
set(findobj(zef.KF.UIFigure.Children,'-property','FontSize'),'FontSize',zef.font_size);
