function [time_serie,time_var] = zef_generate_time_sequence
h = waitbar(0,['Generate time sequence.']);

%Sample rate as the number of samples per second
sampling_freq = evalin('base','max(cell2mat(zef.inv_synth_sampling_frequency))');
%The time when peak of pulse occurs
peak_time = evalin('base','zef.inv_pulse_peak_time');
%Amplitude of the pulse between 0 and 1
pulse_amp = evalin('base','zef.inv_pulse_amplitude');
%Length of the Gaussian envelope on seconds
pulse_length = evalin('base','zef.inv_pulse_length');
%Oscillation frequency
oscillation_freq = evalin('base','zef.inv_oscillation_frequency');
%Oscillation phase
oscillation_phase = evalin('base','zef.inv_oscillation_phase');

signal_duration = 0;
for n = 1:length(peak_time)
    signal_duration = max([pulse_length{n}/2+peak_time{n},signal_duration]);
end
time_var = 0:(1/sampling_freq):signal_duration;

time_serie = zeros(length(peak_time),length(time_var));
for n = 1:length(peak_time)
    for j = 1:length(peak_time{n})
        %pulse_points = ceil(pulse_length{n}(j)*sampling_freq);
        start_ind = length(time_var(time_var<=peak_time{n}(j) - pulse_length{n}(j)/2));
        end_ind = length(time_var(time_var<=peak_time{n}(j) + pulse_length{n}(j)/2));
        if start_ind == 0
            start_ind = 1;
        end
        pulse_points=length(start_ind:end_ind);
        time_var_aux = time_var(start_ind:end_ind);
        time_var_aux = time_var_aux(:)';
        blackmanharris_aux = blackmanharris(pulse_points);
        blackmanharris_aux = blackmanharris_aux(:)';
        signal_pulse = pulse_amp{n}(j)*blackmanharris_aux.*cos(2*pi*oscillation_freq{n}(j)*time_var_aux+oscillation_phase{n}(j));
        time_serie(n,start_ind:end_ind) = time_serie(n,start_ind:end_ind) + signal_pulse;
    end
    waitbar(n/size(peak_time,1),h,['Generating time sequence ',num2str(n),' of ',num2str(size(peak_time,1))])
end

close(h);
end
