addpath([pwd filesep 'm']);
zef_make_package(fileparts(mfilename('fullpath')));

zef_data.fid_temp = fopen([fileparts(mfilename('fullpath')) filesep 'm' filesep 'zef_start_config.m'],'w');
fprintf(zef_data.fid_temp, ['warning off;']);
mkdir(fileparts(mfilename('fullpath')),'external');

% Download the external libraries to the folders specified in the .gitmodules
% file.

%!git submodule update --init --recursive

%%% Install SDPT3 BEGIN %%%
eval(['!git clone https://github.com/sqlp/sdpt3 ' fileparts(mfilename('fullpath')) filesep 'external/SDPT3'])
run([fileparts(mfilename('fullpath')) filesep '/external/SDPT3/install_sdpt3.m']);
zef_data.str_temp = 'if isequal(zef.zeffiro_restart, 0), addpath([zef.program_path filesep ''/external/SDPT3/'']); end';
fprintf(zef_data.fid_temp, ['\n' zef_data.str_temp]);
%%% Install SDPT3 END %%%

%%% Install SeDuMi BEGIN %%%
eval(['!git clone https://github.com/sqlp/sedumi ' fileparts(mfilename('fullpath')) filesep 'external/SeDuMi'])
run([fileparts(mfilename('fullpath')) filesep '/external/SeDuMi/install_sedumi.m']);
zef_data.str_temp = 'if isequal(zef.zeffiro_restart, 0), addpath([zef.program_path filesep ''/external/SeDuMi/'']); end';
fprintf(zef_data.fid_temp, ['\n' zef_data.str_temp]);
%%% Install SeDuMi END %%%

%%% Install CVX BEGIN %%%
eval(['!git clone https://github.com/cvxr/CVX ' fileparts(mfilename('fullpath')) filesep 'external/CVX'])
run([fileparts(mfilename('fullpath')) filesep '/external/CVX/cvx_setup.m']);
zef_data.str_temp = 'if isequal(zef.zeffiro_restart, 0), addpath([zef.program_path filesep ''/external/CVX/'']); end';
fprintf(zef_data.fid_temp, ['\n' zef_data.str_temp]);
zef_data.str_temp = 'if isequal(zef.zeffiro_restart, 0), evalc(''cvx_startup''); end';
fprintf(zef_data.fid_temp, ['\n' zef_data.str_temp]);
%%% Install CVX BEGIN %%%

%%% Install FieldTrip BEGIN %%%
eval(['!git clone https://github.com/fieldtrip/fieldtrip ' fileparts(mfilename('fullpath')) filesep 'external/fieldtrip'])
run([fileparts(mfilename('fullpath')) filesep '/external/fieldtrip/ft_defaults.m']);
zef_data.str_temp = 'if isequal(zef.zeffiro_restart, 0), addpath([zef.program_path filesep ''/external/fieldtrip/'']); end';
fprintf(zef_data.fid_temp, ['\n' zef_data.str_temp]);
zef_data.str_temp = 'if isequal(zef.zeffiro_restart, 0), evalc(''ft_defaults''); end';
fprintf(zef_data.fid_temp, ['\n' zef_data.str_temp]);
%%% Install FieldTrip BEGIN %%%

%%% Install SPM12 BEGIN %%%
eval(['!git clone https://github.com/spm/spm12 ' fileparts(mfilename('fullpath')) filesep 'external/spm12'])
run([fileparts(mfilename('fullpath')) filesep '/external/spm12/ft_defaults.m']);
zef_data.str_temp = 'if isequal(zef.zeffiro_restart, 0), addpath([zef.program_path filesep ''/external/spm12/'']); end';
fprintf(zef_data.fid_temp, ['\n' zef_data.str_temp]);
%%% Install SPM12 BEGIN %%%

%%% Install SESAME BEGIN %%%
eval(['!git clone https://github.com/i-am-sorri/SESAME_core ' fileparts(mfilename('fullpath')) filesep 'external/SESAME'])
zef_data.str_temp = 'if isequal(zef.zeffiro_restart, 0), addpath([zef.program_path filesep ''/external/SESAME/'']); end';
%%% Install SESAME END %%%

fprintf(zef_data.fid_temp, '\n warning on;' );

fclose(zef_data.fid_temp);
clear zef_data;

rmpath([pwd filesep 'm']);




