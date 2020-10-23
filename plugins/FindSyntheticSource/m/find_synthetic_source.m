%Copyright © 2020- Joonas Lahtinen, Sampsa Pursiainen & ZI Development Team
%See: https://github.com/sampsapursiainen/zeffiro_interface
%This script initialize the find_synthethic_source_app. 

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
zef.synth_source_init{8,1} = 'Noise STD w.r.t. amplitude';
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
zef.synth_source_init{8,2} = '0';
zef.synth_source_init{9,2} = '0';
zef.synth_source_init{10,2} = '0';
zef.synth_source_init{11,2} = '0';
zef.synth_source_init{12,2} = '0';
zef.synth_source_init{13,2} = '0';
zef.synth_source_init{14,2} = '0';
zef.synth_source_init{15,2} = '1';
zef.synth_source_init{16,2} = '1';

if isfield(zef,'synth_source_data')
    %Display elements on synt_source_data
    zef.fss_aux_fields = fields(zef.synth_source_data);
    zef.find_synth_source.h_source_list.Items(1)=[];
    for zef_j = 1:length(zef.fss_aux_fields)
        zef.find_synth_source.h_source_list.Items{zef_j}=zef.synth_source_data.(zef.fss_aux_fields{zef_j}).name;
    end
    zef.find_synth_source.h_source_list.Items = flip(zef.find_synth_source.h_source_list.Items);
    zef.find_synth_source.h_source_list.Value = zef.find_synth_source.h_source_list.Items{1};
    zef.active_source = erase(zef.find_synth_source.h_source_list.Value,{'(',')'});
    zef.find_synth_source.h_source_parameters.Data=zef.synth_source_data.(zef.active_source).parameters;
    zef = rmfield(zef,'fss_aux_fields');
elseif isfield(zef,'inv_synth_source')
    %Statement that "updates" field construction of zef
    zef_N=size(zef.inv_synth_source,1);
    for zef_n = 1:zef_N
        zef.fss_aux_fields = ['Source',num2str(zef_n)];
        zef.find_synth_source.h_source_list.Items{end+1} = ['Source(',num2str(zef_n),')']; 
        zef.synth_source_data.(zef.fss_aux_fields).parameters = zef.synth_source_init;
        zef.synth_source_data.(zef.fss_aux_fields).name = zef.find_synth_source.h_source_list.Items{end};
        for zef_i = 1:8
            zef.synth_source_data.(zef.fss_aux_fields).parameters{zef_i,2} = num2str(evalin('base',['zef.inv_synth_source(',num2str(zef_n),',',num2str(zef_i),')']));
        end
        zef.synth_source_data.(zef.fss_aux_fields).parameters{15,2} = num2str(evalin('base',['zef.inv_synth_source(',num2str(zef_n),',9)']));
        zef.synth_source_data.(zef.fss_aux_fields).parameters{16,2} = num2str(evalin('base',['zef.inv_synth_source(',num2str(zef_n),',10)']));
    end
    zef.find_synth_source.h_source_list.Items = flip(zef.find_synth_source.h_source_list.Items);
    zef.find_synth_source.h_source_list.Value=zef.find_synth_source.h_source_list.Items{1};
    zef.find_synth_source.h_source_parameters.Data=zef.synth_source_data.(zef.fss_aux_fields).parameters;
    zef.active_source=zef.fss_aux_fields;
    zef.synth_source_updated_true = false;
    zef.fss_time_val = [];
    zef_update_fss;
    zef = rmfield(zef,'fss_aux_fields');
else
    zef.synth_source_updated_true = false;
    zef.fss_time_val = [];
end
    
zef.find_synth_source.h_add_source.ButtonPushedFcn = 'zef.synth_source_updated_true = false; add_synthetic_source;';
zef.find_synth_source.h_remove_source.ButtonPushedFcn = 'zef.synth_source_updated_true = false; remove_synthetic_source;';
zef.find_synth_source.h_source_list.ValueChangedFcn = 'zef.active_source = get(zef.find_synth_source.h_source_list,''value''); zef.active_source=erase(zef.active_source,{''('','')''}); zef.find_synth_source.h_source_parameters.Data=zef.synth_source_data.(zef.active_source).parameters;';
zef.find_synth_source.h_source_parameters.DisplayDataChangedFcn = 'zef.synth_source_updated_true = false; zef.synth_source_data.(zef.active_source).parameters=zef.find_synth_source.h_source_parameters.Data; temp_fields = fields(zef.synth_source_data); for zef_j = 1:length(temp_fields);  zef.synth_source_data.(temp_fields{zef_j}).parameters{9,2}=zef.synth_source_data.(zef.active_source).parameters{9,2}; end; clear zef_j temp_fields;';
zef.find_synth_source.h_time_val.ValueChangedFcn = 'zef.fss_time_val = str2num(zef.find_synth_source.h_time_val.Value);';
zef.find_synth_source.h_generate_time_sequence.ButtonPushedFcn = 'zef_update_fss; [zef.time_sequence,zef.time_variable] = zef_generate_time_sequence;';
zef.find_synth_source.h_create_synth_data.ButtonPushedFcn = 'zef_update_fss; zef.measurements = zef_find_source;';
zef.find_synth_source.h_plot_sources.ButtonPushedFcn = 'zef_update_fss; zef.h_synth_source = zef_plot_source(1);';

clear zef_i zef_j zef_n zef_N