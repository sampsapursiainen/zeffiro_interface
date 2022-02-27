%Copyright © 2018- Sampsa Pursiainen & ZI Development Team
%See: https://github.com/sampsapursiainen/zeffiro_interface

if isvalid(zef.h_zeffiro_window_main)

zef.aux_field_1 = zef.h_compartment_table.Data;
zef.aux_field_2 = zeros(size(zef.aux_field_1,1),1);
zef.aux_field_3 = [];
zef.aux_field_4 = [];

if not(isempty(zef.aux_field_1))
for zef_i = 1 : size(zef.aux_field_1,1)

zef_j = length(zef.compartment_tags) - zef_i + 1;
if not(isnan(zef.aux_field_1{zef_i,1}))
evalin('base',['zef.' zef.compartment_tags{zef_j}, '_priority = ' num2str(zef.aux_field_1{zef_i,1}) ';']);
zef.aux_field_2(zef_j) = 1;
 zef.aux_field_3(zef_i) = 1;
elseif isnan(zef.aux_field_1{zef_i,1}) && zef.aux_field_1{zef_i,2}
evalin('base',['zef.' zef.compartment_tags{zef_j}, '_priority = ' num2str(zef_i) ';']);
zef.aux_field_2(zef_j) = 1;
zef.aux_field_3(zef_i) = 1;
else
zef.aux_field_2(zef_j) = 0;
zef.aux_field_3(zef_i) = 0;
end

if zef.aux_field_2(zef_j)

    zef_get_data_compartment_table;

zef_n = 0;
for zef_k =  1  : size(zef.parameter_profile,1)
     if isequal(zef.parameter_profile{zef_k,8},'Segmentation') && isequal(zef.parameter_profile{zef_k,6},'On') && isequal(zef.parameter_profile{zef_k,7},'On')
 zef_n = zef_n + 1;
 if isequal(zef.parameter_profile{zef_k,3},'Scalar')
  evalin('base',['zef.' zef.compartment_tags{zef_j} '_' zef.parameter_profile{zef_k,2} '='  num2str(zef.aux_field_1{zef_i, zef.compartment_table_size+zef_n}) ';']);
   elseif isequal(zef.parameter_profile{zef_k,3},'String')
  evalin('base',['zef.' zef.compartment_tags{zef_j} '_' zef.parameter_profile{zef_k,2} '='  (zef.aux_field_1{zef_i, zef.compartment_table_size+zef_n}) ';']);
 end
    end
end
else
zef.aux_field_4 = fieldnames(zef);
zef.aux_field_4 = zef.aux_field_4(find(startsWith(zef.aux_field_4,[zef.compartment_tags{zef_j} '_'])));
zef = rmfield(zef,zef.aux_field_4);
end
end

zef.compartment_tags = zef.compartment_tags(find(zef.aux_field_2));
zef.h_compartment_table.Data = zef.aux_field_1(find(zef.aux_field_3),:);

end

%sensors start

zef.aux_field_1 = zef.h_sensors_table.Data;
zef.aux_field_2 = [];
zef.aux_field_3 = [];
if not(isempty(zef.aux_field_1))
for zef_i = 1 : size(zef.aux_field_1,1)
if not(isnan(zef.aux_field_1{zef_i,1})) ||  zef.aux_field_1{zef_i,4}
    zef.aux_field_2 = [zef.aux_field_2 zef_i];
    zef.aux_field_3 = [zef.aux_field_3 zef.aux_field_1{zef_i,1}];
else
zef.aux_field_4 = fieldnames(zef);
zef.aux_field_4 = zef.aux_field_4(find(startsWith(zef.aux_field_4,[zef.sensor_tags{zef_i} '_'])));
zef = rmfield(zef,zef.aux_field_4);
end
end
[~, zef.aux_field_3] = sort(zef.aux_field_3);
zef.aux_field_2 = zef.aux_field_2(zef.aux_field_3);
zef.aux_field_3 = cell(0);
zef.sensor_tags = zef.sensor_tags(zef.aux_field_2);
for zef_i = 1 : length(zef.aux_field_2)
zef.aux_field_3{zef_i,1} = zef.aux_field_1{zef.aux_field_2(zef_i),1};
zef.aux_field_3{zef_i,2} = zef.aux_field_1{zef.aux_field_2(zef_i),2};
zef.aux_field_3{zef_i,3} = zef.aux_field_1{zef.aux_field_2(zef_i),3};
zef.aux_field_3{zef_i,4} = zef.aux_field_1{zef.aux_field_2(zef_i),4};
zef.aux_field_3{zef_i,5} = zef.aux_field_1{zef.aux_field_2(zef_i),5};
zef.aux_field_3{zef_i,6} = zef.aux_field_1{zef.aux_field_2(zef_i),6};
zef.aux_field_3{zef_i,7} = evalin('base',['not(isempty(zef.' zef.sensor_tags{zef_i} '_points))']);
zef.aux_field_3{zef_i,8} = evalin('base',['not(isempty(zef.' zef.sensor_tags{zef_i} '_directions))']);
end
zef.h_sensors_table.Data = zef.aux_field_3;
for zef_i = 1 : length(zef.sensor_tags)
    evalin('base',['zef.' zef.sensor_tags{zef_i} '_name = zef.aux_field_3{zef_i,2};']);
     evalin('base',['zef.' zef.sensor_tags{zef_i} '_imaging_method_name = zef.aux_field_3{zef_i,3};']);
    evalin('base',['zef.' zef.sensor_tags{zef_i} '_on = zef.aux_field_3{zef_i,4};']);
    evalin('base',['zef.' zef.sensor_tags{zef_i} '_visible = zef.aux_field_3{zef_i,5};']);
   evalin('base',['zef.' zef.sensor_tags{zef_i} '_names_visible = zef.aux_field_3{zef_i,6};']);
end
else
    zef.aux_field_1 = cell(0);
    for zef_i = 1 : length(zef.sensor_tags)
    zef.aux_field_1{zef_i,1} = zef_i;
    zef.aux_field_1{zef_i,2} = evalin('base',['zef.' zef.sensor_tags{zef_i} '_name']);
    zef.aux_field_1{zef_i,3} = evalin('base',['zef.' zef.sensor_tags{zef_i} '_imaging_method_name']);
    zef.aux_field_1{zef_i,4} = evalin('base',['zef.' zef.sensor_tags{zef_i} '_on']);
    zef.aux_field_1{zef_i,5} = evalin('base',['zef.' zef.sensor_tags{zef_i} '_visible']);
        zef.aux_field_1{zef_i,6} = evalin('base',['zef.' zef.sensor_tags{zef_i} '_names_visible']);
    zef.aux_field_1{zef_i,7} = evalin('base',['not(isempty(zef.' zef.sensor_tags{zef_i} '_points))']);
    zef.aux_field_1{zef_i,8} = evalin('base',['not(isempty(zef.' zef.sensor_tags{zef_i} '_directions))']);
    end

    zef.h_sensors_table.Data = zef.aux_field_1;
end

%sensors end

zef.aux_field_1 = cell(0);
zef.aux_field_2 = zeros(length(zef.compartment_tags),1);

for zef_i = 1 : length(zef.compartment_tags)

    zef.aux_field_2(zef_i) =  evalin('base',['zef.' zef.compartment_tags{zef_i} '_priority']);

end

[~, zef.aux_field_2] = sort(zef.aux_field_2);
zef.compartment_tags = zef.compartment_tags(zef.aux_field_2);

zef_update_compartment_table_data;

zef.compartment_tags = fliplr(zef.compartment_tags);

zef.h_aux = allchild(zef.h_menu_window);

for zef_i = 1 : length(zef.h_aux)
if contains(zef.h_aux(zef_i).Label,'ZEFFIRO Interface:')
    delete(zef.h_aux(zef_i));
end
end

zef.project_tag = get(zef.h_project_tag,'Value');
zef.h_aux = findall(groot, 'Type','figure','-regexp','Name','ZEFFIRO Interface:*');
for zef_i = 1 : length(zef.h_aux)
if not(isempty(strfind(zef.h_aux(zef_i).Name,'[')))
zef.h_aux(zef_i).Name = strtrim(zef.h_aux(zef_i).Name(1:strfind(zef.h_aux(zef_i).Name,'[')-1));
end
if not(isempty(zef.project_tag))
zef.h_aux(zef_i).Name = [zef.h_aux(zef_i).Name ' [' zef.project_tag ']' ];
end
end

zef.h_aux = findall(groot, 'Type','figure','-regexp','Name','ZEFFIRO Interface:*','-not','Name','ZEFFIRO Interface: Segmentation tool');
zef.h_windows_open = zef.h_windows_open(find(ismember(zef.h_windows_open,zef.h_aux)));
zef.h_windows_open = [zef.h_windows_open ; setdiff(zef.h_aux, zef.h_windows_open)];

for zef_i = 1 : length(zef.h_windows_open)
zef.aux_field_1 = sum(contains(get(zef.h_windows_open(1:zef_i),'Name'),get(zef.h_windows_open(zef_i),'Name')));
if contains(zef.h_windows_open(zef_i).Name,'ZEFFIRO Interface: Figure tool')
uimenu(zef.h_menu_window,'label',[zef.h_windows_open(zef_i).Name],'callback',['figure(evalin(''base'', ''zef.h_windows_open(' num2str(zef_i) ')'')); zef.h_zeffiro = gcf; zef.h_axes1 = findobj(get(zef.h_zeffiro,''Children''),''Tag'',''axes1'');']);
else
uimenu(zef.h_menu_window,'label',[zef.h_windows_open(zef_i).Name ' ' num2str(zef.aux_field_1)],'callback',['figure(evalin(''base'', ''zef.h_windows_open(' num2str(zef_i) ')''))']);
end
zef.aux_field_2 = zef.h_windows_open(zef_i).CloseRequestFcn;
if not(contains(zef.aux_field_2,'zef_update;'))
     zef.h_windows_open(zef_i).CloseRequestFcn = [zef.h_windows_open(zef_i).CloseRequestFcn '; zef_update;'];
end
end

zef.h_project_information.Items = ...
    {['App folder: ' zef.program_path],...
    ['Current path: ' pwd],...
    ['Project file: ' zef.save_file], ...
    ['Project folder: ' zef.save_file_path],...
    ['Project size (MB): ' num2str(round(getfield(whos('zef'),'bytes')/1000000))], ...
    ['Number of windows: ' num2str(length(zef.h_windows_open))]};

zef = rmfield(zef,{'aux_field_1','aux_field_2','aux_field_3','aux_field_4','h_aux'});

if length(zef.h_project_notes.Value) == 1 && isempty(zef.h_project_notes.Value{1})
zef.h_project_notes.Value = zef.project_notes;
else
zef.project_notes = zef.h_project_notes.Value;
end

if isempty(zef.sensor_tags)
    zef.current_sensors = [];
    zef.h_sensors_name_table.Data = [];
    zef.h_parameters_table.Data = [];
elseif not(ismember(zef.current_sensors,zef.sensor_tags))
    zef.current_sensors = [];
    zef.h_sensors_name_table.Data = [];
    zef.h_parameters_table.Data = [];
else
zef.imaging_method = find(ismember(zef.imaging_method_cell,evalin('base',['zef.' zef.current_sensors '_imaging_method_name'])),1);
zef_init_sensors_name_table;
end

zef.h_profile_name.Value = zef.profile_name;

zef_update_fig_details;

zef_toggle_lock_on;
zef_toggle_lock_sensor_sets_on;
zef_toggle_lock_sensor_names_on;
zef_toggle_lock_transforms_on;

clear zef_i zef_j zef_k zef_n;

end

if isvalid(zef.h_mesh_visualization_tool)
    zef_update_mesh_visualization_tool;
end

if isvalid(zef.h_mesh_tool)
    zef_update_mesh_tool;
end
