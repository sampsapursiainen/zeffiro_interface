function zef = zef_import_segmentation(zef, file_name, folder_name)

if nargin == 0
    zef = evalin('base','zef');
end

domain_label_counter = 0;
atlas_on = 0;
if nargin < 3
    if zef.use_display
        [file_name, folder_name] = uigetfile({'*.zef;*.mat'},'Segmentation data file and folder',eval('zef.save_file_path'));
    else
        file_name = eval('zef.file');
        folder_name = eval('zef.file_path');
    end
end

if not(isequal(file_name,0))

    [~,~,extension] = fileparts(file_name);
    if isequal(extension,'.mat')
        zef = zef_import_mat_struct(zef,fullfile(folder_name,file_name));

    else

        h = zef_waitbar(0,1,'Importing.');

        ini_cell_ind = [];
        ini_cell = readcell(fullfile(folder_name,file_name),'FileType','Text','NumHeaderLines',0,'Delimiter',',');
        ini_cell_original = ini_cell;
        for i = 1 : size(ini_cell,1)
            for j = 1 : size(ini_cell,2)
                if ismissing(ini_cell{i,j})
                    ini_cell{i,j} = 'missing_cell_entry';
                end
                if not(ischar(ini_cell{i,j}))
                    ini_cell{i,j} = num2str(ini_cell{i,j});
                end
            end
        end
        compartment_tags = zef.compartment_tags;
        sensor_tags = zef.sensor_tags;

        for i = 1 : size(ini_cell,1)

            compartment_data = zef.h_compartment_table.Data;
            sensors_data = zef.h_sensors_table.Data;

            zef_waitbar(i,size(ini_cell,1),h,['Importing ' num2str(i) '/' num2str(size(ini_cell,1)) '.']);
            ini_cell_ind = [ini_cell_ind find(ismember(ini_cell(i,:),'type'),1)];
            ini_cell_ind = [ini_cell_ind ini_cell_ind(end)+1];
            type = (ini_cell{i,find(ismember(ini_cell(i,:),'type'),1)+1});
            ini_cell_ind = [ini_cell_ind find(ismember(ini_cell(i,:),'name'),1)];
            ini_cell_ind = [ini_cell_ind ini_cell_ind(end)+1];
            name = '';
            filetype = '';
            filename = '';
            foldername = '';
            if ismember('name',ini_cell(i,:))
                name = (ini_cell{i,find(ismember(ini_cell(i,:),'name'),1)+1});
            end

            new_compartment = 0;
            if isequal(type,'box')
                if isempty(name)
                    zef = zef_add_bounding_box(zef);
                else
                    zef = zef_add_bounding_box(zef,name);
                end
            elseif isequal(type,'segmentation')
                if not(isempty(compartment_data))
                    if ismember(name,compartment_data(:,3))
                        compartment_ind = find(ismember(compartment_data(:,3),name));
                        compartment_tag = compartment_tags{end-compartment_ind+1};
                    else
                        new_compartment = 1;
                        domain_label_counter = domain_label_counter + 1;
                        zef = zef_add_compartment(zef);
                        compartment_tags = zef.compartment_tags;
                        compartment_tag = compartment_tags{1};
                    end
                else
                    domain_label_counter = domain_label_counter + 1;
                    zef = zef_add_compartment(zef);
                    compartment_tags = zef.compartment_tags;
                    compartment_tag = compartment_tags{1};
                end

                if ismember('filename',ini_cell(i,:))
                    ini_cell_ind = [ini_cell_ind find(ismember(ini_cell(i,:),'filename'),1)];
                    ini_cell_ind = [ini_cell_ind ini_cell_ind(end)+1];
                    filename = (ini_cell{i,find(ismember(ini_cell(i,:),'filename'),1)+1});
                end
                if ismember('foldername',ini_cell(i,:))
                    ini_cell_ind = [ini_cell_ind find(ismember(ini_cell(i,:),'foldername'),1)];
                    ini_cell_ind = [ini_cell_ind ini_cell_ind(end)+1];
                    foldername = (ini_cell{i,find(ismember(ini_cell(i,:),'foldername'),1)+1});
                end
                if not(isempty(foldername))
                    filename = [foldername filesep filename];
                end
                if ismember('filetype',ini_cell(i,:))
                    ini_cell_ind = [ini_cell_ind find(ismember(ini_cell(i,:),'filetype'),1)];
                    ini_cell_ind = [ini_cell_ind ini_cell_ind(end)+1];
                    filetype = (ini_cell{i,find(ismember(ini_cell(i,:),'filetype'),1)+1});
                elseif not(isempty(filename))
                    [~,~,filetype]=fileparts(filename);
                    if not(isempty(filetype))
                        filetype = filetype(2:end);
                    end
                end
                if find(ismember(ini_cell(i,:),'merge'))
                    ini_cell_ind = [ini_cell_ind find(ismember(ini_cell(i,:),'merge'),1)];
                    ini_cell_ind = [ini_cell_ind ini_cell_ind(end)+1];
                    merge = (ini_cell{i,find(ismember(ini_cell(i,:),'merge'),1)+1});
                else
                    merge = '0';
                end
                if find(ismember(ini_cell(i,:),'affine_transform'))
                    ini_cell_ind = [ini_cell_ind find(ismember(ini_cell(i,:),'affine_transform'),1)];
                    ini_cell_ind = [ini_cell_ind ini_cell_ind(end)+1];
                    affine_transform = ini_cell{i,find(ismember(ini_cell(i,:),'affine_transform'),1)+1};
                else
                    affine_transform = mat2str(eye(4));
                end
                if find(ismember(ini_cell(i,:),'invert'))
                    ini_cell_ind = [ini_cell_ind find(ismember(ini_cell(i,:),'invert'),1)];
                    ini_cell_ind = [ini_cell_ind ini_cell_ind(end)+1];
                    invert = (ini_cell{i,find(ismember(ini_cell(i,:),'invert'),1)+1});
                    if isa(invert,'numeric')
                    invert = num2str(invert);
                    end
                else
                    invert = '0';
                end
                if find(ismember(ini_cell(i,:),'scaling'))
                    ini_cell_ind = [ini_cell_ind find(ismember(ini_cell(i,:),'scaling'),1)];
                    ini_cell_ind = [ini_cell_ind ini_cell_ind(end)+1];
                    scaling = (ini_cell{i,find(ismember(ini_cell(i,:),'scaling'),1)+1});
                else
                    scaling = '1';
                end
                if find(ismember(ini_cell(i,:),'activity'))
                    ini_cell_ind = [ini_cell_ind find(ismember(ini_cell(i,:),'activity'),1)];
                    ini_cell_ind = [ini_cell_ind ini_cell_ind(end)+1];
                    activity = (ini_cell{i,find(ismember(ini_cell(i,:),'activity'),1)+1});
                else
                    activity = '0';
                end
                if find(ismember(ini_cell(i,:),'on'))
                    ini_cell_ind = [ini_cell_ind find(ismember(ini_cell(i,:),'on'),1)];
                    ini_cell_ind = [ini_cell_ind ini_cell_ind(end)+1];
                    on = (ini_cell{i,find(ismember(ini_cell(i,:),'on'),1)+1});
                else
                    on = '1';
                end
                if find(ismember(ini_cell(i,:),'visible'))
                    ini_cell_ind = [ini_cell_ind find(ismember(ini_cell(i,:),'visible'),1)];
                    ini_cell_ind = [ini_cell_ind ini_cell_ind(end)+1];
                    visible = (ini_cell{i,find(ismember(ini_cell(i,:),'visible'),1)+1});
                else
                    visible = '1';
                end
                if find(ismember(ini_cell(i,:),'color'))
                    ini_cell_ind = [ini_cell_ind find(ismember(ini_cell(i,:),'color'),1)];
                    ini_cell_ind = [ini_cell_ind ini_cell_ind(end)+1];
                    color_vec = (ini_cell{i,find(ismember(ini_cell(i,:),'color'),1)+1});
                else
                    color_vec = [];
                end
                if find(ismember(ini_cell(i,:),'labeling_priority'))
                    ini_cell_ind = [ini_cell_ind find(ismember(ini_cell(i,:),'labeling_priority'),1)];
                    ini_cell_ind = [ini_cell_ind ini_cell_ind(end)+1];
                    labeling_priority = (ini_cell{i,find(ismember(ini_cell(i,:),'labeling_priority'),1)+1});
                else
                    labeling_priority = '';
                end
                if find(ismember(ini_cell(i,:),'subject'))
                    ini_cell_ind = [ini_cell_ind find(ismember(ini_cell(i,:),'subject'),1)];
                    ini_cell_ind = [ini_cell_ind ini_cell_ind(end)+1];
                    subject = str2num(ini_cell{i,find(ismember(ini_cell(i,:),'subject'),1)+1});
                else
                    subject = 1;
                end
                if find(ismember(ini_cell(i,:),'database'))
                    ini_cell_ind = [ini_cell_ind find(ismember(ini_cell(i,:),'database'),1)];
                    ini_cell_ind = [ini_cell_ind ini_cell_ind(end)+1];
                    database = (ini_cell{i,find(ismember(ini_cell(i,:),'database'),1)+1});
                else
                    database = '';
                end
                if find(ismember(ini_cell(i,:),'inflate'))
                    ini_cell_ind = [ini_cell_ind find(ismember(ini_cell(i,:),'inflate'),1)];
                    ini_cell_ind = [ini_cell_ind ini_cell_ind(end)+1];
                    n_inflation_steps = str2num(ini_cell{i,find(ismember(ini_cell(i,:),'inflate'),1)+1});
                   inflate_surface = 1; 
                else 
                    inflate_surface = 0;
                end
                if find(ismember(ini_cell(i,:),'tag'))
                    ini_cell_ind = [ini_cell_ind find(ismember(ini_cell(i,:),'tag'),1)];
                    ini_cell_ind = [ini_cell_ind ini_cell_ind(end)+1];
                    tag = (ini_cell{i,find(ismember(ini_cell(i,:),'tag'),1)+1});
                else
                    tag = name;
                end
                if find(ismember(ini_cell(i,:),'parameter_name'))
                    ini_cell_ind = [ini_cell_ind find(ismember(ini_cell(i,:),'parameter_name'),1)];
                    ini_cell_ind = [ini_cell_ind ini_cell_ind(end)+1];
                    parameter_name = (ini_cell{i,find(ismember(ini_cell(i,:),'parameter_name'),1)+1});
                else
                    parameter_name = '';
                end
                if find(ismember(ini_cell(i,:),'parameter_value'))
                    ini_cell_ind = [ini_cell_ind find(ismember(ini_cell(i,:),'parameter_value'),1)];
                    ini_cell_ind = [ini_cell_ind ini_cell_ind(end)+1];
                    parameter_value = (ini_cell{i,find(ismember(ini_cell(i,:),'parameter_value'),1)+1});
                else
                    parameter_value = '';
                end
                if find(ismember(ini_cell(i,:),'atlas'))
                    ini_cell_ind = [ini_cell_ind find(ismember(ini_cell(i,:),'atlas'),1)];
                    ini_cell_ind = [ini_cell_ind ini_cell_ind(end)+1];
                    atlas = (ini_cell{i,find(ismember(ini_cell(i,:),'atlas'),1)+1});
                else
                    atlas = '';
                end
                if find(ismember(ini_cell(i,:),'atlas_compartment'))
                    ini_cell_ind = [ini_cell_ind find(ismember(ini_cell(i,:),'atlas_compartment'),1)];
                    ini_cell_ind = [ini_cell_ind ini_cell_ind(end)+1];
                    atlas_compartment = ini_cell{i,find(ismember(ini_cell(i,:),'atlas_compartment'),1)+1};
                else
                    atlas_compartment = '';
                end
                if find(ismember(ini_cell(i,:),'atlas_tag'))
                    ini_cell_ind = [ini_cell_ind find(ismember(ini_cell(i,:),'atlas_tag'),1)];
                    ini_cell_ind = [ini_cell_ind ini_cell_ind(end)+1];
                    atlas_tag = (ini_cell{i,find(ismember(ini_cell(i,:),'atlas_tag'),1)+1});
                else
                    atlas_tag = [];
                end
                if find(ismember(ini_cell(i,:),'atlas_on'))
                    ini_cell_ind = [ini_cell_ind find(ismember(ini_cell(i,:),'atlas_on'),1)];
                    ini_cell_ind = [ini_cell_ind ini_cell_ind(end)+1];
                    atlas_on = str2num(ini_cell{i,find(ismember(ini_cell(i,:),'atlas_on'),1)+1});
                else
                    atlas_on = 0;
                end

                if find(ismember(ini_cell(i,:),'atlas_colortable_filename'))
                    ini_cell_ind = [ini_cell_ind find(ismember(ini_cell(i,:),'atlas_colortable_filename'),1)];
                    ini_cell_ind = [ini_cell_ind ini_cell_ind(end)+1];
                    atlas_colortable_filename = (ini_cell{i,find(ismember(ini_cell(i,:),'atlas_colortable_filename'),1)+1});
                else
                    atlas_colortable_filename = '';
                end
                if not(isempty(foldername))
                    atlas_colortable_filename = [foldername filesep atlas_colortable_filename];
                end

                if find(ismember(ini_cell(i,:),'atlas_points_filename'))
                    ini_cell_ind = [ini_cell_ind find(ismember(ini_cell(i,:),'atlas_points_filename'),1)];
                    ini_cell_ind = [ini_cell_ind ini_cell_ind(end)+1];
                    atlas_points_filename = (ini_cell{i,find(ismember(ini_cell(i,:),'atlas_points_filename'),1)+1});
                else
                    atlas_points_filename = '';
                end
                if not(isempty(foldername))
                    atlas_points_filename = [foldername filesep atlas_points_filename];
                end

                if find(ismember(ini_cell(i,:),'atlas_merge'))
                    ini_cell_ind = [ini_cell_ind find(ismember(ini_cell(i,:),'atlas_merge'),1)];
                    ini_cell_ind = [ini_cell_ind ini_cell_ind(end)+1];
                    atlas_merge = str2num(ini_cell{i,find(ismember(ini_cell(i,:),'atlas_merge'),1)+1});
                else
                    atlas_merge = 1;
                end

                aux_ind = 0;
                while not(isempty(aux_ind))
                    aux_set = setdiff([1:length(ini_cell(i,:))],ini_cell_ind);
                    [~, aux_ind] = min(aux_set);
                    aux_ind = aux_set(aux_ind);
                    if not(isempty(aux_ind))
                        if not(isequal(ini_cell{i,aux_ind},'missing_cell_entry'))
                            if ischar(ini_cell_original{i,aux_ind+1})
                                eval(['zef.' compartment_tag '_' ini_cell{i,aux_ind} ' = ''' ini_cell{i,aux_ind+1} ''';']);
                            else
                                eval(['zef.' compartment_tag '_' ini_cell{i,aux_ind} ' = ' ini_cell{i,aux_ind+1} ';']);
                            end
                        end
                        ini_cell_ind = [ini_cell_ind aux_ind aux_ind+1];
                    end
                end

                %eval(['zef.compartments_selected = ' num2str(compartment_ind) ';']);
                eval(['zef.current_compartment = ''' compartment_tag ''';']);
                eval(['zef.' compartment_tag '_merge = ' merge ';']);
                eval(['zef.' compartment_tag '_invert = ' invert ';']);
                if not(isempty(parameter_name))
                    eval(['zef.' compartment_tag '_' parameter_name ' = ' parameter_value ';']);
                end
                if not(isempty(atlas_colortable_filename))
                    zef = zef_import_parcellation_colortable(zef,atlas_colortable_filename,compartment_tag,atlas_merge);
                end
                if not(isempty(atlas_points_filename))
                    zef = zef_import_parcellation_points(zef,atlas_points_filename,atlas_merge);
                end
                eval(['zef.' compartment_tag '_name = ''' name ''';']);
                eval(['zef.' compartment_tag '_affine_transform = {' affine_transform '};']);
                eval(['zef.' compartment_tag '_scaling = ' scaling ';']);
                eval(['zef.' compartment_tag '_sources = ' activity ';']);
                eval(['zef.' compartment_tag '_on = ' on  ';']);
                eval(['zef.' compartment_tag '_visible = ' visible ';']);
                if not(isempty(color_vec))
                eval(['zef.' compartment_tag '_color = ' color_vec ';']);       
                end
                if not(isempty(labeling_priority))
               zef.([compartment_tag '_labeling_priority']) =  str2num(labeling_priority);
                end
                zef.surface_mesh_type = filetype;
                zef.file = filename;
                zef.file_path = folder_name;

                if atlas_on
                    parcellation_compartment = zef.parcellation_compartment;
                    if isequal(parcellation_compartment,{'g'})
                        parcellation_compartment = cell(0);
                    end
                    parcellation_compartment = [parcellation_compartment {compartment_tag}];
                    atlas_on = 0;
                end

                if not(isempty(filename))
                    if not(ismember(filetype,{'mat',''}))
                        [aux_points,aux_triangles,aux_submesh_ind] = zef_get_mesh(zef,filename, compartment_tag, filetype,'full');
                        if inflate_surface 
                        if length(aux_submesh_ind) < 2    
                        [aux_points] = zef_inflate_surface(zef,aux_points, aux_triangles,n_inflation_steps);
                        elseif length(aux_submesh_ind) >= 2 
                           [aux_points] = zef_inflate_surface(zef,aux_points, aux_triangles(aux_submesh_ind(end-1)+1:aux_submesh_ind(end),:),n_inflation_steps);
                        end
                        end
                        eval(['zef.' compartment_tag '_points = aux_points;']); 
                        eval(['zef.' compartment_tag '_triangles = aux_triangles;']); 
                        eval(['zef.' compartment_tag '_submesh_ind = aux_submesh_ind;']); 
                      % zef = zef_merge_surface_mesh(zef,compartment_tag,aux_triangles,aux_points,merge);
                    elseif isequal(filetype,'mat')
                        zef = zef_import_mat_struct(zef, filename,[compartment_tag '_']);
                    end
                end

                if isempty(filename) && isempty(database)
                   if new_compartment
                   aux_tetra = zef.tetra;
                    aux_nodes = zef.nodes;
                   aux_domain_labels = zef.domain_labels;
                    [aux_triangles, aux_points] = zef_surface_mesh(aux_tetra(find(aux_domain_labels<=max(aux_domain_labels)-domain_label_counter+1),:),aux_nodes);
                    zef = zef_merge_surface_mesh(zef,compartment_tag,aux_triangles,aux_points,merge);
                   end
                end

                if isequal(lower(database),'bst') || isequal(lower(database),'brainstorm')
                    [~,~,~,surface_struct_aux] = zef_bst_2_zef_surface(subject);
                    n_surfaces = length(surface_struct_aux);
                    surface_found = 0 ;
                    surface_ind_aux = 0;
                    while surface_ind_aux < n_surfaces && not(surface_found)
                        surface_ind_aux = surface_ind_aux + 1;
                        [~, ~, surface_name_aux] = zef_bst_2_zef_surface(subject,surface_ind_aux,'Comment');
                        if isequal(lower(surface_name_aux),lower(tag))
                            surface_found = 1;
                            [vertices_aux, faces_aux] = zef_bst_2_zef_surface(subject,surface_ind_aux);
                            if str2num(invert)
                            faces_aux = faces_aux(:,[1 3 2]);
                            end
                            zef = zef_merge_surface_mesh(zef,compartment_tag,faces_aux,vertices_aux,merge);
                            if not(isempty(atlas))
                                if isempty(atlas_tag)
                                    atlas_tag = atlas;
                                end

                                [p_c_table_new, p_points_new] = zef_bst_2_zef_atlas(subject, surface_ind_aux, atlas_compartment, atlas, atlas_tag, 1000);
                                if not(isempty(p_c_table_new))
                                    p_c_table = zef.parcellation_colortable;
                                    p_c_table{length(p_c_table)+1} = p_c_table_new;
                                    p_points = zef.parcellation_points;
                                    p_points{length(p_points)+1} = p_points_new;
                                    zef.parcellation_colortable = p_c_table;
                                    zef.parcellation_points = p_points;
                                end
                            end
                        end
                    end
                end

                %assignin('base','zef_data',zef_data);
                %eval('zef_assign_data;');
                %clear zef_data;

                %    eval('zef_init_parameter_profile;');
                zef = zef_apply_parameter_profile(zef);
                zef = zef_build_compartment_table(zef);

            elseif isequal(type,'sensors')

                name = (ini_cell{i,find(ismember(ini_cell(i,:),'name'),1)+1});
                if not(isempty(sensors_data))
                    if ismember(name,sensors_data(:,2))
                        sensors_ind = find(ismember(sensors_data(:,2),name));
                        sensor_tag = sensor_tags{end-sensors_ind+1};
                    else
                        zef_add_sensors;
                        sensor_tags = zef.sensor_tags;
                        sensor_tag = sensor_tags{1};
                    end
                else
                    zef_add_sensors;
                    sensor_tags = zef.sensor_tags;
                    sensor_tag = sensor_tags{1};
                end

                filename = '';
                if ismember('filename',ini_cell(i,:))
                    ini_cell_ind = [ini_cell_ind find(ismember(ini_cell(i,:),'filename'),1)];
                    ini_cell_ind = [ini_cell_ind ini_cell_ind(end)+1];
                    filename = (ini_cell{i,find(ismember(ini_cell(i,:),'filename'),1)+1});
                end
                foldername = '';
                if ismember('foldername',ini_cell(i,:))
                    ini_cell_ind = [ini_cell_ind find(ismember(ini_cell(i,:),'foldername'),1)];
                    ini_cell_ind = [ini_cell_ind ini_cell_ind(end)+1];
                    foldername = (ini_cell{i,find(ismember(ini_cell(i,:),'foldername'),1)+1});
                end
                if not(isempty(foldername))
                    filename = [foldername filesep filename];
                end
                if ismember('filetype',ini_cell(i,:))
                    ini_cell_ind = [ini_cell_ind find(ismember(ini_cell(i,:),'filetype'),1)];
                    ini_cell_ind = [ini_cell_ind ini_cell_ind(end)+1];
                    filetype = (ini_cell{i,find(ismember(ini_cell(i,:),'filetype'),1)+1});
                elseif not(isempty(filename))
                    [~,~,filetype]=fileparts(filename);
                    if not(isempty(filetype))
                        filetype = filetype(2:end);
                    end
                end
                if find(ismember(ini_cell(i,:),'modality'))
                    ini_cell_ind = [ini_cell_ind find(ismember(ini_cell(i,:),'modality'),1)];
                    ini_cell_ind = [ini_cell_ind ini_cell_ind(end)+1];
                    modality = (ini_cell{i,find(ismember(ini_cell(i,:),'modality'),1)+1});
                else
                    modality = zef.imaging_method_cell{1};
                end
                if find(ismember(ini_cell(i,:),'on'))
                    ini_cell_ind = [ini_cell_ind find(ismember(ini_cell(i,:),'on'),1)];
                    ini_cell_ind = [ini_cell_ind ini_cell_ind(end)+1];
                    on = (ini_cell{i,find(ismember(ini_cell(i,:),'on'),1)+1});
                else
                    on = '1';
                end
                if find(ismember(ini_cell(i,:),'visible'))
                    ini_cell_ind = [ini_cell_ind find(ismember(ini_cell(i,:),'visible'),1)];
                    ini_cell_ind = [ini_cell_ind ini_cell_ind(end)+1];
                    visible = (ini_cell{i,find(ismember(ini_cell(i,:),'visible'),1)+1});
                else
                    visible = '1';
                end
                if find(ismember(ini_cell(i,:),'affine_transform'))
                    ini_cell_ind = [ini_cell_ind find(ismember(ini_cell(i,:),'affine_transform'),1)];
                    ini_cell_ind = [ini_cell_ind ini_cell_ind(end)+1];
                    affine_transform = ini_cell{i,find(ismember(ini_cell(i,:),'affine_transform'),1)+1};
                else
                    affine_transform = mat2str(eye(4));
                end

                 if find(ismember(ini_cell(i,:),'scaling'))
                    ini_cell_ind = [ini_cell_ind find(ismember(ini_cell(i,:),'scaling'),1)];
                    ini_cell_ind = [ini_cell_ind ini_cell_ind(end)+1];
                    scaling = ini_cell{i,find(ismember(ini_cell(i,:),'scaling'),1)+1};
                else
                    scaling = '1';
                end

                if find(ismember(ini_cell(i,:),'tag'))
                    ini_cell_ind = [ini_cell_ind find(ismember(ini_cell(i,:),'tag'),1)];
                    ini_cell_ind = [ini_cell_ind ini_cell_ind(end)+1];
                    tag = (ini_cell{i,find(ismember(ini_cell(i,:),'tag'),1)+1});
                else
                    tag = [];
                end

                if find(ismember(ini_cell(i,:),'database'))
                    ini_cell_ind = [ini_cell_ind find(ismember(ini_cell(i,:),'database'),1)];
                    ini_cell_ind = [ini_cell_ind ini_cell_ind(end)+1];
                    database = (ini_cell{i,find(ismember(ini_cell(i,:),'database'),1)+1});
                else
                    database = 'none';
                end

                if find(ismember(ini_cell(i,:),'sensor_taglist_filename'))
                    ini_cell_ind = [ini_cell_ind find(ismember(ini_cell(i,:),'sensor_taglist_filename'),1)];
                    ini_cell_ind = [ini_cell_ind ini_cell_ind(end)+1];
                    sensor_taglist_filename = (ini_cell{i,find(ismember(ini_cell(i,:),'sensor_taglist_filename'),1)+1});
                    sensor_taglist_filename = fullfile(foldername, sensor_taglist_filename);
                    sensor_taglist_cell = readcell(sensor_taglist_filename)';
                else
                    sensor_taglist_cell = [];
                end

                %eval(['zef_data.sensora_selected = ' num2str(sensors_ind) ';']);
                eval(['zef.current_sensors = ''' sensor_tag  ''';']);
                eval(['zef.' sensor_tag '_name = ''' name ''';']);
                eval(['zef.' sensor_tag '_on = ' on  ';']);
                eval(['zef.' sensor_tag '_visible = ' visible ';']);
                eval(['zef.' sensor_tag '_scaling = ' scaling ';']);
                eval(['zef.' sensor_tag '_affine_transform = {' affine_transform '};']);
                eval(['zef.' sensor_tag '_imaging_method_name = ''' modality ''';']);
                eval(['zef.' sensor_tag '_name_list = sensor_taglist_cell ;']);
                zef.file = filename;
                if not(isempty(foldername))
                zef.file_path = foldername;
                end
                %         assignin('base','zef',zef_data);
                %         eval('zef_assign_data;');
                %         clear zef_data;

                if not(isempty(filename))
                    if isequal(filetype,'points')
                        aux_field = zef_get_mesh(zef,filename,sensor_tag,'points');
                        eval(['zef.' sensor_tag '_points = aux_field;']);
                    end
                    if isequal(filetype,'directions')
                        aux_field = zef_get_mesh(zef,filename,sensor_tag,'triangles');
                        eval(['zef.' sensor_tag '_directions = aux_field;']);
                    end
                    if isequal(filetype,'mat')
                        zef = zef_import_mat_struct(zef, filename,[sensor_tag '_']);
                    end
                end

                if isequal(lower(database),'bst') || isequal(lower(database),'brainstorm')

                    [sensor_positions, sensor_orientations, sensor_ind, sensor_tag_cell] = zef_bst_2_zef_sensors(tag);
                    if isequal(modality,'EEG')
                        eval(['zef.' sensor_tag '_points = sensor_positions;']);
                    end


                end

                % eval('zef_init_sensors_parameter_profile;');
                eval('zef = zef_apply_parameter_profile(zef);');
                eval('zef_build_sensors_table;');

            elseif isequal(type,'struct')
                filename = '';
                if ismember('filename',ini_cell(i,:))
                    ini_cell_ind = [ini_cell_ind find(ismember(ini_cell(i,:),'filename'),1)];
                    ini_cell_ind = [ini_cell_ind ini_cell_ind(end)+1];
                    filename = (ini_cell{i,find(ismember(ini_cell(i,:),'filename'),1)+1});
                    if ismember('foldername',ini_cell(i,:))
                        ini_cell_ind = [ini_cell_ind find(ismember(ini_cell(i,:),'foldername'),1)];
                        ini_cell_ind = [ini_cell_ind ini_cell_ind(end)+1];
                        foldername = (ini_cell{i,find(ismember(ini_cell(i,:),'foldername'),1)+1});
                    end
                    if not(isempty(foldername))
                        filename = [foldername filesep filename];
                    end
                    zef = zef_import_mat_struct(zef,filename);
                end

            elseif isequal(type,'script')
                filename = '';
                if ismember('filename',ini_cell(i,:))
                    ini_cell_ind = [ini_cell_ind find(ismember(ini_cell(i,:),'filename'),1)];
                    ini_cell_ind = [ini_cell_ind ini_cell_ind(end)+1];
                    filename = (ini_cell{i,find(ismember(ini_cell(i,:),'filename'),1)+1});
                    if ismember('foldername',ini_cell(i,:))
                        ini_cell_ind = [ini_cell_ind find(ismember(ini_cell(i,:),'foldername'),1)];
                        ini_cell_ind = [ini_cell_ind ini_cell_ind(end)+1];
                        foldername = (ini_cell{i,find(ismember(ini_cell(i,:),'foldername'),1)+1});
                    end
                    if not(isempty(foldername))
                        filename = [foldername filesep filename];
                    end
                    eval(['evalc(''' filename  ''');']);
                end

            end



        end

        %zef_data
        %assignin('base','zef_data',zef_data);
        %       eval('zef_assign_data;');

        delete(h);

    end
end

if nargout == 0
    assignin('base','zef',zef);
end

end
