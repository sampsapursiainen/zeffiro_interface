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
elseif isnan(zef.aux_field_1{zef_i,1}) && zef.aux_field_1{zef_i,3}
evalin('base',['zef.' zef.compartment_tags{zef_j}, '_priority = ' num2str(zef_i) ';']);
zef.aux_field_2(zef_j) = 1;
zef.aux_field_3(zef_i) = 1;
else
zef.aux_field_2(zef_j) = 0;
zef.aux_field_3(zef_i) = 0;
end

if zef.aux_field_2(zef_j)
evalin('base',['zef.' zef.compartment_tags{zef_j}, '_name = ''' zef.aux_field_1{zef_i,2} ''';']);
evalin('base',['zef.' zef.compartment_tags{zef_j}, '_on = ' num2str(double(zef.aux_field_1{zef_i,3})) ';']);
evalin('base',['zef.' zef.compartment_tags{zef_j}, '_visible = ' num2str(double(zef.aux_field_1{zef_i,4})) ';']);
evalin('base',['zef.' zef.compartment_tags{zef_j}, '_merge = ' num2str(double(zef.aux_field_1{zef_i,5})) ';']);
evalin('base',['zef.' zef.compartment_tags{zef_j}, '_invert = ' num2str(double(zef.aux_field_1{zef_i,6})) ';']);
evalin('base',['zef.' zef.compartment_tags{zef_j}, '_sources = ' num2str(find(ismember(zef.h_compartment_table.ColumnFormat{7},zef.aux_field_1{zef_i,7}),1)-1) ';']);
evalin('base',['zef.' zef.compartment_tags{zef_j}, '_sigma = ' num2str(zef.aux_field_1{zef_i,8}) ';']);
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

for zef_i = 1 : length(zef.compartment_tags)

zef.aux_field_1{zef_i,1} = zef_i;
evalin('base',['zef.' zef.compartment_tags{zef_i} '_priority = ' num2str( zef_i ) ';']);
zef.aux_field_1{zef_i,2} = evalin('base',['zef.' zef.compartment_tags{zef_i} '_name']);
zef.aux_field_1{zef_i,3} = logical(evalin('base',['zef.' zef.compartment_tags{zef_i} '_on']));
zef.aux_field_1{zef_i,4} = logical(evalin('base',['zef.' zef.compartment_tags{zef_i} '_visible']));
zef.aux_field_1{zef_i,5} = logical(evalin('base',['zef.' zef.compartment_tags{zef_i} '_merge']));
zef.aux_field_1{zef_i,6} = logical(evalin('base',['zef.' zef.compartment_tags{zef_i} '_invert']));
zef.aux_field_1{zef_i,7} = zef.compartment_activity{evalin('base',['zef.' zef.compartment_tags{zef_i} '_sources'])+1};
zef.aux_field_1{zef_i,8} = evalin('base',['zef.' zef.compartment_tags{zef_i} '_sigma']);

end

zef.compartment_tags = fliplr(zef.compartment_tags);

zef.h_compartment_table.Data = zef.aux_field_1;

zef.h_aux = allchild(zef.h_menu_window);

for zef_i = 1 : length(zef.h_aux)
if contains(zef.h_aux(zef_i).Label,'ZEFFIRO Interface:')
    delete(zef.h_aux(zef_i));
end
end

zef.h_aux = findall(groot, 'Type','figure','-regexp','Name','ZEFFIRO Interface:*','-not','Name','ZEFFIRO Interface: Segmentation tool');
zef.h_windows_open = zef.h_windows_open(find(ismember(zef.h_windows_open,zef.h_aux)));
zef.h_windows_open = [zef.h_windows_open ; setdiff(zef.h_aux, zef.h_windows_open)];


for zef_i = 1 : length(zef.h_windows_open)
zef.aux_field_1 = sum(contains(get(zef.h_windows_open(1:zef_i),'Name'),get(zef.h_windows_open(zef_i),'Name')));
uimenu(zef.h_menu_window,'label',[zef.h_windows_open(zef_i).Name ' ' num2str(zef.aux_field_1)],'callback',['figure(evalin(''base'', ''zef.h_windows_open(' num2str(zef_i) ')''))']);
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

zef.imaging_method = find(ismember(zef.imaging_method_cell,evalin('base',['zef.' zef.current_sensors '_imaging_method_name'])),1);

zef_init_sensors_name_table;
zef_update_fig_details;

clear zef_i zef_j;

end
