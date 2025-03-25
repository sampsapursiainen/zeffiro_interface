%Copyright © 2018- Sampsa Pursiainen & ZI Development Team
%See: https://github.com/sampsapursiainen/zeffiro_interface
function zef = zef_load(zef,file_name,path_name)

if nargin == 0
    zef = evalin('base','zef');
end

zef_data = struct;

if nargin < 3
    if not(isempty(zef.save_file_path)) && not(isequal(zef.save_file_path,0))
        [file_name, path_name] = uigetfile('*.mat','Open project',zef.save_file_path);
    else
        [file_name, path_name] = uigetfile('*.mat','Open project');
    end
end
if not(isequal(file_name,0))
    zef_start_new_project;

    zef_data.save_file = file_name;
    zef_data.save_file_path = path_name;

    matfile_whos = whos('-file',[path_name filesep file_name]);
    matfile_fieldnames = {matfile_whos.name}';
    I_mf = [1:length(matfile_fieldnames)];

    if isequal(length(matfile_fieldnames),1)
        load([path_name filesep file_name]);
        save([path_name filesep file_name],'-struct','zef_data','-v7.3');
        matfile_whos = whos('-file',[path_name filesep file_name]);
        matfile_fieldnames = {matfile_whos.name}';
        I_mf = [1:length(matfile_fieldnames)];
    end

    if ismember('zeffiro_variable_data',matfile_fieldnames)
        aux_struct = load([path_name filesep file_name],'zeffiro_variable_data');
        zeffiro_variable_data = aux_struct.('zeffiro_variable_data');
        if not(isempty(zeffiro_variable_data))
            [matfile_fieldnames, I_mf] = setdiff(matfile_fieldnames,zeffiro_variable_data(:,2));
        end
    end

    h_waitbar = zef_waitbar(0,1,'Loading fields.');
    n_fields = length(matfile_fieldnames);
    if zef.use_display
        figure(h_waitbar);
    end
    
    field_sizes = cell2mat({matfile_whos(I_mf).bytes});
    I_fs = find(field_sizes <= 1e8);
    matfile_fieldnames_aux = matfile_fieldnames(I_fs);
    matfile_fieldnames = setdiff(matfile_fieldnames, matfile_fieldnames_aux);
    n_fields_2 = length(I_fs);
    zef_data_aux = eval(['load(''' fullfile(path_name,file_name) ''',' strjoin(strcat('"',matfile_fieldnames_aux,'"'),',')  ');']);
    fieldnames_zef_data_aux = fieldnames(zef_data_aux);
    for i = 1 : n_fields_2
        zef_data.(fieldnames_zef_data_aux{i}) = zef_data_aux.(fieldnames_zef_data_aux{i});
          if isequal(mod(i,ceil(n_fields_2/100)),0)
            zef_waitbar(i,n_fields_2,h_waitbar,['Loading <=100 MB fields: ' num2str(i) ' / ' num2str(n_fields_2) '.']);
        end
    end

  n_fields_1 = length(matfile_fieldnames);
    for i = 1 : n_fields_1
        aux_struct = load(fullfile(path_name,file_name),matfile_fieldnames{i});
        zef_data.(matfile_fieldnames{i}) = aux_struct.(matfile_fieldnames{i});
        if isequal(mod(i,ceil(n_fields_1/100)),0)
            zef_waitbar(i,n_fields_1,h_waitbar,['Loading >100 MB fields: ' num2str(i) ' / ' num2str(n_fields_1) '.']);
        end
    end
    close(h_waitbar);
    zef_remove_system_fields;
    zef_data.project_matfile = [path_name filesep file_name];

    zef_data.matlab_release = version('-release');
    zef_data.matlab_release = str2num(zef_data.matlab_release(1:4)) + double(zef_data.matlab_release(5))/128;
    zef_data.code_path = zef.code_path;
    zef_data.program_path = zef.program_path;

    zef_data.mlapp = 1;

    zef.fieldnames = fieldnames(zef_data);
    for zef_i = 1:length(zef.fieldnames)
        if not(isequal(zef.fieldnames{zef_i},'fieldnames'))
            zef.(zef.fieldnames{zef_i}) = zef_data.(zef.fieldnames{zef_i});
        end
    end
    if isempty(find(contains(zef.fieldnames,'current_version'),1))
        zef.current_version = 2.2;
    end
    clear zef_i;
    zef = rmfield(zef,'fieldnames');

    zef = zef_apply_system_settings(zef);
    zef_data = zef_remove_object_handles(zef_data);

    zef.save_file = zef_data.save_file;
    zef.save_file_path = zef_data.save_file_path;
    if isfield(zef_data,'profile_name')
        zef.profile_name = zef_data.profile_name;
    end

    zef_replace_project_fields;

    zef_init_init_profile;
    zef_init_parameter_profile;

    if ismember(zef.start_mode,{'nodisplay'})
        zef.use_display = 0;

    end

    clear zef_data;

    for zef_i = 1 : length(zef.sensor_tags)
    zef = zef_create_sensors(zef, zef.sensor_tags{zef_i});
    end

    for zef_i = 1 : length(zef.compartment_tags)
    zef = zef_create_compartment(zef, zef.compartment_tags{zef_i});
    end

    zef = zef_set_figure_tool_sliders(zef);
    zef_plugin;
    zef_mesh_tool;
    zef_mesh_visualization_tool;
    zef_segmentation_tool;
    zef_menu_tool;
    zef = zef_update(zef);

end

if nargout == 0
    assignin('base','zef',zef);
end

end
