%Copyright © 2018- Sampsa Pursiainen & ZI Development Team
%See: https://github.com/sampsapursiainen/zeffiro_interface
if not(isempty(zef.save_file_path)) & not(zef.save_file_path==0)  
[zef_data.file zef_data.file_path] = uigetfile('*.mat','Open project',zef.save_file_path);
else
[zef_data.file zef_data.file_path] = uigetfile('*.mat','Open project');
end
if not(isequal(zef_data.file,0));
    
zef_init;
zef.save_file = zef.file; 
zef.save_file_path = zef.file_path;     
zef_close_tools;
zef_close_figs;
load([zef.file_path zef.file]);

 zef.fieldnames = fieldnames(zef_data);
 for zef_i = 1:length(zef.fieldnames)
 zef.(zef.fieldnames{zef_i}) = zef_data.(zef.fieldnames{zef_i});
 end        
 clear zef_i;
 zef = rmfield(zef,'fieldnames');
          
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
 
clear zef_data;
zef_update;
zef_mesh_tool;
end;








