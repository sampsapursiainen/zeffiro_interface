function out_cell = zef_bst_default_fem_mesh_create(run_type,input_mode,settings_file_name,project_file_name,zef_bst)

if nargin < 4
    zef_bst = struct;
end

if isequal(run_type,0)
out_cell = cell(0);
out_cell{1} = [];
out_cell{2} = [];
out_cell{3} = [];
return;
end

zef_bst = utilities.brainstorm2zef.m.zef_bst_get_settings(settings_file_name,zef_bst);

if ismember(run_type,[1 2])
zef = zeffiro_interface('start_mode','nodisplay','verbose_mode',zef_bst.verbose_mode,'use_gpu',zef_bst.use_gpu,'parallel_processes',zef_bst.parallel_processes,'always_show_waitbar',zef_bst.always_show_waitbar);
zef = utilities.brainstorm2zef.m.zef_bst_create_project(settings_file_name,[],run_type,input_mode,zef_bst,zef);
elseif isequal(run_type,3)
zef = zeffiro_interface('start_mode','nodisplay','verbose_mode',zef_bst.verbose_mode,'use_gpu',zef_bst.use_gpu,'parallel_processes',zef_bst.parallel_processes,'always_show_waitbar',zef_bst.always_show_waitbar);
end

zef = zef_create_finite_element_mesh(zef);

if zef_bst.save_project
    [file_path, file_name] = fileparts(project_file_name);
    zef_save(zef, file_name, file_path, 1);
end

out_cell{1} = zef.nodes/zef_bst.unit_conversion;
out_cell{2} = [zef.tetra zef.domain_labels];
out_cell{3} = zef.name_tags(1:end-1);

zef_close_all(zef);

end