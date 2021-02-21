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
zef_remove_object_fields;


zef_data.save_file_path = zef.save_file_path;
zef_data.save_file = zef.save_file;
zef_data.video_codec = zef.video_codec;
zef_data.use_gpu = zef.use_gpu;
zef_data.gpu_num = zef.gpu_num;
zef_data.parallel_vectors = zef.parallel_vectors;
zef_data.snapshot_vertical_resolution = zef.snapshot_vertical_resolution;
zef_data.snapshot_horizontal_resolution = zef.snapshot_horizontal_resolution;
zef_data.movie_fps = zef.movie_fps;
zef_data.font_size = zef.font_size ;
zef_data.mlapp = zef.mlapp;

 zef.fieldnames = fieldnames(zef_data);
 for zef_i = 1:length(zef.fieldnames)
 zef.(zef.fieldnames{zef_i}) = zef_data.(zef.fieldnames{zef_i});
 end        
 clear zef_i;
 zef = rmfield(zef,'fieldnames');
          
 
clear zef_data;
zef_update;
zef_mesh_tool;
end;








