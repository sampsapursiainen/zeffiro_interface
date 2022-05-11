if exist('zeffiro_interface_start_config.m')
zef.fid_temp = fopen('zeffiro_interface_start_config.m','a');
else
zef.fid_temp = fopen('zeffiro_interface_start_config.m','w');
end

%%% Install SDPT3 BEGIN %%%
eval(['!git clone https://github.com/sqlp/sdpt3 ' fileparts(mfilename('fullpath')) filesep 'external/SDPT3'])
run([fileparts(mfilename('fullpath')) filesep '/external/SDPT3/install_sdpt3.m']);
zef.str_temp = 'addpath([zef.program_path filesep ''/external/SDPT3/''];';
fprintf(zef.fid_temp, ['\n' zef.str_temp]);
%%% Install SDPT3 END %%%

%%% Install CVX BEGIN %%%
mkdir(fileparts(mfilename('fullpath')),'external')
eval(['!git clone https://github.com/cvxr/CVX ' fileparts(mfilename('fullpath')) filesep 'external/CVX'])
run([fileparts(mfilename('fullpath')) filesep '/external/CVX/cvx_setup.m']);
zef.str_temp = 'addpath([zef.program_path filesep ''/external/CVX/''];';
fprintf(zef.fid_temp, ['\n' zef.str_temp]);
%%% Install CVX BEGIN %%%

%%% Install SESAME BEGIN %%%
eval(['!git clone https://github.com/i-am-sorri/SESAME_core ' fileparts(mfilename('fullpath')) filesep 'external/SESAME'])
addpath(genpath([fileparts(mfilename('fullpath')) '/external/SESAME']));
%%% Install SESAME END %%%

fclose(zef.fid_temp);

