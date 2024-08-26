function zef = zef_bst_create_project(settings_file_name, project_file_name, zef_bst, zef)

if nargin < 4
    zef = struct;
end

if nargin < 3
    zef_bst = struct;
end

if nargin < 2
project_file_name = '';
end

zef_bst = utilities.brainstorm2zef.m.zef_bst_get_settings(settings_file_name, zef_bst);

subject_struct = bst_get('Subject');
subject_folder = bst_get('ProtocolInfo').SUBJECTS;

if not(isempty(zef_bst.surface_mesh_files))
    for i = 1 : length(zef_bst.surface_mesh_files)
        if not(exist(zef_bst.surface_mesh_files{i},'file'))
          zef_bst.surface_mesh_files{i} = fullfile(subject_folder,zef_bst.surface_mesh_files{i}); 
        end
    end
end

zeffiro_path = fileparts(which('zeffiro_interface'));

if evalin("base","exist('zef', 'var');")
run([zeffiro_path filesep 'm' filesep 'zef_close_all.m']);
end

if isempty(fieldnames(zef))
zef = zeffiro_interface('start_mode','nodisplay','verbose_mode',zef_bst.verbose_mode,'use_gpu',zef_bst.use_gpu,'parallel_processes',zef_bst.parallel_processes,'always_show_waitbar',zef_bst.always_show_waitbar);
end

zef = zef_add_bounding_box(zef);
zef = zef_build_compartment_table(zef);

h_waitbar = zef_waitbar(0,'Creating project.');

mesh_file_ind = 0;
zef_bst.surface_names = cell(0);

if isempty(zef_bst.surface_mesh_files)

    zef_bst.surface_mesh_files = cell(0);
ref_vec_surf = [];
ref_vec_vol = [];
for i = 1 : length(zef_bst.surface_priority)
    aux_ind = subject_struct.(['i' zef_bst.surface_priority{i}]);
if not(isempty(aux_ind))
   mesh_file_ind = mesh_file_ind + 1; 
   zef_bst.surface_mesh_files{mesh_file_ind} = [subject_folder filesep subject_struct.Surface(aux_ind).FileName];
   zef_bst.surface_names{mesh_file_ind} = [subject_struct.Surface(aux_ind).SurfaceType ': ' subject_struct.Surface(aux_ind).Comment];
zef_bst.surface_mesh_types{mesh_file_ind} = zef_bst.surface_priority{i};
if not(isempty(ref_vec_surf))
ref_vec_surf = ref_vec_surf + 1;
end
if not(isempty(ref_vec_vol))
ref_vec_vol = ref_vec_vol + 1;
end
   if ismember(zef_bst.surface_priority{i},zef_bst.refine_surface)
ref_vec_surf = [1 ref_vec_surf]; 
   end
      if ismember(zef_bst.surface_priority{i},zef_bst.refine_volume)
ref_vec_vol = [1 ref_vec_vol]; 
end
end

end

else

    n_surface_meshes = length(zef_bst.surface_mesh_files);
    for i = 1 : n_surface_meshes
[~, file_name_aux] = fileparts(zef_bst.surface_mesh_files{i});
if isempty(zef_bst.surface_mesh_types)
zef_bst.surface_names{i} = file_name_aux;
else
zef_bst.surface_names{i} = [zef_bst.surface_mesh_types{i} ': ' file_name_aux];    
end
    end

    if isempty(zef_bst.surface_mesh_types)
   ref_vec_surf = [1:length(zef_bst.surface_mesh_files) ];
ref_vec_vol = [];
    end
end

n_surface_meshes = length(zef_bst.surface_mesh_files);
for i = 1 : n_surface_meshes
zef_waitbar(i/n_surface_meshes,h_waitbar,'Creating project.');
surface_struct = load(zef_bst.surface_mesh_files{i});
zef = zef_add_compartment(zef);
zef.([zef.compartment_tags{1} '_name']) = zef_bst.surface_names{i};
zef.([zef.compartment_tags{1} '_points']) = zef_bst.unit_conversion*surface_struct.Vertices;
zef.([zef.compartment_tags{1} '_triangles']) = surface_struct.Faces(:,[1 3 2]);
zef.([zef.compartment_tags{1} '_submesh_ind']) = size(surface_struct.Faces,1);
zef = zef_build_compartment_table(zef);
end

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
    zef_close_all(zef)
end

end
