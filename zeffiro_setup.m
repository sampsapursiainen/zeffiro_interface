%%% Install SDPT3 BEGIN %%%
eval(['!git clone https://github.com/sqlp/sdpt3 ' program_path filesep 'external/SDPT3'])
run([program_path filesep '/external/SDPT3/install_sdpt3.m']);
%%% Install SDPT3 END %%%

%%% Install CVX BEGIN %%%
mkdir(program_path,'external')
eval(['!git clone https://github.com/cvxr/CVX ' program_path filesep 'external/CVX'])
run([program_path filesep '/external/CVX/cvx_setup.m']);
%%% Install CVX BEGIN %%%

%%% Install SESAME BEGIN %%%
eval(['!git clone https://github.com/i-am-sorri/SESAME_core ' program_path filesep 'external/SESAME'])
addpath(genpath([program_path '/external/SESAME']));
%%% Install SESAME END %%%
