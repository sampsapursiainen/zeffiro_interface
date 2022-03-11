if isempty(zef.init_profile)
   zef.init_profile = readcell([zef.program_path '/profile/' zef.profile_name '/zeffiro_init.ini'],'filetype','text','delimiter',',');
end
zef_init_init_profile;
