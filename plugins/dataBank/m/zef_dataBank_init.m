if not(isfield(zef.dataBank,'var_starttime'))
zef.dataBank.var_starttime = 0;
end

if not(isfield(zef.dataBank,'var_endtime'))
zef.dataBank.var_endtime = 0;
end

if not(isfield(zef.dataBank,'var_sampling_frequency'))
zef.dataBank.var_sampling_frequency = zef.inv_sampling_frequency;
end

zef.dataBank.app.StarttimeSpinner.Value = zef.dataBank.var_starttime;
zef.dataBank.app.EndtimeSpinner.Value = zef.dataBank.var_endtime;
zef.dataBank.app.SfreqSpinner.Value = zef.dataBank.var_sampling_frequency;

