
addpath(genpath([zef.program_path filesep '/external/SDPT3/']));
addpath(genpath([zef.program_path filesep '/external/CVX/']));
zef_add_path([zef.program_path filesep '/external/SDPT3/'],'recursive',zef.path_cell);
zef_add_path([zef.program_path filesep '/external/CVX/'],'recursive',zef.path_cell);