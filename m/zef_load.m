%Copyright © 2018- Sampsa Pursiainen & ZI Development Team
%See: https://github.com/sampsapursiainen/zeffiro_interface
if not(isempty(zef.save_file_path)) & not(zef.save_file_path==0)  
[zef_data.file zef_data.file_path] = uigetfile('*.mat','Open project',zef.save_file_path);
else
[zef_data.file zef_data.file_path] = uigetfile('*.mat','Open project');
end
if not(isequal(zef_data.file,0));
    
zef_close_tools;
zef_close_figs;    
zef_init;
zef.save_file = zef.file; 
zef.save_file_path = zef.file_path;     
load([zef.file_path zef.file]);  
zef_remove_object_fields;

zef_data.matlab_release = version('-release');
zef_data.matlab_release = str2num(zef_data.matlab_release(1:4)) + double(zef_data.matlab_release(5))/128;
zef_data.code_path = zef.code_path;
zef_data.program_path = zef.program_path;

zef.ini_cell = readcell([zef.program_path 'zeffiro_interface.ini'],'FileType','text');
for zef_i = 1 : size(zef.ini_cell,1)
evalin('base',['zef_data.' zef.ini_cell{zef_i,3} ' = zef.' zef.ini_cell{zef_i,3} ';']);
end
zef = rmfield(zef,'ini_cell');

zef_data.mlapp = 1;

 zef.fieldnames = fieldnames(zef_data);
 for zef_i = 1:length(zef.fieldnames)
 zef.(zef.fieldnames{zef_i}) = zef_data.(zef.fieldnames{zef_i});
 end
  if isempty(find(contains(zef.fieldnames,'current_version'),1))
     zef.current_version = 2.2;
  end
 clear zef_i;
 zef = rmfield(zef,'fieldnames');
 
 if zef.current_version <= 2.2 
     for zef_i = 1 : 22
 evalin('base',['zef.d' num2str(zef_i) '_priority =' num2str(28-zef_i) ';']);
     end
 end
          clear zef_i
 
clear zef_data;
zef_reopen_segmentation_tool;
zef_mesh_tool;
zeffiro_interface_mesh_visualization_tool;
zef_close_figs;
zef_update;
zef_set_figure_tool_sliders
end;








