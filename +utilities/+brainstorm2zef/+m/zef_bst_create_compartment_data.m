function [compartment_settings, surface_meshes, zef] = zef_bst_create_compartment_data(settings_file_name, zef_bst, zef)

mesh_file_ind = 0;
compartment_types = cell(0);
A = diag(4);

if isfield(zef_bst,'subject_struct')
    if length(fieldnames(zef_bst.subject_struct)) > 0
        subject_struct = zef_bst.subject_struct;
    else
        subject_struct = bst_get('Subject');
    end
else
    subject_struct = bst_get('Subject');
end

if isfield(zef_bst,'subject_folder')
    if not(isempty(char(zef_bst.subject_folder)))
        subject_folder = zef_bst.subject_folder;
    else
        subject_folder = bst_get('ProtocolInfo').SUBJECTS;
    end
else
    subject_folder = bst_get('ProtocolInfo').SUBJECTS;
end

if isempty(zef_bst.compartment_files)

    aux_type = '';

    zef_bst.compartment_files = cell(0);
    for i = 1 : length(zef_bst.compartment_list)
        if (isfield(subject_struct,['i' zef_bst.compartment_list{i}]))
            aux_ind = subject_struct.(['i' zef_bst.compartment_list{i}]);
            aux_type = 'Surface';
        else
            aux_ind = find(ismember({subject_struct.Surface.Comment},zef_bst.compartment_list{i}),1);
            aux_type = 'Surface';

            if isempty(aux_ind)
                aux_ind = find(ismember({subject_struct.Anatomy.Comment},zef_bst.compartment_list{i}),1);
                aux_type = 'Anatomy';
            end
        end

        if not(isempty(aux_ind))
            mesh_file_ind = mesh_file_ind + 1;
            if isequal(aux_type,'Surface')
                zef_bst.compartment_files{mesh_file_ind} = [subject_folder filesep subject_struct.Surface(aux_ind).FileName];
            elseif isequal(aux_type,'Anatomy')
                zef_bst.compartment_files{mesh_file_ind} = [subject_folder filesep subject_struct.Anatomy(aux_ind).FileName];
            end

        end
    end

else
    for i = 1 : length(zef_bst.compartment_files)
        if not(exist(zef_bst.compartment_files{i},'file'))
            zef_bst.compartment_files{i} = fullfile(subject_folder,zef_bst.compartment_files{i});
        end
    end
end

n_surface_meshes = length(zef_bst.compartment_files);
compartment_types = cell(1,n_surface_meshes);
surface_mesh_type = '';
for i = 1 : n_surface_meshes
    surface_mesh_type = load(zef_bst.compartment_files{i},'Comment');
    surface_mesh_type = surface_mesh_type.Comment;
    if not(ismember(surface_mesh_type,zef_bst.compartment_list))
        [subject_struct, ~, surface_index] = bst_get('SurfaceFile', zef_bst.compartment_files{i});
        surface_mesh_type = subject_struct.Surface(surface_index).SurfaceType;
    end
    compartment_types{i} = surface_mesh_type;
end

surface_mesh_order = zeros(n_surface_meshes,1);
surface_counter = 0;
for i = 1 : length(zef_bst.compartment_list)
    I = find(ismember(compartment_types,zef_bst.compartment_list{i}));
    n_found = length(I);
    surface_mesh_order(I) = [1:n_found]' + surface_counter;
    surface_counter = surface_counter + n_found;
end

zef_bst.compartment_files = zef_bst.compartment_files(surface_mesh_order);
compartment_types = compartment_types(surface_mesh_order);

surface_meshes = struct;
for i = 1 : n_surface_meshes

    compartment_struct = load(zef_bst.compartment_files{i});

    if isfield(compartment_struct, 'Vertices')
        surface_meshes(i).Name = compartment_types{i};
        surface_meshes(i).Type = compartment_types{i};
        surface_meshes(i).Color = [];
        surface_meshes(i).Points = zef_bst.unit_conversion*compartment_struct.Vertices;
        surface_meshes(i).Triangles = compartment_struct.Faces;
    end

    if isfield(compartment_struct,'Cube')
        if not(isempty(compartment_struct.InitTransf))
            A = compartment_struct.InitTransf{2};
        else
            compartment_struct.InitTransf{2} = A;
        end
        surface_meshes_aux = utilities.brainstorm2zef.m.zef_bst_get_atlas_surfaces(zef,compartment_struct,zef_bst.n_inflation_steps,zef_bst.transform_cell,compartment_types{i});
        if length(fieldnames(surface_meshes)) > 0
            surface_meshes = [surface_meshes surface_meshes_aux];
        else
            surface_meshes = surface_meshes_aux;
        end
    end

end

compartment_settings = utilities.brainstorm2zef.m.zef_bst_compartment_settings(zef_bst,surface_meshes);

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
end
