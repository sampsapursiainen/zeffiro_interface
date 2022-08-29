warning off;
zef_add_path([zef.program_path filesep '/external/SDPT3/'],'',zef.path_cell);
zef_add_path([zef.program_path filesep '/external/SeDuMi/'],'',zef.path_cell);
zef_add_path([zef.program_path filesep '/external/CVX/'],'',zef.path_cell);
cvx_startup;
 warning on;