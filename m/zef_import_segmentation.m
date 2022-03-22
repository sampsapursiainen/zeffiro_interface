function zef_import_segmentation(file_name, folder_name)

if evalin('base','zef.use_display')
if nargin < 2
[file_name folder_name] = uigetfile({'*.zef'},'Segmentation data file and folder',evalin('base','zef.save_file_path'));
end
else
    file_name = evalin('base','zef.file');
    folder_name = evalin('base','zef.file_path');
end

if not(isequal(file_name,0));

h = waitbar(0,'Importing.');

ini_cell_ind = [];
ini_cell = readcell(fullfile(folder_name,file_name),'FileType','Text','NumHeaderLines',0,'Delimiter',',');
ini_cell_original = ini_cell;
for i = 1 : size(ini_cell,1)
for j = 1 : size(ini_cell,2)
if    ismissing(ini_cell{i,j})
    ini_cell{i,j} = 'missing_cell_entry';
end
    if not(ischar(ini_cell{i,j}))
    ini_cell{i,j} = num2str(ini_cell{i,j});
    end
end
end
compartment_data = evalin('base','zef.h_compartment_table.Data');
compartment_tags = evalin('base','zef.compartment_tags');
sensors_data = evalin('base','zef.h_sensors_table.Data');
sensor_tags = evalin('base','zef.sensor_tags');

for i = 1 : size(ini_cell,1)

    waitbar(i/size(ini_cell,1),h,['Importing' num2str(i) '/' num2str(size(ini_cell,1)) '.']);
    ini_cell_ind = [ini_cell_ind find(ismember(ini_cell(i,:),'type'),1)];
    ini_cell_ind = [ini_cell_ind ini_cell_ind(end)+1];
    type = (ini_cell{i,find(ismember(ini_cell(i,:),'type'),1)+1});
    ini_cell_ind = [ini_cell_ind find(ismember(ini_cell(i,:),'name'),1)];
    ini_cell_ind = [ini_cell_ind ini_cell_ind(end)+1];
    name = (ini_cell{i,find(ismember(ini_cell(i,:),'name'),1)+1});

    if isequal(type,'segmentation')
        if not(isempty(compartment_data))
            if ismember(name,compartment_data(:,2))
            compartment_ind = find(ismember(compartment_data(:,2),name));
            compartment_tag = compartment_tags{end-compartment_ind+1};
            else
            evalin('base','zef_add_compartment;');
            compartment_tags = evalin('base','zef.compartment_tags');
            compartment_tag = compartment_tags{1};
            compartment_ind = length(compartment_tags);
            end
        else
            evalin('base','zef_add_compartment;');
            compartment_tags = evalin('base','zef.compartment_tags');
            compartment_tag = compartment_tags{1};
            compartment_ind = length(compartment_tags);
        end

        filename = [];
        if ismember('filename',ini_cell(i,:))
        ini_cell_ind = [ini_cell_ind find(ismember(ini_cell(i,:),'filename'),1)];
        ini_cell_ind = [ini_cell_ind ini_cell_ind(end)+1];
        filename = (ini_cell{i,find(ismember(ini_cell(i,:),'filename'),1)+1});
        if ismember('filetype',ini_cell(i,:))
        ini_cell_ind = [ini_cell_ind find(ismember(ini_cell(i,:),'filetype'),1)];
        ini_cell_ind = [ini_cell_ind ini_cell_ind(end)+1];
        filetype = (ini_cell{i,find(ismember(ini_cell(i,:),'filetype'),1)+1});
        end
        if find(ismember(ini_cell(i,:),'merge'))
            ini_cell_ind = [ini_cell_ind find(ismember(ini_cell(i,:),'merge'),1)];
                ini_cell_ind = [ini_cell_ind ini_cell_ind(end)+1];
        merge = (ini_cell{i,find(ismember(ini_cell(i,:),'merge'),1)+1});
        else
            merge = '0';
        end
        if find(ismember(ini_cell(i,:),'invert'))
            ini_cell_ind = [ini_cell_ind find(ismember(ini_cell(i,:),'invert'),1)];
                ini_cell_ind = [ini_cell_ind ini_cell_ind(end)+1];
        invert = (ini_cell{i,find(ismember(ini_cell(i,:),'invert'),1)+1});
        else
            invert = '0';
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

         aux_ind = 0;
         while not(isempty(aux_ind))
             aux_set = setdiff([1:length(ini_cell(i,:))],ini_cell_ind);
        [~, aux_ind] = min(aux_set);
        aux_ind = aux_set(aux_ind);
        if not(isempty(aux_ind))
            if not(isequal(ini_cell{i,aux_ind},'missing_cell_entry'))
        if ischar(ini_cell_original{i,aux_ind+1})
        eval(['zef_data.' compartment_tag '_' ini_cell{i,aux_ind} ' = ''' ini_cell{i,aux_ind+1} ''';']);
        else
        eval(['zef_data.' compartment_tag '_' ini_cell{i,aux_ind} ' = ' ini_cell{i,aux_ind+1} ';']);
        end
            end
        ini_cell_ind = [ini_cell_ind aux_ind aux_ind+1];
        end
         end

        %eval(['zef_data.compartments_selected = ' num2str(compartment_ind) ';']);
        eval(['zef_data.current_compartment = ''' compartment_tag ''';']);
        eval(['zef_data.' compartment_tag '_merge = ' merge ';']);
        eval(['zef_data.' compartment_tag '_invert = ' invert ';']);
        eval(['zef_data.' compartment_tag '_name = ''' name ''';']);
        eval(['zef_data.' compartment_tag '_sources = ' activity ';']);
        eval(['zef_data.' compartment_tag '_on = ' on  ';']);
        eval(['zef_data.' compartment_tag '_visible = ' visible ';']);
        zef_data.surface_mesh_type = filetype;
        zef_data.file = filename;
        zef_data.file_path = folder_name;
        assignin('base','zef_data',zef_data);
        evalin('base','zef_assign_data;');
        clear zef_data;
        if not(isempty(filename))
            if not(isequal(filetype,'mat'))
        evalin('base','zef_get_surface_mesh;');
            else
           zef_import_mat_struct(fullfile(folder_name,filename));
            end
        end

    %    evalin('base','zef_init_parameter_profile;');
        evalin('base','zef_apply_parameter_profile;');
        evalin('base','zef_build_compartment_table;');

        end

    elseif isequal(type,'sensors')

        name = (ini_cell{i,find(ismember(ini_cell(i,:),'name'),1)+1});
        if ismember(name,sensors_data(:,2))
            sensors_ind = find(ismember(sensors_data(:,2),name));
            sensor_tag = sensor_tags{end-sensors_ind+1};
        else
            evalin('base','zef_add_sensors;');
            sensor_tags = evalin('base','zef.sensor_tags');
            sensor_tag = sensor_tags{1};
            sensors_ind = length(sensor_tags);
        end

        filename = [];
           if ismember('filename',ini_cell(i,:))
            ini_cell_ind = [ini_cell_ind find(ismember(ini_cell(i,:),'filename'),1)];
                ini_cell_ind = [ini_cell_ind ini_cell_ind(end)+1];
        filename = (ini_cell{i,find(ismember(ini_cell(i,:),'filename'),1)+1});
          if ismember('filetype',ini_cell(i,:))
        ini_cell_ind = [ini_cell_ind find(ismember(ini_cell(i,:),'filetype'),1)];
          ini_cell_ind = [ini_cell_ind ini_cell_ind(end)+1];
        filetype = (ini_cell{i,find(ismember(ini_cell(i,:),'filetype'),1)+1});
          end
         if find(ismember(ini_cell(i,:),'modality'))
        ini_cell_ind = [ini_cell_ind find(ismember(ini_cell(i,:),'modality'),1)];
        ini_cell_ind = [ini_cell_ind ini_cell_ind(end)+1];
        modality = (ini_cell{i,find(ismember(ini_cell(i,:),'modality'),1)+1});
        else
            modality = evalin('base','zef.imaging_method_cell{1}');
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

        %eval(['zef_data.sensora_selected = ' num2str(sensors_ind) ';']);
         eval(['zef_data.current_sensors = ''' sensor_tag  ''';']);
        eval(['zef_data.' sensor_tag '_name = ''' name ''';']);
        eval(['zef_data.' sensor_tag '_on = ' on  ';']);
        eval(['zef_data.' sensor_tag '_visible = ' visible ';']);
         eval(['zef_data.' sensor_tag '_imaging_method_name = ''' modality ''';']);
           zef_data.file = filename;
        zef_data.file_path = folder_name;
        assignin('base','zef_data',zef_data);
        evalin('base','zef_assign_data;');
        clear zef_data;
        if not(isempty(filename))
            if isequal(filetype,'points')
        evalin('base','zef_get_sensor_points;');
            end
             if isequal(filetype,'directions')
        evalin('base','zef_get_sensor_directions;');
            end
        end

       % evalin('base','zef_init_sensors_parameter_profile;');
        evalin('base','zef_apply_parameter_profile;');
evalin('base','zef_build_sensors_table;');

           end

    end

end

%zef_data
%assignin('base','zef_data',zef_data);
 %       evalin('base','zef_assign_data;');

close(h);

end

end
