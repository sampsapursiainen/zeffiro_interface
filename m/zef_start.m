function zef = zef_start(zef)

if nargin == 0
    zef = evalin('base','zef');
end

zef = zef_apply_system_settings(zef);


if isequal(zef.zeffiro_restart,0)
    
    use_github = zef.use_github;
    if evalin('caller','exist(''use_github'',''var'')')
        use_github = evalin('caller','use_github');
    end
    
if use_github
    !git pull
end

end

zef.ver = ver;
if not(license('test','distrib_computing_toolbox')) || not(any(strcmp(cellstr(char(zef.ver.Name)), 'Parallel Computing Toolbox')))
zef.gpu_count = 0;
else
zef.gpu_count = gpuDeviceCount;
end
zef = rmfield(zef, 'ver');

if ismember(zef.start_mode,{'nodisplay'})
   zef.use_display = 0;
else 
   zef.use_display = 1;
end

if not(zef.use_display)
    addpath(genpath([zef.program_path '/nodisplay']));
end

if zef.gpu_count > 0 & zef.use_gpu == 1
gpuDevice(zef.gpu_num);
end

zef.mlapp = 1;
zef.new_empty_project = 0;

zef_data = struct;

zef_init;

if zef.mlapp == 1
zef_segmentation_tool;
else
zef.h_zeffiro_window_main = open('zef_segmentation_tool.fig');
end
set(findobj(zef.h_zeffiro_window_main.Children,'-property','FontUnits'),'FontUnits','pixels')
set(findobj(zef.h_zeffiro_window_main.Children,'-property','FontSize'),'FontSize',zef.font_size);

zef_figure_tool;
zef_mesh_tool;
zef_mesh_visualization_tool;
zef_menu_tool;
zef = zef_update(zef);

if nargout == 0
    assignin('base','zef',zef);
end

end
