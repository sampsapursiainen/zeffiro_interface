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
          
clear zef_data;
zef_update;
zef_mesh_tool;
end;








