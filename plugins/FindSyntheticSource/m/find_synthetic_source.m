
zef.find_synth_source = find_synthetic_source_app;

zef.synth_source_init = cell(16,2);
%Initial names of the parameters:
zef.synth_source_init{1,1} = 'x position';
zef.synth_source_init{2,1} = 'y position';
zef.synth_source_init{3,1} = 'z position';
zef.synth_source_init{4,1} = 'x orientation';
zef.synth_source_init{5,1} = 'y orientation';
zef.synth_source_init{6,1} = 'z orientation';
zef.synth_source_init{7,1} = 'Amplitude (nAm)';
zef.synth_source_init{8,1} = 'Noise STD w.r.t. amplitude (dB)';
%zef.synth_source_init{8,1} = 'Noise STD w.r.t. amplitude';
zef.synth_source_init{9,1} = 'Sampling frequency (Hz)';
zef.synth_source_init{10,1} = 'Peak Times (s)';
zef.synth_source_init{11,1} = 'Pulse amplitudes';
zef.synth_source_init{12,1} = 'Pulse Length (s)';
zef.synth_source_init{13,1} = 'Oscillation frequency (Hz)';
zef.synth_source_init{14,1} = 'Oscillation phase';
zef.synth_source_init{15,1} = 'Length (visual)';
zef.synth_source_init{16,1} = 'Color (visual)';
%Initial values:
zef.synth_source_init{1,2} = '0';
zef.synth_source_init{2,2} = '0';
zef.synth_source_init{3,2} = '0';
zef.synth_source_init{4,2} = '0';
zef.synth_source_init{5,2} = '0';
zef.synth_source_init{6,2} = '0';
zef.synth_source_init{7,2} = '0';
zef.synth_source_init{8,2} = '-25';
%zef.synth_source_init{8,2} = '0';
zef.synth_source_init{9,2} = '0';
zef.synth_source_init{10,2} = '0';
zef.synth_source_init{11,2} = '0';
zef.synth_source_init{12,2} = '0';
zef.synth_source_init{13,2} = '0';
zef.synth_source_init{14,2} = '0';
zef.synth_source_init{15,2} = '1';
zef.synth_source_init{16,2} = '1';

if isfield(zef,'synth_source_data')
    %Display elements on synth_source_data
    zef.find_synth_source.h_source_list.Data=[];
    if ~iscell(zef.synth_source_data)
       zef_aux_data = zef.synth_source_data;
       zef.synth_source_data = [];
       zef_aux_fields = fields(zef_aux_data);
       for zef_n = 1:length(zef_aux_fields)
          zef.synth_source_data{zef_n} = zef_aux_data.(zef_aux_fields{zef_n});
        end
        clear zef_aux_fields zef_aux_data;
        zef.fss_time_val = [];
    end
    for zef_j = 1:length(zef.synth_source_data)
        zef.find_synth_source.h_source_list.Data{zef_j,1}=zef.synth_source_data{zef_j}.name;
    end
     %If FSS uses Noise STD instead of signal to noise ratio
    for zef_n = 1:length(zef.synth_source_data)
        if strcmp(zef.synth_source_data{zef_n}.parameters{8,1},'Noise STD w.r.t. amplitude')
            zef.synth_source_data{zef_n}.parameters{8,1} = 'Noise STD w.r.t. amplitude (dB)';
            zef.synth_source_data{zef_n}.parameters{8,2} = num2str(db(str2num(zef.synth_source_data{zef_n}.parameters{8,2})));
        end
    end
elseif isfield(zef,'inv_synth_source')
    %Statement that "updates" field construction of zef
    zef_N=size(zef.inv_synth_source,1);
    for zef_n = 1:zef_N
        zef.find_synth_source.h_source_list.Data{end+1,1} = ['Source(',num2str(zef_n),')'];
        zef.synth_source_data{zef_n}.parameters = zef.synth_source_init;
        zef.synth_source_data{zef_n}.name = zef.find_synth_source.h_source_list.Data{end,1};
        for zef_i = 1:7
            zef.synth_source_data{zef_n}.parameters{zef_i,2} = num2str(evalin('base',['zef.inv_synth_source(',num2str(zef_n),',',num2str(zef_i),')']));
        end
        zef.synth_source_data{zef_n}.parameters{8,2} = num2str(evalin('base',['db(zef.inv_synth_source(',num2str(zef_n),',8))']));
        zef.synth_source_data{zef_n}.parameters{15,2} = num2str(evalin('base',['zef.inv_synth_source(',num2str(zef_n),',9)']));
        zef.synth_source_data{zef_n}.parameters{16,2} = num2str(evalin('base',['zef.inv_synth_source(',num2str(zef_n),',10)']));
    end

    zef.find_synth_source.selected_source=1;
    zef.synth_source_updated_true = false;
    zef.fss_time_val = [];
    zef_update_fss;
else
    zef.synth_source_updated_true = false;
    zef.fss_time_val = [];
end
if ~isfield(zef,'fss_bg_noise')
    zef.fss_bg_noise = [];
end
zef.find_synth_source.h_time_val.Value = num2str(zef.fss_time_val);
zef.find_synth_source.h_bg_noise.Value = num2str(zef.fss_bg_noise);

zef.find_synth_source.h_add_source.ButtonPushedFcn = 'zef.synth_source_updated_true = false; add_synthetic_source;';
zef.find_synth_source.h_remove_source.ButtonPushedFcn = 'zef.synth_source_updated_true = false; remove_synthetic_source;';
zef.find_synth_source.h_source_list.DisplayDataChangedFcn = 'zef.synth_source_data{zef.find_synth_source.selected_source}.name = zef.find_synth_source.h_source_list.Data{zef.find_synth_source.selected_source};';
zef.find_synth_source.h_source_parameters.DisplayDataChangedFcn = 'zef.synth_source_updated_true = false; zef.synth_source_data{zef.find_synth_source.selected_source}.parameters=zef.find_synth_source.h_source_parameters.Data; zef.synth_source_init{8,2} = zef.find_synth_source.h_source_parameters.Data{8,2}; zef.synth_source_init{9,2} = zef.find_synth_source.h_source_parameters.Data{9,2}; for zef_j = 1:length(zef.synth_source_data); zef.synth_source_data{zef_j}.parameters{8,2}=zef.synth_source_data{zef.find_synth_source.selected_source}.parameters{8,2}; zef.synth_source_data{zef_j}.parameters{9,2}=zef.synth_source_data{zef.find_synth_source.selected_source}.parameters{9,2}; zef.inv_synth_sampling_frequency = str2num(zef.synth_source_data{zef.find_synth_source.selected_source}.parameters{9,2}); end; clear zef_j;';
zef.find_synth_source.h_time_val.ValueChangedFcn = 'zef.fss_time_val = str2num(zef.find_synth_source.h_time_val.Value);';
zef.find_synth_source.h_generate_time_sequence.ButtonPushedFcn = 'zef_update_fss; [zef.time_sequence,zef.time_variable] = zef_generate_time_sequence;';
zef.find_synth_source.h_create_synth_data.ButtonPushedFcn = 'zef_update_fss; zef.measurements = zef_find_source;';
zef.find_synth_source.h_plot_intensity.ButtonPushedFcn = 'zef_update_fss; zef.find_synth_source.intensity_direction = false; zef_plot_source_intensity;';
zef.find_synth_source.h_plot_time_sequence.ButtonPushedFcn = 'zef_update_fss; zef.find_synth_source.intensity_direction = true; zef_plot_source_intensity;';
zef.find_synth_source.h_plot_sources.ButtonPushedFcn = 'zef_update_fss; zef.h_synth_source = zef_plot_source(1);';
zef.find_synth_source.h_plot_switch.ValueChangedFcn = 'zef.synth_source_updated_true = false;';
zef.find_synth_source.h_bg_noise.ValueChangedFcn = 'zef.fss_bg_noise = str2num(zef.find_synth_source.h_bg_noise.Value);';

set(findobj(zef.find_synth_source.h_find_synth_source.Children,'-property','FontSize'),'FontSize',zef.font_size);

set(zef.find_synth_source.h_find_synth_source,'AutoResizeChildren','off');
zef.find_synth_source_current_size  = get(zef.find_synth_source.h_find_synth_source,'Position');
zef.find_synth_source_relative_size = zef_get_relative_size(zef.find_synth_source.h_find_synth_source);
set(zef.find_synth_source.h_find_synth_source,'SizeChangedFcn', 'zef.find_synth_source_current_size = zef_change_size_function(zef.find_synth_source.h_find_synth_source,zef.find_synth_source_current_size,zef.find_synth_source_relative_size);');

clear zef_i zef_j zef_n zef_N
