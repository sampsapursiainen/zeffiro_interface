
if not(exist('zef'))
    zef = [];
end

if isfield(zef,'h_zeffiro_window_main')
    if isvalid(zef.h_zeffiro_window_main)
        error('Another instance of Zeffiro interface already open.')
    end
end
clear zef;
zef.ver = ver;
if not(license('test','distrib_computing_toolbox')) || not(any(strcmp(cellstr(char(zef.ver.Name)), 'Parallel Computing Toolbox')))
gpuDeviceCount = 0;
end
zef = rmfield(zef, 'ver');
zef.program_path = cd; 
if not(isdeployed)
zef.code_path = '/m';
addpath(genpath([zef.program_path '/m']));
addpath(genpath([zef.program_path '/mlapp']));
addpath([zef.program_path '/fig']);  
addpath([zef.program_path zef.code_path]); 
addpath(genpath([zef.program_path '/plugins']));
end;
zef.h_zeffiro = fopen('zeffiro_interface.ini');
zef.ini_cell = textscan(zef.h_zeffiro,'%s');
zef.save_file_path = zef.ini_cell{1}{2};
zef.save_file = zef.ini_cell{1}{4};
zef.video_codec = zef.ini_cell{1}{6};
zef.use_gpu = str2num(zef.ini_cell{1}{8});
zef.gpu_num = str2num(zef.ini_cell{1}{10});
if gpuDeviceCount > 0 & zef.use_gpu == 1
gpuDevice(zef.gpu_num);
end
zef.parallel_vectors = str2num(zef.ini_cell{1}{12});
zef.snapshot_vertical_resolution = str2num(zef.ini_cell{1}{14});
zef.snapshot_horizontal_resolution = str2num(zef.ini_cell{1}{16});
zef.movie_fps = str2num(zef.ini_cell{1}{18});
zef.font_size = str2num(zef.ini_cell{1}{20});
zef.mlapp = str2num(zef.ini_cell{1}{22});
zef = rmfield(zef,'ini_cell');

zef_data = zef;
zef_init;
zef_plugin;

zef.clear_axes1 = 0;






