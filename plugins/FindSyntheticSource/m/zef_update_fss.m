%Copyright © 2018- Sampsa Pursiainen & ZI Development Team
%See: https://github.com/sampsapursiainen/zeffiro_interface
if ~zef.synth_source_updated_true
if str2num(evalin('base','zef.find_synth_source.h_plot_switch.Value')) == 1
selected_source_ind = evalin('base','zef.find_synth_source.selected_source');
zef.inv_synth_source = zeros(length(selected_source_ind),10);
zef.inv_synth_sampling_frequency = cell(length(selected_source_ind),1);
zef.inv_pulse_peak_time = cell(length(selected_source_ind),1);
zef.inv_pulse_amplitude = cell(length(selected_source_ind),1);
zef.inv_pulse_length = cell(length(selected_source_ind),1);
zef.inv_oscillation_frequency = cell(length(selected_source_ind),1);
zef.inv_oscillation_phase = cell(length(selected_source_ind),1);

for zef_j = 1:length(selected_source_ind)
    zef_n = selected_source_ind(zef_j);
    zef.inv_synth_source(zef_j,1) = str2num(zef.synth_source_data{zef_n}.parameters{1,2});
    zef.inv_synth_source(zef_j,2) = str2num(zef.synth_source_data{zef_n}.parameters{2,2});
    zef.inv_synth_source(zef_j,3) = str2num(zef.synth_source_data{zef_n}.parameters{3,2});
    zef.inv_synth_source(zef_j,4) = str2num(zef.synth_source_data{zef_n}.parameters{4,2});
    zef.inv_synth_source(zef_j,5) = str2num(zef.synth_source_data{zef_n}.parameters{5,2});
    zef.inv_synth_source(zef_j,6) = str2num(zef.synth_source_data{zef_n}.parameters{6,2});
    zef.inv_synth_source(zef_j,7) = str2num(zef.synth_source_data{zef_n}.parameters{7,2});
    zef.inv_synth_source(zef_j,8) = str2num(zef.synth_source_data{zef_n}.parameters{8,2});

    zef.inv_synth_source(zef_j,9) = str2num(zef.synth_source_data{zef_n}.parameters{15,2});
    zef.inv_synth_source(zef_j,10) = str2num(zef.synth_source_data{zef_n}.parameters{16,2});

    zef.inv_synth_sampling_frequency{zef_j} = str2num(zef.synth_source_data{zef_n}.parameters{9,2});
    zef.inv_pulse_peak_time{zef_j} = str2num(zef.synth_source_data{zef_n}.parameters{10,2});
    zef.inv_pulse_amplitude{zef_j} = str2num(zef.synth_source_data{zef_n}.parameters{11,2});
    zef.inv_pulse_length{zef_j} = str2num(zef.synth_source_data{zef_n}.parameters{12,2});
    zef.inv_oscillation_frequency{zef_j} = str2num(zef.synth_source_data{zef_n}.parameters{13,2});
    zef.inv_oscillation_phase{zef_j} = str2num(zef.synth_source_data{zef_n}.parameters{14,2});
end
clear zef_j selected_source_ind;

else
zef.inv_synth_source = zeros(length(zef.synth_source_data),10);
zef.inv_synth_sampling_frequency = cell(length(zef.synth_source_data),1);
zef.inv_pulse_peak_time = cell(length(zef.synth_source_data),1);
zef.inv_pulse_amplitude = cell(length(zef.synth_source_data),1);
zef.inv_pulse_length = cell(length(zef.synth_source_data),1);
zef.inv_oscillation_frequency = cell(length(zef.synth_source_data),1);
zef.inv_oscillation_phase = cell(length(zef.synth_source_data),1);

for zef_n = 1:length(zef.synth_source_data)
    zef.inv_synth_source(zef_n,1) = str2num(zef.synth_source_data{zef_n}.parameters{1,2});
    zef.inv_synth_source(zef_n,2) = str2num(zef.synth_source_data{zef_n}.parameters{2,2});
    zef.inv_synth_source(zef_n,3) = str2num(zef.synth_source_data{zef_n}.parameters{3,2});
    zef.inv_synth_source(zef_n,4) = str2num(zef.synth_source_data{zef_n}.parameters{4,2});
    zef.inv_synth_source(zef_n,5) = str2num(zef.synth_source_data{zef_n}.parameters{5,2});
    zef.inv_synth_source(zef_n,6) = str2num(zef.synth_source_data{zef_n}.parameters{6,2});
    zef.inv_synth_source(zef_n,7) = str2num(zef.synth_source_data{zef_n}.parameters{7,2});
    zef.inv_synth_source(zef_n,8) = str2num(zef.synth_source_data{zef_n}.parameters{8,2});

    zef.inv_synth_source(zef_n,9) = str2num(zef.synth_source_data{zef_n}.parameters{15,2});
    zef.inv_synth_source(zef_n,10) = str2num(zef.synth_source_data{zef_n}.parameters{16,2});

    zef.inv_synth_sampling_frequency{zef_n} = str2num(zef.synth_source_data{zef_n}.parameters{9,2});
    zef.inv_pulse_peak_time{zef_n} = str2num(zef.synth_source_data{zef_n}.parameters{10,2});
    zef.inv_pulse_amplitude{zef_n} = str2num(zef.synth_source_data{zef_n}.parameters{11,2});
    zef.inv_pulse_length{zef_n} = str2num(zef.synth_source_data{zef_n}.parameters{12,2});
    zef.inv_oscillation_frequency{zef_n} = str2num(zef.synth_source_data{zef_n}.parameters{13,2});
    zef.inv_oscillation_phase{zef_n} = str2num(zef.synth_source_data{zef_n}.parameters{14,2});
end
zef.synth_source_updated_true = true;
end
end
clear zef_n;
