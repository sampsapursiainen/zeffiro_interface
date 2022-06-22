zef_data.fid_temp = fopen([fileparts(mfilename('fullpath')) filesep 'm' filesep 'zeffiro_interface_start_config.m'],'w');
fprintf(zef_data.fid_temp, ['warning off;']);

%%% Install SDPT3 BEGIN %%%
eval(['!git clone https://github.com/sqlp/sdpt3 ' fileparts(mfilename('fullpath')) filesep 'external/SDPT3'])
run([fileparts(mfilename('fullpath')) filesep '/external/SDPT3/install_sdpt3.m']);
zef_data.str_temp = 'zef_add_path([zef.program_path filesep ''/external/SDPT3/''],''recursive'',zef.path_cell);';
fprintf(zef_data.fid_temp, ['\n' zef_data.str_temp]);
%%% Install SDPT3 END %%%

%%% Install CVX BEGIN %%%
mkdir(fileparts(mfilename('fullpath')),'external')
eval(['!git clone https://github.com/cvxr/CVX ' fileparts(mfilename('fullpath')) filesep 'external/CVX'])
run([fileparts(mfilename('fullpath')) filesep '/external/CVX/cvx_setup.m']);
zef_data.str_temp = 'zef_add_path([zef.program_path filesep ''/external/CVX/''],''recursive'',zef.path_cell);';
fprintf(zef_data.fid_temp, ['\n' zef_data.str_temp]);
%%% Install CVX BEGIN %%%

%%% Install SESAME BEGIN %%%
eval(['!git clone https://github.com/i-am-sorri/SESAME_core ' fileparts(mfilename('fullpath')) filesep 'external/SESAME'])
zef_data.str_temp = 'zef_add_path([zef.program_path filesep ''/external/SESAME/''],''recursive'',zef.path_cell);';
%%% Install SESAME END %%%

fprintf(zef_data.fid_temp, '\n warning on;' );

fclose(zef_data.fid_temp);
clear zef_data;


