function zef_import_segmentation(file_name, folder_name)

domain_label_counter = 0;
if evalin('base','zef.use_display')
if nargin < 2
[file_name, folder_name] = uigetfile({'*.zef;*.mat'},'Segmentation data file and folder',evalin('base','zef.save_file_path'));
end
else
    file_name = evalin('base','zef.file');
    folder_name = evalin('base','zef.file_path');
end

if not(isequal(file_name,0));
    
    [~,~,extension] = fileparts(file_name);
    if isequal(extension,'.mat')
        zef_import_mat_struct(fullfile(folder_name,file_name));
        
    else

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
compartment_tags = evalin('base','zef.compartment_tags');
sensor_tags = evalin('base','zef.sensor_tags');

for i = 1 : size(ini_cell,1)
    
    compartment_data = evalin('base','zef.h_compartment_table.Data');
    sensors_data = evalin('base','zef.h_sensors_table.Data');
    
    waitbar(i/size(ini_cell,1),h,['Importing ' num2str(i) '/' num2str(size(ini_cell,1)) '.']);
    ini_cell_ind = [ini_cell_ind find(ismember(ini_cell(i,:),'type'),1)];
    ini_cell_ind = [ini_cell_ind ini_cell_ind(end)+1];
    type = (ini_cell{i,find(ismember(ini_cell(i,:),'type'),1)+1});
    ini_cell_ind = [ini_cell_ind find(ismember(ini_cell(i,:),'name'),1)];
    ini_cell_ind = [ini_cell_ind ini_cell_ind(end)+1];
    name = '';
    filetype = '';
    filename = '';
    if ismember('name',ini_cell(i,:))
    name = (ini_cell{i,find(ismember(ini_cell(i,:),'name'),1)+1});
    end
    
    if isequal(type,'segmentation')
        if not(isempty(compartment_data))
            if ismember(name,compartment_data(:,3))
            compartment_ind = find(ismember(compartment_data(:,3),name));
            compartment_tag = compartment_tags{end-compartment_ind+1};
            else
            domain_label_counter = domain_label_counter + 1;
            evalin('base','zef_add_compartment;');
            compartment_tags = evalin('base','zef.compartment_tags');
            compartment_tag = compartment_tags{1};
            end
        else
             domain_label_counter = domain_label_counter + 1;
            evalin('base','zef_add_compartment;');
            compartment_tags = evalin('base','zef.compartment_tags');
            compartment_tag = compartment_tags{1};
        end

        if ismember('filename',ini_cell(i,:))
        ini_cell_ind = [ini_cell_ind find(ismember(ini_cell(i,:),'filename'),1)];
        ini_cell_ind = [ini_cell_ind ini_cell_ind(end)+1];
        filename = (ini_cell{i,find(ismember(ini_cell(i,:),'filename'),1)+1});
        end
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
        eval(['zef_data.' compartment_tag '_affine_transform = {' affine_transform '};']);
        eval(['zef_data.' compartment_tag '_sources = ' activity ';']);
        eval(['zef_data.' compartment_tag '_on = ' on  ';']);
        eval(['zef_data.' compartment_tag '_visible = ' visible ';']);
        zef_data.surface_mesh_type = filetype;
        zef_data.file = filename;
        zef_data.file_path = folder_name;

        if not(isempty(filename))
            if not(ismember(filetype,{'mat',''}))
        evalin('base','zef_get_surface_mesh;');
        elseif isequal(filetype,'mat')
           zef_import_mat_struct(fullfile(folder_name,filename),[compartment_tag '_']);
        elseif isempty(filetype)
         aux_tetra = evalin('base','zef.tetra');
         aux_nodes = evalin('base','zef.nodes');
         aux_domain_labels = evalin('base','zef.domain_labels');
            [aux_triangles, aux_points] = zef_surface_mesh(aux_tetra(find(aux_domain_labels<=max(aux_domain_labels)-domain_label_counter+1),:),aux_nodes);
            aux_submesh_ind = size(aux_triangles,1);
            eval(['zef_data.' compartment_tag '_points = aux_points;']);
            eval(['zef_data.' compartment_tag '_triangles = aux_triangles;']);
            eval(['zef_data.' compartment_tag '_submesh_ind = aux_submesh_ind;']);
            end
        end
        
        assignin('base','zef_data',zef_data);
        evalin('base','zef_assign_data;');
        clear zef_data;
 
    %    evalin('base','zef_init_parameter_profile;');
        evalin('base','zef_apply_parameter_profile;');
        evalin('base','zef_build_compartment_table;');

    elseif isequal(type,'sensors')

        name = (ini_cell{i,find(ismember(ini_cell(i,:),'name'),1)+1});
       if not(isempty(sensors_data))
        if ismember(name,sensors_data(:,2))
            sensors_ind = find(ismember(sensors_data(:,2),name));
            sensor_tag = sensor_tags{end-sensors_ind+1};
        else
            evalin('base','zef_add_sensors;');
            sensor_tags = evalin('base','zef.sensor_tags');
            sensor_tag = sensor_tags{1};
        end
       else
           evalin('base','zef_add_sensors;');
            sensor_tags = evalin('base','zef.sensor_tags');
            sensor_tag = sensor_tags{1};
       end

        filename = '';
        if ismember('filename',ini_cell(i,:))
            ini_cell_ind = [ini_cell_ind find(ismember(ini_cell(i,:),'filename'),1)];
                ini_cell_ind = [ini_cell_ind ini_cell_ind(end)+1];
        filename = (ini_cell{i,find(ismember(ini_cell(i,:),'filename'),1)+1});
        end
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
        if find(ismember(ini_cell(i,:),'affine_transform'))
            ini_cell_ind = [ini_cell_ind find(ismember(ini_cell(i,:),'affine_transform'),1)];
                ini_cell_ind = [ini_cell_ind ini_cell_ind(end)+1];
        affine_transform = ini_cell{i,find(ismember(ini_cell(i,:),'affine_transform'),1)+1};
        else
            affine_transform = mat2str(eye(4));
        end
         
        %eval(['zef_data.sensora_selected = ' num2str(sensors_ind) ';']);
         eval(['zef_data.current_sensors = ''' sensor_tag  ''';']);
        eval(['zef_data.' sensor_tag '_name = ''' name ''';']);
        eval(['zef_data.' sensor_tag '_on = ' on  ';']);
        eval(['zef_data.' sensor_tag '_visible = ' visible ';']);
        eval(['zef_data.' sensor_tag '_affine_transform = {' affine_transform '};']);
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
            if isequal(filetype,'mat')
           zef_import_mat_struct(fullfile(folder_name,filename),[sensor_tag '_']);
            end
        end   

       % evalin('base','zef_init_sensors_parameter_profile;');
        evalin('base','zef_apply_parameter_profile;');
evalin('base','zef_build_sensors_table;');

    elseif isequal(type,'struct')
       filename = '';
        if ismember('filename',ini_cell(i,:))
        ini_cell_ind = [ini_cell_ind find(ismember(ini_cell(i,:),'filename'),1)];
        ini_cell_ind = [ini_cell_ind ini_cell_ind(end)+1];
        filename = (ini_cell{i,find(ismember(ini_cell(i,:),'filename'),1)+1});
        zef_import_mat_struct(fullfile(folder_name,filename));
        end
          
    elseif isequal(type,'script')
       filename = '';
        if ismember('filename',ini_cell(i,:))
        ini_cell_ind = [ini_cell_ind find(ismember(ini_cell(i,:),'filename'),1)];
        ini_cell_ind = [ini_cell_ind ini_cell_ind(end)+1];
        filename = (ini_cell{i,find(ismember(ini_cell(i,:),'filename'),1)+1});
        evalin('base',['run(''' fullfile(folder_name,filename)  ''');']);
        end
        
        
    end
    
    
    
end

%zef_data
%assignin('base','zef_data',zef_data);
 %       evalin('base','zef_assign_data;');

close(h);

    end
end

end
