%%% Install SDPT3 BEGIN %%%
eval(['!git clone https://github.com/sqlp/sdpt3 ' fileparts(mfilename('fullpath')) filesep 'external/SDPT3'])
run([fileparts(mfilename('fullpath')) filesep '/external/SDPT3/install_sdpt3.m']);
%%% Install SDPT3 END %%%

%%% Install CVX BEGIN %%%
mkdir(fileparts(mfilename('fullpath')),'external')
eval(['!git clone https://github.com/cvxr/CVX ' fileparts(mfilename('fullpath')) filesep 'external/CVX'])
run([fileparts(mfilename('fullpath')) filesep '/external/CVX/cvx_setup.m']);
%%% Install CVX BEGIN %%%

%%% Install SESAME BEGIN %%%
eval(['!git clone https://github.com/i-am-sorri/SESAME_core ' fileparts(mfilename('fullpath')) filesep 'external/SESAME'])
addpath(genpath([fileparts(mfilename('fullpath')) '/external/SESAME']));
%%% Install SESAME END %%%
