function zef = zef_apply_parameter_profile(zef)

if nargin == 0
    zef = evalin('base','zef');
end

zef.parameter_profile = eval('readcell([zef.program_path ''/profile/'' zef.profile_name ''/zeffiro_parameters.ini''],''FileType'',''text'',''delimiter'','','');');

zef_init_parameter_profile;

if nargout == 0
    assignin('base','zef',zef);
end

end