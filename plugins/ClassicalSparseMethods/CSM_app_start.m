%This is the startup script for CSM app. One must add this as launch
%script to zeffiro_plugins file:
%Beamformer, inverse_tools, zef_CSM_start

zef.CSM = CSM_app;

%_ Names of methods that are included in app _
zef_csm_names = {'dSPM',
                 'sLORETA',
                 'Sparse Bayesian Learning'
                };

zef.CSM.csm_type.Items = zef_csm_names;
zef.CSM.csm_type.ItemsData = strsplit(num2str(1:length(zef_csm_names)));
zef.CSM.csm_type.Value = '1';
if ~isfield(zef,'csm_type')
    zef.csm_type = 1;
end

clear zef_csm_names

%_ Initial values _
zef.CSM_csm_n_iter.Value = '10';
zef.CSM.inv_sampling_frequency.Value = '1025';
zef.CSM.inv_low_cut_frequency.Value = '7';
zef.CSM.inv_high_cut_frequency.Value = '9';
zef.CSM.inv_time_1.Value = '0';
zef.CSM.inv_time_2.Value = '0';
zef.CSM.number_of_frames.Value = '0';
zef.CSM.inv_time_3.Value = '0';
zef.CSM.inv_data_segment.Value = '1';

if ~isfield(zef,'cms_n_iter')
    zef.csm_n_iter = 10;
end

%set parameters if saved in ZI:
%(Naming concept: zef.CSM."field" = zef."field")
zef_props = properties(zef.CSM);
for zef_i = 1:length(zef_props)
    if isfield(zef,zef_props{zef_i})
        zef.CSM.(zef_props{zef_i}).Value = num2str(zef.(zef_props{zef_i}));
    end
end
clear zef_props zef_i

if zef.csm_type == 1 || zef.csm_type == 2
    zef.CSM.csm_n_iter.Enable = 'off';
else
    zef.CSM.csm_n_iter.Enable = 'on';
end

%_ Functions _
zef.CSM.csm_type.ValueChangedFcn = 'zef.csm_type = str2num(zef.CSM.csm_type.Value); if zef.csm_type == 1 || zef.csm_type == 2; zef.CSM.csm_n_iter.Enable = ''off''; else zef.CSM.csm_n_iter.Enable = ''on''; end;';
zef.CSM_csm_n_iter.ValueChangedFcn = 'zef.csm_n_iter = str2num(zef.CSM.csm_n_iter.Value);';
zef.CSM.inv_sampling_frequency.ValueChangedFcn = 'zef.inv_sampling_frequency = str2num(zef.CSM.inv_sampling_frequency.Value);';
zef.CSM.inv_low_cut_frequency.ValueChangedFcn = 'zef.inv_low_cut_frequency = str2num(zef.CSM.inv_low_cut_frequency.Value);';
zef.CSM.inv_high_cut_frequency.ValueChangedFcn = 'zef.inv_high_cut_frequency = str2num(zef.CSM.inv_high_cut_frequency.Value);';
zef.CSM.inv_time_1.ValueChangedFcn = 'zef.inv_time_1 = str2num(zef.CSM.inv_time_1.Value);';
zef.CSM.inv_time_2.ValueChangedFcn = 'zef.inv_time_2 = str2num(zef.CSM.inv_time_2.Value);';
zef.CSM.number_of_frames.ValueChangedFcn = 'zef.number_of_frames = str2num(zef.CSM.number_of_frames.Value);';
zef.CSM.inv_time_3.ValueChangedFcn = 'zef.inv_time_3 = str2num(zef.CSM.inv_time_3.Value);';
zef.CSM.inv_data_segment.ValueChangedFcn = 'zef.inv_data_segment = str2num(zef.CSM.inv_data_segment.Value);';
zef.CSM.normalize_data.ValueChangedFcn = 'zef.normalize_data = str2num(zef.CSM.normalize_data.Value);';
zef.CSM.StartButton.ButtonPushedFcn = '[zef.reconstruction,zef.reconstruction_information]=zef_CSM_iteration;';
zef.CSM.CloseButton.ButtonPushedFcn = 'delete(zef.CSM);';

%set fonts
set(findobj(zef.CSM.UIFigure.Children,'-property','FontSize'),'FontSize',zef.font_size);
