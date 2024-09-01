function zef = zef_bst_create_project(settings_file_name, project_file_name, run_type, input_mode, zef_bst, zef)

if nargin < 6
    zef = struct;
end

if nargin < 5
    zef_bst = struct;
end

if nargin < 4
input_mode = 1;
end

if nargin < 3
run_type = 1;
end

if nargin < 2
project_file_name = '';
end

zef_bst = utilities.brainstorm2zef.m.zef_bst_get_settings(settings_file_name, zef_bst);

zeffiro_path = fileparts(which('zeffiro_interface'));

if evalin("base","exist('zef', 'var');")
run([zeffiro_path filesep 'm' filesep 'zef_close_all.m']);
end

if isempty(fieldnames(zef))
zef = zeffiro_interface('start_mode','nodisplay','verbose_mode',zef_bst.verbose_mode,'use_gpu',zef_bst.use_gpu,'parallel_processes',zef_bst.parallel_processes,'always_show_waitbar',zef_bst.always_show_waitbar);
end

zef = zef_add_bounding_box(zef);
zef = zef_build_compartment_table(zef);

h_waitbar = zef_waitbar(0, 'Creating project.');

zef_bst = utilities.brainstorm2zef.m.zef_bst_get_settings(settings_file_name, zef_bst);
if isequal(input_mode,2)
    zef_bst.compartment_files = cell(0);
end

[aux_path, aux_file] = fileparts(settings_file_name);
if isequal(run_type,1)
[compartment_settings, surface_meshes, zef] = utilities.brainstorm2zef.m.zef_bst_create_compartment_data(settings_file_name, zef_bst, zef);
writecell(compartment_settings, fullfile(aux_path,[aux_file '_compartment_settings.dat']));
save(fullfile(aux_path,[aux_file '_surface_meshes.mat']),'surface_meshes','-v7.3');
else
compartment_settings = readcell(fullfile(aux_path,[aux_file '_compartment_settings.dat']));  
load(fullfile(aux_path,[aux_file '_surface_meshes.mat']));
end

n_surface_meshes = size(compartment_settings,1);
ind_vec_aux = zeros(n_surface_meshes,1);
for i = 1 : n_surface_meshes
if size(surface_meshes(i).Points,1) >= 4
ind_vec_aux(i) = 1; 
end
end
ind_vec_aux = find(ind_vec_aux);
surface_meshes = surface_meshes(ind_vec_aux);
compartment_settings = compartment_settings(ind_vec_aux,:);

n_surface_meshes = size(compartment_settings,1);

ref_vec_vol = flipud(cell2mat(compartment_settings(:,8)));
ref_vec_surf = flipud(cell2mat(compartment_settings(:,6)));

ind_vec_aux = zeros(n_surface_meshes,1);
h_waitbar = zef_waitbar(0, 'Creating project.');
for i = 1 : n_surface_meshes
zef_waitbar(i/n_surface_meshes,h_waitbar,'Creating project.');
surface_names_aux = {surface_meshes.Name};
i_aux = find(ismember(surface_names_aux,compartment_settings{i,2}),1);
if not(isempty(i_aux))
    ind_vec_aux(i) = 1;
zef = zef_add_compartment(zef);
zef.([zef.compartment_tags{1} '_name']) = compartment_settings{i,2};
zef.([zef.compartment_tags{1} '_points']) = surface_meshes(i_aux).Points;
zef.([zef.compartment_tags{1} '_triangles']) = surface_meshes(i_aux).Triangles(:,[1 3 2]);
zef.([zef.compartment_tags{1} '_submesh_ind']) = size(surface_meshes(i_aux).Triangles,1);
zef.([zef.compartment_tags{1} '_sigma']) = compartment_settings{i,10};
zef.([zef.compartment_tags{1} '_activity']) = compartment_settings{i,12};
if not(isempty(surface_meshes(i_aux).Color))
zef.([zef.compartment_tags{1} '_color']) = surface_meshes(i_aux).Color;
end
zef = zef_build_compartment_table(zef);
end
end

ind_vec_aux = find(ind_vec_aux);
ref_vec_vol = find(ref_vec_vol(ind_vec_aux));
ref_vec_surf = find(ref_vec_surf(ind_vec_aux));

ref_vec_vol = find(ref_vec_vol);
ref_vec_surf = find(ref_vec_surf);

zef.refinement_on = 1;
zef.mesh_smoothing_on = zef_bst.mesh_smoothing_on;
zef.distance_smoothing_on = zef_bst.distance_smoothing_on;
zef.refinement_surface_on = zef_bst.refine_surface_on;
zef.refinement_volume_on = zef_bst.refine_volume_on;
zef.refinement_surface_number = zef_bst.refine_surface_number;
zef.refinement_volume_number = zef_bst.refine_volume_number;
zef.refinement_surface_mode = zef_bst.refine_surface_mode;
zef.refinement_surface_compartments = ref_vec_surf;
zef.refinement_volume_compartments = ref_vec_vol;
zef.mesh_resolution = zef_bst.mesh_resolution;
zef.use_fem_mesh_inflation = zef_bst.inflation_on;
zef.fem_mesh_inflation_strength = zef_bst.inflation_strength;
zef.max_surface_face_count = zef_bst.surface_mesh_density;

run(zef_bst.import_settings);

if not(isempty(zef_bst.labeling_priority))
zef = zef_update_labeling_priority(zef,[],zef_bst.labeling_priority);
end

if not(isempty(char(project_file_name)))
    [file_path, file_name] = fileparts(project_file_name);
    zef.save_file = [file_name '.mat'];
    zef.save_file_path = file_path;
    zef_save(zef, zef.save_file, zef.save_file_path,1);
    zef_close_all(zef);
end

end
