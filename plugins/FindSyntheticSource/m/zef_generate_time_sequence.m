%Copyright © 2020- Joonas Lahtinen, Sampsa Pursiainen & ZI Development Team
%See: https://github.com/sampsapursiainen/zeffiro_interface
function [time_series,time_var] = zef_generate_time_sequence

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
    signal_duration = max([pulse_length{n}+peak_time{n},signal_duration]);
end
time_var = [0:(1/sampling_freq):signal_duration];

time_series = zeros(length(peak_time),length(time_var));
for n = 1:length(peak_time)
    for j = 1:length(peak_time{n})
        %pulse_points = ceil(pulse_length{n}(j)*sampling_freq);
        start_ind = find(time_var>=peak_time{n}(j) - pulse_length{n}(j)/2,1);
        end_ind = find(time_var>peak_time{n}(j) + pulse_length{n}(j)/2,1)-1;
        if start_ind <= 0
            start_ind = 1;
        end
        pulse_points = end_ind - start_ind + 1;
        bh_aux = blackmanharris(ceil(sampling_freq*pulse_length{n})+1);
        bh_aux = bh_aux(max(end-pulse_points+1,1):end);
        signal_pulse = pulse_amp{n}(j)*bh_aux'.*cos(2*pi*oscillation_freq{n}(j)*time_var(start_ind:end_ind)+oscillation_phase{n}(j));
        time_series(n,start_ind:end_ind) = time_series(n,start_ind:end_ind) + signal_pulse;
    end

end

end