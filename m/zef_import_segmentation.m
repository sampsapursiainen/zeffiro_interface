function zef_import_segmentation(void)

void = [];

[file_name folder_name] = uigetfile({'*.dat'},'Segmentation data file and folder',evalin('base','zef.save_file_path'));

if not(isequal(file_name,0));

h_import = fopen([folder_name file_name]);
ini_cell = textscan(h_import,'%s','HeaderLines',17,'Delimiter',',');
n_columns = 9;

compartment_cell = {'detail_1', 'detail_2', 'detail_3', 'detail_4', 'detail_5', 'detail_6', 'detail_7','detail_8','detail_9', ...
    'detail_10', 'detail_11', 'detail_12', 'detail_13', 'detail_14', 'detail_15', 'detail_16','detail_17','detail_18',...
    'detail_19','detail_20','detail_21','detail_22','white_matter','grey_matter','csf','skull','scalp'};

name_cell = {'d1','d2','d3','d4','d5','d6','d7','d8','d9','d10','d11','d12','d13','d14','d15','d16','d17','d18','d19','d20','d21','d22','w','g','c','sk','sc'};

compartment_count_vec = zeros(length(compartment_cell), 1);

n_segmentation = length(ini_cell{:})/n_columns;

s_details = zeros(9,1);

for i = 1 : n_segmentation
    
if i == 1
h_waitbar = waitbar(1/n_segmentation,['Item ' int2str(1) ' of ' int2str(n_segmentation) '.']);    
else
waitbar(i/n_segmentation,h_waitbar,['Item ' int2str(i) ' of ' int2str(n_segmentation) '.']); 
end
    
if isequal(ini_cell{1}{n_columns*(i-1)+2},'sensor_points') 
        
compartment_count_vec(1) = compartment_count_vec(1) + 1;

if compartment_count_vec(1) == 1

file_name_1 = [folder_name '/' ini_cell{1}{n_columns*(i-1)+1} '.dat']; 

sensor_points = readtable(file_name_1);
sensor_points = table2array(sensor_points);
sensor_points = double(sensor_points);

n_s_points = size(sensor_points,1);

evalin('base',['zef.s_points = reshape([' num2str(sensor_points(:)') '],' num2str(n_s_points) ',3);']);

if not(isequal(ini_cell{1}{n_columns*(i-1)+3},'0')) && s_details(3) == 0
aux_var = ini_cell{1}{n_columns*(i-1)+3};
evalin('base', ['zef.s_scaling =' num2str(aux_var) ';']);
s_details(3) = 1;
end

if not(isequal(ini_cell{1}{n_columns*(i-1)+4},'0'))  && s_details(4) == 0
aux_var = ini_cell{1}{n_columns*(i-1)+4};
evalin('base', ['zef.s_x_correction =' num2str(aux_var) ';']);
s_details(4) = 1;
end

if not(isequal(ini_cell{1}{n_columns*(i-1)+5},'0'))  && s_details(5) == 0
aux_var = ini_cell{1}{n_columns*(i-1)+5};
evalin('base', ['zef.s_y_correction =' num2str(aux_var) ';']);
s_details(5) = 1;
end

if not(isequal(ini_cell{1}{n_columns*(i-1)+6},'0')) && s_details(6) == 0
aux_var = ini_cell{1}{n_columns*(i-1)+6};
evalin('base', ['zef.s_z_correction =' num2str(aux_var) ';']);
s_details(6) = 1;
end

if not(isequal(ini_cell{1}{n_columns*(i-1)+7},'0')) && s_details(7) == 0
aux_var = ini_cell{1}{n_columns*(i-1)+7};
evalin('base', ['zef.s_xy_rotation =' num2str(aux_var) ';']);
s_details(7) = 1;
end

if not(isequal(ini_cell{1}{n_columns*(i-1)+8},'0')) && s_details(8) == 0
aux_var = ini_cell{1}{n_columns*(i-1)+8};
evalin('base', ['zef.s_yz_rotation =' num2str(aux_var) ';']);
s_details(8) = 1;
end

if not(isequal(ini_cell{1}{n_columns*(i-1)+9},'0')) && s_details(9) == 0
aux_var = ini_cell{1}{n_columns*(i-1)+9};
evalin('base', ['zef.s_zx_rotation =' num2str(aux_var) ';']);
s_details(9) = 1;
end

end

elseif isequal(ini_cell{1}{n_columns*(i-1)+2},'sensor_directions') 
        
compartment_count_vec(2) = compartment_count_vec(2) + 1;

if compartment_count_vec(2) == 1

file_name_1 = [folder_name '/' ini_cell{1}{n_columns*(i-1)+1} '.dat']; 

sensor_directions = readtable(file_name_1);
sensor_directions = table2array(sensor_directions);
sensor_directions = double(sensor_directions);

n_s_directions = size(sensor_directions,1);

evalin('base',['zef.s_points = reshape([' num2str(sensor_points(:)') '],' num2str(n_s_directions) ',3);']);

if not(isequal(ini_cell{1}{n_columns*(i-1)+3},'0')) && s_details(3) == 0
aux_var = ini_cell{1}{n_columns*(i-1)+3};
evalin('base', ['zef.s_scaling =' num2str(aux_var) ';']);
s_details(3) = 1;
end

if not(isequal(ini_cell{1}{n_columns*(i-1)+4},'0'))  && s_details(4) == 0
aux_var = ini_cell{1}{n_columns*(i-1)+4};
evalin('base', ['zef.s_x_correction =' num2str(aux_var) ';']);
s_details(4) = 1;
end

if not(isequal(ini_cell{1}{n_columns*(i-1)+5},'0'))  && s_details(5) == 0
aux_var = ini_cell{1}{n_columns*(i-1)+5};
evalin('base', ['zef.s_y_correction =' num2str(aux_var) ';']);
s_details(5) = 1;
end

if not(isequal(ini_cell{1}{n_columns*(i-1)+6},'0')) && s_details(6) == 0
aux_var = ini_cell{1}{n_columns*(i-1)+6};
evalin('base', ['zef.s_z_correction =' num2str(aux_var) ';']);
s_details(6) = 1;
end

if not(isequal(ini_cell{1}{n_columns*(i-1)+7},'0')) && s_details(7) == 0
aux_var = ini_cell{1}{n_columns*(i-1)+7};
evalin('base', ['zef.s_xy_correction =' num2str(aux_var) ';']);
s_details(7) = 1;
end

if not(isequal(ini_cell{1}{n_columns*(i-1)+8},'0')) && s_details(8) == 0
aux_var = ini_cell{1}{n_columns*(i-1)+8};
evalin('base', ['zef.s_yz_correction =' num2str(aux_var) ';']);
s_details(8) = 1;
end

if not(isequal(ini_cell{1}{n_columns*(i-1)+9},'0')) && s_details(9) == 0
aux_var = ini_cell{1}{n_columns*(i-1)+9};
evalin('base', ['zef.s_zx_correction =' num2str(aux_var) ';']);
s_details(9) = 1;
end

end

elseif isequal(ini_cell{1}{n_columns*(i-1)+2},'parcellation_colortable')
    
elseif isequal(ini_cell{1}{n_columns*(i-1)+2},'parcellation_points')    

else

if isequal(ini_cell{1}{n_columns*(i-1)+9},'ASC') || isequal(ini_cell{1}{n_columns*(i-1)+9},'asc')

file_name_1 = [folder_name '/' ini_cell{1}{n_columns*(i-1)+1} '.asc'];  
file_name_2 = [folder_name '/' ini_cell{1}{n_columns*(i-1)+1} '.dat'];  
copyfile(file_name_1,file_name_2);
mesh_data = readtable(file_name_2);
delete(file_name_2);

mesh_data = table2array(mesh_data);
mesh_data = double(mesh_data);

n_points = max(mesh_data(find(mesh_data - round(mesh_data) == 0))) + 1;

point_data = mesh_data(1:n_points,1:3);
triangle_data = mesh_data(n_points + 1 : end, 1:3) + 1;

else 
      
file_name_1 = [folder_name '/' ini_cell{1}{n_columns*(i-1)+1} '_points.dat']; 

mesh_data = readtable(file_name_1);
mesh_data = table2array(mesh_data);
mesh_data = double(mesh_data);
point_data = mesh_data(:,1:3);
point_data = mesh_data(:,1:3);

file_name_2 = [folder_name '/' ini_cell{1}{n_columns*(i-1)+1} '_triangles.dat']; 

mesh_data = readtable(file_name_2);
mesh_data = table2array(mesh_data);
mesh_data = double(mesh_data);
triangle_data = mesh_data(:,1:3);
triangle_data = mesh_data(:,1:3);

end

for j = 1 : length(compartment_cell)
    
if isequal(ini_cell{1}{n_columns*(i-1)+2},compartment_cell{j})
    
compartment_count_vec(j) = compartment_count_vec(j) + 1;
if isequal(ini_cell{1}{n_columns*(i-1)+8},'0')
invert_on = 0;
else
invert_on = 1;
end
    
if compartment_count_vec(j) == 1
merge_on = 0;
else
merge_on = 1;
end
    
if merge_on    
l1_points = evalin('base',['zef.' name_cell{j} '_points']);
l2_points = point_data; 
point_data = [l1_points; l2_points];
end

if merge_on
l1_triangles = evalin('base',['zef.' name_cell{j} '_triangles']); 
l2_triangles = triangle_data;
if invert_on
    l2_triangles = l2_triangles(:,[2 1 3]);
end
if isempty(l1_triangles)
    max_val = 0;
else
    max_val = max(l1_triangles(:));
end
triangle_data = [l1_triangles; l2_triangles+max_val];
else
if invert_on
    triangle_data = triangle_data(:,[2 1 3]);
end
end

n_points = size(point_data,1);
n_triangles = size(triangle_data,1);

evalin('base', ['zef.' name_cell{j} '_on = 1;']);

evalin('base',['zef.' name_cell{j} '_points = reshape([' num2str(point_data(:)') '],' num2str(n_points) ',3);']);
evalin('base',['zef.' name_cell{j} '_triangles = reshape([' num2str(triangle_data(:)') '],' num2str(n_triangles) ',3);']);


if compartment_count_vec(j) == 1
    
if not(isequal(ini_cell{1}{n_columns*(i-1)+3},'0'))
aux_var = ini_cell{1}{n_columns*(i-1)+3};
evalin('base', ['zef.' name_cell{j} '_scaling =' num2str(aux_var) ';']);
end

if not(isequal(ini_cell{1}{n_columns*(i-1)+4},'0'))
aux_var = ini_cell{1}{n_columns*(i-1)+4};
evalin('base', ['zef.' name_cell{j} '_sigma =' num2str(aux_var) ';']);
end

if not(isequal(ini_cell{1}{n_columns*(i-1)+5},'0'))
aux_var = ini_cell{1}{n_columns*(i-1)+5};
evalin('base', ['zef.' name_cell{j} '_priority =' num2str(aux_var) ';']);
end

%if not(isequal(ini_cell{1}{n_columns*(i-1)+6},'0'))
aux_var = ini_cell{1}{n_columns*(i-1)+6};
evalin('base', ['zef.' name_cell{j} '_sources =' num2str(aux_var) ';']);
%end

if not(isequal(ini_cell{1}{n_columns*(i-1)+7},'0'))
aux_var = ini_cell{1}{n_columns*(i-1)+7};
evalin('base', ['zef.' name_cell{j} '_name =''' aux_var ''';']);
end

end

end

end

end

end

close(h_waitbar);
end

end








