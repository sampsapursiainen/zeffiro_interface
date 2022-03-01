%Copyright © 2018- Sampsa Pursiainen & ZI Development Team
%See: https://github.com/sampsapursiainen/zeffiro_interface

zef_data = struct;

if zef.use_display
if not(isempty(zef.save_file_path)) && not(isequal(zef.save_file_path,0))
[zef.file, zef.file_path] = uigetfile('*.mat','Open project',zef.save_file_path);
else
[zef.file, zef.file_path] = uigetfile('*.mat','Open project');
end
end
if not(isequal(zef.file,0))

zef_close_tools;
zef_close_figs;
zef_init;
load([zef.file_path zef.file]);
zef_data.save_file = zef.file;
zef_data.save_file_path = zef.file_path;
zef_remove_object_fields;
zef_remove_system_fields;

zef_data.matlab_release = version('-release');
zef_data.matlab_release = str2num(zef_data.matlab_release(1:4)) + double(zef_data.matlab_release(5))/128;
zef_data.code_path = zef.code_path;
zef_data.program_path = zef.program_path;

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

 zef_apply_system_settings;

 zef.save_file = zef_data.save_file;
 zef.save_file_path = zef_data.save_file_path;
 if isfield(zef_data,'profile_name')
 zef.profile_name = zef_data.profile_name;
 end

 zef_replace_project_fields;

 zef_init_init_profile;
 zef_init_parameter_profile;

if ismember(zef.start_mode,{'nodisplay','display'})
zef.use_display = 0;
end

clear zef_data;
zef_reopen_segmentation_tool;
zef_mesh_tool;
zeffiro_interface_mesh_visualization_tool;
zef_close_figs;
zef_update;
zef_set_figure_tool_sliders

zef_plugin;

end;

