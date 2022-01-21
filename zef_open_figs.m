if not(exist('zef'))
    zef = struct;
else
        error('It looks like that another instance of Zeffiro interface already open. To enable this script, clear variable ''zef'' in the base workspace.')
end

zef.program_path = pwd;
addpath(genpath([zef.program_path '/m']));
addpath(genpath([pwd '/data']));
addpath(genpath([pwd '/fig']));
zef_apply_system_settings
zef_init; 
zef.use_display = 0;
zeffiro_interface_figure_tool;
zef.dir_aux = dir([pwd '/fig']); 
zef.h_zeffiro = gobjects(0);
zef.h_zeffiro_window_main = gobjects(0);
for zef_i = 3 : length(zef.dir_aux)
  [~,~,zef.file_ext_aux] = fileparts(zef.dir_aux(zef_i).name);
  if isequal(zef.file_ext_aux,'.fig')
    zef.file = zef.dir_aux(zef_i).name;
    zef.file_path = [pwd '/fig']; 
    zef_import_figure;
  end
end
