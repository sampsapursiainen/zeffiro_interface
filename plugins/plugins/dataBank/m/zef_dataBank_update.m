function zef = zef_dataBank_update(zef)

if nargin == 0
zef = evalin('base','zef')
end

zef.dataBank.var_starttime = zef.dataBank.app.StarttimeSpinner.Value;
zef.dataBank.var_endtime = zef.dataBank.app.EndtimeSpinner.Value;
zef.dataBank.var_sampling_frequency = zef.dataBank.app.SfreqSpinner.Value;

if nargout == 0
assignin('base','zef',zef);
end

end