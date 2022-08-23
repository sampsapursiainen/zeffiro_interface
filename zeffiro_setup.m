zef_data.fid_temp = fopen([fileparts(mfilename('fullpath')) filesep 'm' filesep 'zef_start_config.m'],'w');
fprintf(zef_data.fid_temp, ['warning off;']);
mkdir(fileparts(mfilename('fullpath')),'external')

%%% Install SDPT3 BEGIN %%%
eval(['!git clone https://github.com/sqlp/sdpt3 ' fileparts(mfilename('fullpath')) filesep 'external/SDPT3'])
run([fileparts(mfilename('fullpath')) filesep '/external/SDPT3/install_sdpt3.m']);
zef_data.str_temp = 'zef_add_path([zef.program_path filesep ''/external/SDPT3/''],'''',zef.path_cell);';
fprintf(zef_data.fid_temp, ['\n' zef_data.str_temp]);
%%% Install SDPT3 END %%%

%%% Install SeDuMi BEGIN %%%
eval(['!git clone https://github.com/sqlp/sedumi ' fileparts(mfilename('fullpath')) filesep 'external/SeDuMi'])
run([fileparts(mfilename('fullpath')) filesep '/external/SeDuMi/install_sedumi.m']);
zef_data.str_temp = 'zef_add_path([zef.program_path filesep ''/external/SeDuMi/''],'''',zef.path_cell);';
fprintf(zef_data.fid_temp, ['\n' zef_data.str_temp]);
%%% Install SeDuMi END %%%

%%% Install CVX BEGIN %%%
eval(['!git clone https://github.com/cvxr/CVX ' fileparts(mfilename('fullpath')) filesep 'external/CVX'])
run([fileparts(mfilename('fullpath')) filesep '/external/CVX/cvx_setup.m']);
zef_data.str_temp = 'zef_add_path([zef.program_path filesep ''/external/CVX/''],'''',zef.path_cell);';
fprintf(zef_data.fid_temp, ['\n' zef_data.str_temp]);
zef_data.str_temp = 'cvx_startup;';
fprintf(zef_data.fid_temp, ['\n' zef_data.str_temp]);
%%% Install CVX BEGIN %%%

%%% Install SESAME BEGIN %%%
eval(['!git clone https://github.com/i-am-sorri/SESAME_core ' fileparts(mfilename('fullpath')) filesep 'external/SESAME'])
zef_data.str_temp = 'zef_add_path([zef.program_path filesep ''/external/SESAME/''],'''',zef.path_cell);';
%%% Install SESAME END %%%

% %%% Install OSQP BEGIN %%%
% mkdir(fileparts(mfilename('fullpath')),'external/OSQP')
% websave('external/OSQP/install_osqp.m','https://raw.githubusercontent.com/osqp/osqp-matlab/master/package/install_osqp.m');
% run([fileparts(mfilename('fullpath')) filesep '/external/OSQP/install_osqp.m']);
% zef_data.str_temp = 'zef_add_path([zef.program_path filesep ''/external/OSQP/''],''recursive'',zef.path_cell);';
% fprintf(zef_data.fid_temp, ['\n' zef_data.str_temp]);
% %%% Install OSQP BEGIN %%%

fprintf(zef_data.fid_temp, '\n warning on;' );

fclose(zef_data.fid_temp);
clear zef_data;

zef_make_package(mfilename('fullpath'));


