%Copyright © 2018- Sampsa Pursiainen & ZI Development Team
%See: https://github.com/sampsapursiainen/zeffiro_interface
function zef_import_segmentation_legacy(file_name, folder_name)

void = [];

if evalin('base','zef.use_display')
if nargin < 2
[file_name folder_name] = uigetfile({'*.zef'},'Segmentation data file and folder',evalin('base','zef.save_file_path'));
end
else
    file_name = evalin('base','zef.file');
    folder_name = evalin('base','zef.file_path');
end

if not(isequal(file_name,0));

h_import = fopen([folder_name file_name]);
ini_cell = textscan(h_import,'%s','HeaderLines',57,'Delimiter',',');
n_columns = 12;

compartment_cell = {'detail_1', 'detail_2', 'detail_3', 'detail_4', 'detail_5', 'detail_6', 'detail_7','detail_8','detail_9', ...
    'detail_10', 'detail_11', 'detail_12', 'detail_13', 'detail_14', 'detail_15', 'detail_16','detail_17','detail_18',...
    'detail_19','detail_20','detail_21','detail_22','white_matter','grey_matter','csf','skull','scalp'};

name_cell = {'d1','d2','d3','d4','d5','d6','d7','d8','d9','d10','d11','d12','d13','d14','d15','d16','d17','d18','d19','d20','d21','d22','w','g','c','sk','sc'};

compartment_count_vec = zeros(2+length(compartment_cell), 1);
volume_count_ind = 0;

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

file_name_1 = [folder_name  ini_cell{1}{n_columns*(i-1)+1} '.dat'];

sensor_points = load(file_name_1);
sensor_points = double(sensor_points);
sensor_points(:,1) = sensor_points(:,1) + str2num(ini_cell{1}{n_columns*(i-1)+10});
sensor_points(:,2) = sensor_points(:,2) + str2num(ini_cell{1}{n_columns*(i-1)+11});
sensor_points(:,3) = sensor_points(:,3) + str2num(ini_cell{1}{n_columns*(i-1)+12});

assignin('base','zef_data',sensor_points);
evalin('base','zef.s_points = zef_data;');

if not(isequal(ini_cell{1}{n_columns*(i-1)+3},'0')) && s_details(3) == 0
aux_var = ini_cell{1}{n_columns*(i-1)+3};
assignin('base','zef_data', aux_var);
evalin('base','zef.s_scaling = zef_data;');
s_details(3) = 1;
end

if not(isequal(ini_cell{1}{n_columns*(i-1)+4},'0'))  && s_details(4) == 0
aux_var = ini_cell{1}{n_columns*(i-1)+4};
assignin('base','zef_data', aux_var);
evalin('base','zef.s_x_correction = zef_data;');
s_details(4) = 1;
end

if not(isequal(ini_cell{1}{n_columns*(i-1)+5},'0'))  && s_details(5) == 0
aux_var = ini_cell{1}{n_columns*(i-1)+5};
assignin('base','zef_data', aux_var);
evalin('base','zef.s_y_correction = zef_data;');
s_details(5) = 1;
end

if not(isequal(ini_cell{1}{n_columns*(i-1)+6},'0')) && s_details(6) == 0
aux_var = ini_cell{1}{n_columns*(i-1)+6};
assignin('base','zef_data',aux_var);
evalin('base','zef.s_z_correction = zef_data;');
s_details(6) = 1;
end

if not(isequal(ini_cell{1}{n_columns*(i-1)+7},'0')) && s_details(7) == 0
aux_var = ini_cell{1}{n_columns*(i-1)+7};
assignin('base','zef_data', aux_var);
evalin('base','zef.s_xy_rotation = zef_data;');
s_details(7) = 1;
end

if not(isequal(ini_cell{1}{n_columns*(i-1)+8},'0')) && s_details(8) == 0
aux_var = ini_cell{1}{n_columns*(i-1)+8};
assignin('base','zef_data', aux_var);
evalin('base','zef.s_yz_rotation = zef_data;');
s_details(8) = 1;
end

if not(isequal(ini_cell{1}{n_columns*(i-1)+9},'0')) && s_details(9) == 0
aux_var = ini_cell{1}{n_columns*(i-1)+9};
assignin('base','zef_data', aux_var);
evalin('base','zef.s_zx_rotation = zef_data;');
s_details(9) = 1;
end

end

elseif isequal(ini_cell{1}{n_columns*(i-1)+2},'sensor_directions')

compartment_count_vec(2) = compartment_count_vec(2) + 1;

if compartment_count_vec(2) == 1

file_name_1 = [folder_name ini_cell{1}{n_columns*(i-1)+1} '.dat'];

sensor_directions = load(file_name_1);
sensor_directions = double(sensor_directions);

n_s_directions = size(sensor_directions,1);
m_s_directions = size(sensor_directions,2);

assignin('base','zef_data',sensor_directions);
evalin('base','zef.s_directions = zef_data;');

if not(isequal(ini_cell{1}{n_columns*(i-1)+3},'0')) && s_details(3) == 0
aux_var = ini_cell{1}{n_columns*(i-1)+3};
assignin('base','zef_data', aux_var);
evalin('base','zef.s_scaling = zef_data;');
s_details(3) = 1;
end

if not(isequal(ini_cell{1}{n_columns*(i-1)+4},'0'))  && s_details(4) == 0
aux_var = ini_cell{1}{n_columns*(i-1)+4};
assignin('base','zef_data', aux_var);
evalin('base','zef.s_x_correction = zef_data;');
s_details(4) = 1;
end

if not(isequal(ini_cell{1}{n_columns*(i-1)+5},'0'))  && s_details(5) == 0
aux_var = ini_cell{1}{n_columns*(i-1)+5};
assignin('base','zef_data', aux_var);
evalin('base','zef.s_y_correction = zef_data;');
s_details(5) = 1;
end

if not(isequal(ini_cell{1}{n_columns*(i-1)+6},'0')) && s_details(6) == 0
aux_var = ini_cell{1}{n_columns*(i-1)+6};
assignin('base', 'zef_data', aux_var);
evalin('base','zef.s_z_correction = zef_data;');
s_details(6) = 1;
end

if not(isequal(ini_cell{1}{n_columns*(i-1)+7},'0')) && s_details(7) == 0
aux_var = ini_cell{1}{n_columns*(i-1)+7};
assignin('base','zef_data', aux_var);
evalin('base','zef.s_xy_correction = zef_data;');
s_details(7) = 1;
end

if not(isequal(ini_cell{1}{n_columns*(i-1)+8},'0')) && s_details(8) == 0
aux_var = ini_cell{1}{n_columns*(i-1)+8};
assignin('base','zef_data', aux_var);
evalin('base','zef.s_yz_correction = zef_data;');
s_details(8) = 1;
end

if not(isequal(ini_cell{1}{n_columns*(i-1)+9},'0')) && s_details(9) == 0
aux_var = ini_cell{1}{n_columns*(i-1)+9};
assignin('base','zef_data', aux_var);
evalin('base','zef.s_zx_correction = zef_data;');
s_details(9) = 1;
end

end

elseif isequal(ini_cell{1}{n_columns*(i-1)+2},'mat_struct')

    file_name_1 = [folder_name ini_cell{1}{n_columns*(i-1)+1} '.mat'];
    zef_import_mat_struct(load(file_name_1));

else

if isequal(ini_cell{1}{n_columns*(i-1)+9},'ASC') || isequal(ini_cell{1}{n_columns*(i-1)+9},'asc')

file_name_1 = [folder_name ini_cell{1}{n_columns*(i-1)+1} '.asc'];

fid = fopen(file_name_1);
aux_dim = textscan(fid,'%s',1,'delimiter','\n', 'headerlines',1);
aux_dim = str2num(aux_dim{1}{1});
aux_dim = aux_dim(1:2);

point_data = zeros(aux_dim(1),3);
triangle_data = zeros(aux_dim(1),3);

fid = fopen(file_name_1);
aux_data = textscan(fid,'%s',aux_dim(1),'delimiter','\n', 'headerlines',2);

point_data = cellfun(@(v) zef_import_asc(v),aux_data{1},'uniformoutput',false);
point_data = cell2mat(point_data);
point_data(:,1) = point_data(:,1) + str2num(ini_cell{1}{n_columns*(i-1)+10});
point_data(:,2) = point_data(:,2) + str2num(ini_cell{1}{n_columns*(i-1)+11});
point_data(:,3) = point_data(:,3) + str2num(ini_cell{1}{n_columns*(i-1)+12});

fid = fopen(file_name_1);
aux_data = textscan(fid,'%s',aux_dim(2),'delimiter','\n', 'headerlines',2+aux_dim(1));

triangle_data = cellfun(@(v) zef_import_asc(v),aux_data{1},'uniformoutput',false);
triangle_data = cell2mat(triangle_data)+1;

elseif isequal(ini_cell{1}{n_columns*(i-1)+9},'STL') || isequal(ini_cell{1}{n_columns*(i-1)+9},'stl')

file_name_1 = [folder_name ini_cell{1}{n_columns*(i-1)+1} '.stl'];

stl_data = stlread(file_name_1);

point_data = stl_data.Points;
triangle_data = stl_data.ConnectivityList;

elseif isequal(ini_cell{1}{n_columns*(i-1)+9},'VOL') || isequal(ini_cell{1}{n_columns*(i-1)+9},'vol')

volume_count_ind = volume_count_ind + 1;
[triangle_data, point_data] = zef_surface_mesh(evalin('base','zef.tetra'),evalin('base','zef.nodes'),evalin('base',['find(zef.domain_labels<=' num2str(volume_count_ind) ');']));

else

file_name_1 = [folder_name  ini_cell{1}{n_columns*(i-1)+1} '_points.dat'];

mesh_data = load(file_name_1);
mesh_data = double(mesh_data);
point_data = mesh_data(:,1:3);
point_data(:,1) = point_data(:,1) + str2num(ini_cell{1}{n_columns*(i-1)+10});
point_data(:,2) = point_data(:,2) + str2num(ini_cell{1}{n_columns*(i-1)+11});
point_data(:,3) = point_data(:,3) + str2num(ini_cell{1}{n_columns*(i-1)+12});

file_name_2 = [folder_name  ini_cell{1}{n_columns*(i-1)+1} '_triangles.dat'];

fid = fopen(file_name_2);

mesh_data = load(file_name_2);
mesh_data = double(mesh_data);
triangle_data = mesh_data(:,1:3);
triangle_data = mesh_data(:,1:3);
if min(triangle_data(:)) == 0
    triangle_data = triangle_data + 1;
end

end

for j = 1 : length(compartment_cell)

if isequal(ini_cell{1}{n_columns*(i-1)+2},compartment_cell{j})

if isequal(ini_cell{1}{n_columns*(i-1)+9},'ASC') && j < 23

    [point_data] = zef_smooth_surface(point_data,triangle_data,0.5,60);

end

compartment_count_vec(j+2) = compartment_count_vec(j+2) + 1;
if isequal(ini_cell{1}{n_columns*(i-1)+8},'0')
invert_on = 0;
else
invert_on = 1;
end

if compartment_count_vec(j+2) == 1
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
    l2_triangles = l2_triangles(:,[1 3 2]);
end
if isempty(l1_triangles)
    max_val = 0;
else
    max_val = max(l1_triangles(:));
end
triangle_data = [l1_triangles; l2_triangles+max_val];
assignin('base','zef_data', [evalin('base',['zef.' name_cell{j} '_submesh_ind']) size(triangle_data,1)]);
evalin('base',['zef.' name_cell{j} '_submesh_ind = zef_data;']);
else
if invert_on
    triangle_data = triangle_data(:,[1 3 2]);
end
assignin('base','zef_data', size(triangle_data,1));
evalin('base',['zef.' name_cell{j} '_submesh_ind = zef_data;']);
end

n_points = size(point_data,1);
n_triangles = size(triangle_data,1);

assignin('base', 'zef_data', 1);
evalin('base',['zef.' name_cell{j} '_on = zef_data;']);
assignin('base','zef_data', point_data);
evalin('base',['zef.' name_cell{j} '_points = zef_data;']);
assignin('base','zef_data', triangle_data);
evalin('base',['zef.' name_cell{j} '_triangles = zef_data;']);
assignin('base','zef_data', evalin('base',['zef.' name_cell{j} '_points']));
evalin('base',['zef.' name_cell{j} '_points_original_surface_mesh = zef_data;']);
assignin('base','zef_data', evalin('base',['zef.' name_cell{j} '_triangles']));
evalin('base',['zef.' name_cell{j} '_triangles_original_surface_mesh = zef_data;']);
assignin('base','zef_data', evalin('base',['zef.' name_cell{j} '_submesh_ind']));
evalin('base',['zef.' name_cell{j} '_submesh_ind_original_surface_mesh = zef_data;']);

if compartment_count_vec(j+2) == 1

if not(isequal(ini_cell{1}{n_columns*(i-1)+3},'0'))
aux_var = ini_cell{1}{n_columns*(i-1)+3};
if isstr(aux_var)
    aux_var = str2num(aux_var);
end
assignin('base', 'zef_data', aux_var);
evalin('base',['zef.' name_cell{j} '_scaling = zef_data;'])
end

if not(isequal(ini_cell{1}{n_columns*(i-1)+4},'0'))
aux_var = ini_cell{1}{n_columns*(i-1)+4};
if isstr(aux_var)
    aux_var = str2num(aux_var);
end
assignin('base', 'zef_data', aux_var);
evalin('base', ['zef.' name_cell{j} '_sigma = zef_data;']);
end

if not(isequal(ini_cell{1}{n_columns*(i-1)+5},'0'))
aux_var = ini_cell{1}{n_columns*(i-1)+5};
if isstr(aux_var)
    aux_var = str2num(aux_var);
end
assignin('base', 'zef_data', aux_var);
evalin('base',['zef.' name_cell{j} '_priority = zef_data;']);
end

%if not(isequal(ini_cell{1}{n_columns*(i-1)+6},'0'))
aux_var = ini_cell{1}{n_columns*(i-1)+6};
if isstr(aux_var)
    aux_var = str2num(aux_var);
end
assignin('base', 'zef_data', aux_var);
evalin('base',['zef.' name_cell{j} '_sources = zef_data;']);
%end

if not(isequal(ini_cell{1}{n_columns*(i-1)+7},'0'))
aux_var = ini_cell{1}{n_columns*(i-1)+7};
assignin('base', 'zef_data', aux_var);
evalin('base',['zef.' name_cell{j} '_name = zef_data;']);
end

end

end

end

%*****************************

%*****************************

end

end

close(h_waitbar);

end

end

