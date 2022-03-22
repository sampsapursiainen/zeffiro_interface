if not(isfield(zef,'inv_hyperprior_tail_length_db'));
    zef.inv_hyperprior_tail_length_db = 10;
end;
if not(isfield(zef,'inv_prior_over_measurement_db'));
    zef.inv_prior_over_measurement_db = 0;
end;

if not(isfield(zef,'inv_snr'));
    zef.inv_snr = 30;
end;

if not(isfield(zef,'inv_hyperprior'));
    zef.inv_hyperprior = 1;
end;

if not(isfield(zef,'inv_amplitude_db'));
    zef.inv_amplitude_db = 20;
end;

if not(isfield(zef,'inv_hyperprior_weight'));
    zef.inv_hyperprior_weight = 1;
end;
