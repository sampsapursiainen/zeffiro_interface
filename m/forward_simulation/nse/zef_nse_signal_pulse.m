function y = zef_nse_signal_pulse(t,nse_field,n_oversampling)

if nse_field.pulse_mode == 1
   pulse_function = @(n) blackmanharris(n)';
end

if nargin < 3
n_oversampling = 256;
end

t_aux = [0:n_oversampling*(nse_field.cycle_length/nse_field.time_step_length)];
d_t_aux = nse_field.cycle_length/t_aux(end);
t_aux = d_t_aux*t_aux;
t = t - nse_field.cycle_length*floor(t/nse_field.cycle_length);
t_ind = floor(t/d_t_aux) + 1;

y_aux = zeros(size(t_aux));
p_wave = nse_field.p_wave_weight*pulse_function(ceil(nse_field.p_wave_length*(length(t_aux)-1)));
ind_aux = floor(nse_field.p_wave_start*(length(t_aux)-1))+1;
y_aux(ind_aux:ind_aux + length(p_wave)-1) = p_wave;

t_wave = nse_field.t_wave_weight*pulse_function(ceil(nse_field.t_wave_length*(length(t_aux)-1)));
ind_aux = floor(nse_field.t_wave_start*(length(t_aux)-1))+1;
y_aux(ind_aux:ind_aux + length(t_wave)-1) = y_aux(ind_aux:ind_aux + length(t_wave)-1) + t_wave;

d_wave = nse_field.d_wave_weight*pulse_function(ceil(nse_field.d_wave_length*(length(t_aux)-1)));
ind_aux = floor(nse_field.d_wave_start*(length(t_aux)-1))+1;
y_aux(ind_aux:ind_aux + length(d_wave)-1) = y_aux(ind_aux:ind_aux + length(d_wave)-1) + d_wave;

y = y_aux(t_ind);
y = y./max(abs(y));

y = y*(nse_field.systolic_pressure - nse_field.diastolic_pressure) + nse_field.diastolic_pressure;

end