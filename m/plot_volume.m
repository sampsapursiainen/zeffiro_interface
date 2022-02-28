%Copyright © 2018- Sampsa Pursiainen & ZI Development Team
%See: https://github.com/sampsapursiainen/zeffiro_interface
function [void] = plot_volume(void);

f_ind = 1;
if isequal(evalin('base','zef.volumetric_distribution_mode'),1)
volumetric_distribution = evalin('base','zef.reconstruction');
elseif isequal(evalin('base','zef.volumetric_distribution_mode'),2)
volumetric_distribution = repmat(evalin('base','zef.sigma(:,1)')',3,1)/sqrt(3);
volumetric_distribution = volumetric_distribution(:);
elseif isequal(evalin('base','zef.volumetric_distribution_mode'),3)
volumetric_distribution = evalin('base','y_ES');
if iscell(volumetric_distribution)
for i = 1 : length(volumetric_distribution)
volumetric_distribution{i} = evalin('base','zef.L')*volumetric_distribution{i};
end
else
volumetric_distribution = evalin('base','zef.L')*volumetric_distribution;
end
elseif isequal(evalin('base','zef.volumetric_distribution_mode'),4)
volumetric_distribution = zef_condition_number(evalin('base','zef.nodes'), evalin('base','zef.tetra'));
volumetric_distribution = repmat(volumetric_distribution(:)',3,1)/sqrt(3);
end

h_colorbar = findobj(evalin('base','zef.h_zeffiro'),'-regexp','tag','Colorbar');
if not(isempty(h_colorbar))
    delete(h_colorbar(:));
end

void = [];

sensors_point_like = [];

if isequal(evalin('base','zef.h_zeffiro.UserData'),1) || isempty(evalin('base','zef.h_zeffiro.UserData'))
colorbar_position = [0.60 0.647 0.01 0.29];
else
colorbar_position = [0.8769 0.647 0.01 0.29];
end

loop_movie = 1;
length_reconstruction_cell = 1;
movie_fps = evalin('base','zef.movie_fps');
sensor_tag = evalin('base','zef.current_sensors');
compartment_tags = evalin('base','zef.compartment_tags');

aux_wm_ind = -1;

number_of_frames = evalin('base','zef.number_of_frames');
h_axes_image = evalin('base','zef.h_axes1');
axes(evalin('base','zef.h_axes1'));
cla(evalin('base','zef.h_axes1'));
set(evalin('base','zef.h_axes1'),'layer','top');
set(evalin('base','zef.h_axes1'),'YDir','normal');

h_axes_text = findobj(evalin('base','zef.h_zeffiro'),'tag','image_details');
if not(isempty(h_axes_text))
delete(h_axes_text);
h_axes_text = [];
end
h_colorbar = findobj(evalin('base','zef.h_zeffiro'),'-regexp','tag','Colorbar');
if not(isempty(h_colorbar))
delete(h_colorbar(:));
h_colorbar = [];
end

hold on;
light('Position',[0 0 1],'Style','infinite');
light('Position',[0 0 -1],'Style','infinite');

cp_a = evalin('base','zef.cp_a');
cp_b = evalin('base','zef.cp_b');
cp_c = evalin('base','zef.cp_c');
cp_d = evalin('base','zef.cp_d');
cp2_a = evalin('base','zef.cp2_a');
cp2_b = evalin('base','zef.cp2_b');
cp2_c = evalin('base','zef.cp2_c');
cp2_d = evalin('base','zef.cp2_d');
cp3_a = evalin('base','zef.cp3_a');
cp3_b = evalin('base','zef.cp3_b');
cp3_c = evalin('base','zef.cp3_c');
cp3_d = evalin('base','zef.cp3_d');

%April 2021
sensors = evalin('base','zef.sensors');
sensors_visible = find(evalin('base',['zef.' sensor_tag '_visible_list']));
sensors_color_table = evalin('base',['zef.' sensor_tag '_color_table']);
sensors_name = evalin('base',['zef.' sensor_tag '_name_list']);
aux_scale_val = evalin('base','zef.sensors_visual_size');
if not(isempty(sensors_visible))
sensors = sensors(sensors_visible,:);
sensors_name = sensors_name(sensors_visible);
sensors_color_table = sensors_color_table(sensors_visible,:);
end
%April 2021

[X_s, Y_s, Z_s] = sphere(50);
sphere_scale = aux_scale_val;
X_s = sphere_scale*X_s;
Y_s = sphere_scale*Y_s;
Z_s = sphere_scale*Z_s;
surface_triangles = evalin('base','zef.surface_triangles');
nodes = evalin('base','zef.nodes');

if size(sensors,2) == 6 & ismember(evalin('base','zef.imaging_method'), [1 4 5])
electrode_model = 2;
else
electrode_model = 1;
end

aux_ind = [];
clipped = 0;
if evalin('base',['zef.' sensor_tag '_visible'])
if evalin('base','zef.cp_on');
clipping_plane = {cp_a,cp_b,cp_c,cp_d};
if clipped
aux_ind = zef_clipping_plane(sensors(:,1:3),clipping_plane,aux_ind);
else
aux_ind = zef_clipping_plane(sensors(:,1:3),clipping_plane);
end
clipped = 1;
end
if evalin('base','zef.cp2_on');
clipping_plane = {cp2_a,cp2_b,cp2_c,cp2_d};
if clipped
aux_ind = zef_clipping_plane(sensors(:,1:3),clipping_plane,aux_ind);
else
aux_ind = zef_clipping_plane(sensors(:,1:3),clipping_plane);
end
clipped = 1;
end
if evalin('base','zef.cp3_on');
clipping_plane = {cp3_a,cp3_b,cp3_c,cp3_d};
if clipped
aux_ind = zef_clipping_plane(sensors(:,1:3),clipping_plane,aux_ind);
else
aux_ind = zef_clipping_plane(sensors(:,1:3),clipping_plane);
end
clipped = 1;
end
if evalin('base','zef.cp_on') || evalin('base','zef.cp2_on') || evalin('base','zef.cp3_on')
if evalin('base','zef.cp_mode') == 1
sensors = sensors(aux_ind,:);
sensors_visible = sensors_visible(aux_ind,:);
sensors_color_table = sensors_color_table(aux_ind,:);
sensors_name = sensors_name(aux_ind);
elseif evalin('base','zef.cp_mode') == 2
aux_ind = setdiff([1:size(sensors,1)]',aux_ind);
sensors = sensors(aux_ind,:);
sensors_visible = sensors_visible(aux_ind,:);
sensors_color_table = sensors_color_table(aux_ind,:);
sensors_name = sensors_name(aux_ind);
end
end
aux_ind = [];

%April 2021
if not(evalin('base','zef.attach_electrodes'))
sensors_name_points = sensors(:,1:3);
end
sensors_aux = sensors;
%April 2021

if electrode_model == 1 & evalin('base','zef.attach_electrodes') & ismember(evalin('base','zef.imaging_method'),[1 4 5])
sensors = attach_sensors_volume(sensors);
elseif electrode_model==2 & evalin('base','zef.attach_electrodes') & ismember(evalin('base','zef.imaging_method'),[1 4 5])
 sensors = attach_sensors_volume(sensors);
  sensors_point_like_index = find(sensors(:,4)==0);
  unique_sensors_point_like = unique(sensors(sensors_point_like_index,1));
  sensors_point_like = zeros(length(unique_sensors_point_like),3);
%April 2021
sensors_name_points = attach_sensors_volume(sensors_aux,'points');
sensors_point_like_id = find(sensors(:,4)==0);
%April 2021
  for spl_ind = 1 : length(unique_sensors_point_like)
spl_aux_ind = find(sensors(sensors_point_like_index,1)==unique_sensors_point_like(spl_ind));
sensors_point_like(spl_ind,:) = mean(nodes(sensors(sensors_point_like_index(spl_aux_ind),2),:),1);
  end
sensors_patch_like_index = setdiff(1:size(sensors,1),sensors_point_like_index);
  sensors = sensors(sensors_patch_like_index,:);
else
    electrode_model = 1;
end

if electrode_model == 1 | not(ismember(evalin('base','zef.imaging_method'),[1,4,5]))
for i = 1 : size(sensors,1)
h = surf(sensors(i,1) + X_s, sensors(i,2) + Y_s, sensors(i,3) + Z_s);
h.Tag = 'sensor';
%April 2021
if evalin('base',['zef.' evalin('base','zef.current_sensors') '_names_visible'])
h_text = text(sensors(i,1),sensors(i,2),sensors(i,3),sensors_name{i});
set(h_text,'FontSize',evalin('base','zef.h_axes1.FontSize'));
end
set(h,'facecolor',sensors_color_table(i,:));
%April 2021
%set(h,'edgecolor','none');
%set(h,'specularstrength',0.3);
%set(h,'diffusestrength',0.7);
%set(h,'ambientstrength',0.7);
set(h,'facealpha',evalin('base','zef.layer_transparency'));
end
else
%April 2021
if evalin('base',['zef.' evalin('base','zef.current_sensors') '_names_visible'])
for i = 1 : size(sensors_name_points,1)
h_text = text(sensors_name_points(i,1),sensors_name_points(i,2),sensors_name_points(i,3),sensors_name{i});
set(h_text,'FontSize',evalin('base','zef.h_axes1.FontSize'));
end
end
if not(isempty(sensors))
unique_sensors_aux_1 = unique(sensors(:,1));
h = zeros(length(unique_sensors_aux_1),1);
for i = 1 : length(unique_sensors_aux_1)
unique_sensors_aux_2 = find(sensors(:,1)==unique_sensors_aux_1(i));
[min_n_aux, min_t_aux] = zef_minimal_mesh(nodes,sensors(unique_sensors_aux_2,2:4));
h(i) = trisurf(min_t_aux,min_n_aux(:,1),min_n_aux(:,2),min_n_aux(:,3));
set(h(i),'Tag','sensor');
set(h(i),'facecolor',sensors_color_table(unique_sensors_aux_1(i),:));
end
set(h,'edgecolor','none');
%set(h,'specularstrength',0.3);
%set(h,'diffusestrength',0.7);
%set(h,'ambientstrength',0.7);
set(h,'facealpha',evalin('base','zef.layer_transparency'));
set(h,'edgealpha',evalin('base','zef.layer_transparency'));
    end
if not(isempty(sensors_point_like))
h = zeros(size(sensors_point_like,1),1);
for i = 1 : size(sensors_point_like,1)
h(i) = surf(sensors_point_like(i,1) + X_s, sensors_point_like(i,2) + Y_s, sensors_point_like(i,3) + Z_s);
set(h(i),'facecolor',sensors_color_table(sensors_point_like_id(i),:));
set(h(i),'Tag','sensor');
end
%April 2021
set(h,'edgecolor','none');
%set(h,'specularstrength',0.3);
%set(h,'diffusestrength',0.7);
%set(h,'ambientstrength',0.7);
set(h,'facealpha',evalin('base','zef.layer_transparency'));
end
end
if ismember(evalin('base','zef.imaging_method'),[2,3])
sensors(:,4:6) = sensors(:,4:6)./repmat(sqrt(sum(sensors(:,4:6).^2,2)),1,3);
h=coneplot(sensors(:,1) + aux_scale_val*sensors(:,4),sensors(:,2) + aux_scale_val*sensors(:,5),sensors(:,3) + aux_scale_val*sensors(:,6),2*aux_scale_val*sensors(:,4),2*aux_scale_val*sensors(:,5),2*aux_scale_val*sensors(:,6),0,'nointerp');
set(h,'facecolor',evalin('base',['zef.' sensor_tag '_color']));
set(h,'edgecolor','none');
%set(h,'specularstrength',0.3);
%set(h,'diffusestrength',0.7);
%set(h,'ambientstrength',0.7);
set(h,'facealpha',evalin('base','zef.layer_transparency'));
if size(sensors,2) == 9
sensors(:,7:9) = sensors(:,7:9)./repmat(sqrt(sum(sensors(:,7:9).^2,2)),1,3);
h=coneplot(sensors(:,1) + aux_scale_val*sensors(:,4),sensors(:,2) + aux_scale_val*sensors(:,5),sensors(:,3) + aux_scale_val*sensors(:,6),2*aux_scale_val*sensors(:,4),2*aux_scale_val*sensors(:,5),2*aux_scale_val*sensors(:,6),0,'nointerp');
set(h,'facecolor',0.9*[0 1 1]);
set(h,'edgecolor','none');
%set(h,'specularstrength',0.3);
%set(h,'diffusestrength',0.7);
%set(h,'ambientstrength',0.7);
set(h,'facealpha',evalin('base','zef.layer_transparency'));
end
end
end

i = 0;
length_reuna = 0;
sigma_vec = [];
priority_vec = [];
visible_vec = [];
color_cell = cell(0);
aux_brain_ind = [];
aux_dir_mode = [];
for k = 1 : length(compartment_tags)

        var_0 = ['zef.' compartment_tags{k} '_on'];
        var_1 = ['zef.' compartment_tags{k} '_sigma'];
        var_2 = ['zef.' compartment_tags{k} '_priority'];
        var_3 = ['zef.' compartment_tags{k} '_visible'];
    color_str = evalin('base',['zef.' compartment_tags{k} '_color']);

on_val = evalin('base',var_0);
sigma_val = evalin('base',var_1);
priority_val = evalin('base',var_2);
visible_val = evalin('base',var_3);
if on_val
i = i + 1;
sigma_vec(i,1) = sigma_val;
priority_vec(i,1) = priority_val;
color_cell{i} = color_str;
visible_vec(i,1) = i*visible_val;
if evalin('base',['zef.' compartment_tags{k} '_sources']);
    aux_brain_ind = [aux_brain_ind i];
end
end
end

johtavuus = evalin('base','zef.sigma');
johtavuus = johtavuus(:,2);

if evalin('base','zef.use_gpu_graphic') == 1 & evalin('base','zef.use_gpu') == 1 & gpuDeviceCount > 0
I = gpuArray(uint32(find(ismember(johtavuus,visible_vec))));
tetra = gpuArray(uint32(evalin('base','zef.tetra')));
nodes = gpuArray(nodes);
else
    %tässä
  I = uint32(find(ismember(johtavuus,visible_vec)));
  tetra = uint32(evalin('base','zef.tetra'));
end

johtavuus = johtavuus(I);

tetra = tetra(I,:);
tetra_c = (1/4)*(nodes(tetra(:,1),:) + nodes(tetra(:,2),:) + nodes(tetra(:,3),:) + nodes(tetra(:,4),:));

aux_ind = [];
clipped = 0;
if evalin('base','zef.cp_on');
clipping_plane = {cp_a,cp_b,cp_c,cp_d};
aux_ind = zef_clipping_plane(tetra_c,clipping_plane);
clipped = 1;
end
if evalin('base','zef.cp2_on');
clipping_plane = {cp2_a,cp2_b,cp2_c,cp2_d};
if clipped
aux_ind = zef_clipping_plane(tetra_c,clipping_plane,aux_ind);
else
aux_ind = zef_clipping_plane(tetra_c,clipping_plane);
end
clipped = 1;
end
if evalin('base','zef.cp3_on');
clipping_plane = {cp3_a,cp3_b,cp3_c,cp3_d};
if clipped
aux_ind = zef_clipping_plane(tetra_c,clipping_plane,aux_ind);
else
aux_ind = zef_clipping_plane(tetra_c,clipping_plane);
end
clipped = 1;
end

if evalin('base','zef.cp_on') || evalin('base','zef.cp2_on') || evalin('base','zef.cp3_on')
if evalin('base','zef.cp_mode') == 1
tetra = tetra(aux_ind,:);
elseif evalin('base','zef.cp_mode') == 2
aux_ind = setdiff([1:size(tetra,1)]',aux_ind);
tetra = tetra(aux_ind,:);
elseif evalin('base','zef.cp_mode') == 3
aux_ind = union(aux_ind,find(ismember(johtavuus,aux_brain_ind)));
tetra = tetra(aux_ind,:);
elseif evalin('base','zef.cp_mode') == 4
aux_ind = setdiff([1:size(tetra,1)]',aux_ind);
aux_ind = union(aux_ind,find(ismember(johtavuus,aux_brain_ind)));
tetra = tetra(aux_ind,:);
end
else
aux_ind = [1:size(tetra,1)]';
end;
I_aux = I(aux_ind);

 ind_m = [ 2 3 4;
           1 4 3;
           1 2 4;
           1 3 2];

tetra_sort = uint32([tetra(:,[2 3 4]) ones(size(tetra,1),1) [1:size(tetra,1)]';
              tetra(:,[1 4 3]) 2*ones(size(tetra,1),1) [1:size(tetra,1)]';
              tetra(:,[1 2 4]) 3*ones(size(tetra,1),1) [1:size(tetra,1)]';
              tetra(:,[1 3 2]) 4*ones(size(tetra,1),1) [1:size(tetra,1)]';]);

if evalin('base','zef.use_gpu_graphic') == 1 & evalin('base','zef.use_gpu') == 1 & gpuDeviceCount > 0
    tetra_sort = gpuArray(tetra_sort);
end

tetra_sort(:,1:3) = sort(tetra_sort(:,1:3),2);

tetra_sort = sortrows(tetra_sort,[1 2 3]);
tetra_ind = uint32(zeros(size(tetra_sort,1),1));
I = uint32(find(sum(abs(tetra_sort(2:end,1:3)-tetra_sort(1:end-1,1:3)),2)==0));

if evalin('base','zef.use_gpu_graphic') == 1 & evalin('base','zef.use_gpu') == 1 & gpuDeviceCount > 0
    tetra_ind = gpuArray(tetra_ind);
    I = gpuArray(I);
end

tetra_ind(I) = 1;
tetra_ind(I+1) = 1;
I = find(tetra_ind == 0);
tetra_ind = sub2ind(size(tetra),repmat(tetra_sort(I,5),1,3),ind_m(tetra_sort(I,4),:));
surface_triangles = tetra(tetra_ind);
tetra_ind = tetra_sort(I,5);
clear tetra_sort;

n_compartments = i;

max_abs_reconstruction = -Inf;
min_rec = Inf;
max_rec = -Inf;
frame_start = 1;
frame_stop = 1;
frame_step = 1;
if ismember(evalin('base','zef.visualization_type'), [2,4])
    if ismember(evalin('base','zef.volumetric_distribution_mode'), [1,3])
s_i_ind = evalin('base','zef.source_interpolation_ind{1}');
    elseif ismember(evalin('base','zef.volumetric_distribution_mode'), [2,4])
    s_i_ind = [1:evalin('base','size(zef.tetra,1)')]';
    end
    end

if evalin('base','zef.use_parcellation')
selected_list = evalin('base','zef.parcellation_selected');
p_i_ind = evalin('base','zef.parcellation_interp_ind');
end

if iscell(volumetric_distribution) &&  evalin('base','zef.visualization_type') == 2
length_reconstruction_cell = length(volumetric_distribution);
frame_start = evalin('base','zef.frame_start');
frame_stop = evalin('base','zef.frame_stop');
frame_step = evalin('base','zef.frame_step');
if frame_start == 0
    frame_start = 1;
end
if frame_stop == 0
    frame_stop = length_reconstruction_cell;
end
frame_start = max(frame_start,1);
frame_start = min(length_reconstruction_cell,frame_start);
frame_stop = max(frame_stop,1);
frame_stop = min(length_reconstruction_cell,frame_stop);
number_of_frames = length([frame_start : frame_step : frame_stop]);
for f_ind = frame_start : frame_step : frame_stop
reconstruction = single(volumetric_distribution{f_ind});
reconstruction = reconstruction(:);
reconstruction = reshape(reconstruction,3,length(reconstruction)/3);
if ismember(evalin('base','zef.reconstruction_type'), 6)
reconstruction = (1/sqrt(3))*sum(reconstruction)';
else
reconstruction = sqrt(sum(reconstruction.^2))';
end
reconstruction = sum(reconstruction(s_i_ind),2)/size(s_i_ind,2);
max_abs_reconstruction = max([max_abs_reconstruction ; (reconstruction(:))]);
min_rec = min([min_rec ; (reconstruction(:))]);
max_rec = max_abs_reconstruction;
end
if not(ismember(evalin('base','zef.reconstruction_type'), [6]))
if evalin('base','zef.inv_scale') == 1
min_rec_log10 = 20*log10(max(min_rec,max_abs_reconstruction/evalin('base','zef.inv_dynamic_range')));
max_rec = -min_rec_log10  + 20*log10(max(max_rec,max_abs_reconstruction/evalin('base','zef.inv_dynamic_range')));
min_rec = 0;
elseif evalin('base','zef.inv_scale') == 2
min_rec = (max(min_rec,max_abs_reconstruction/evalin('base','zef.inv_dynamic_range')));
max_rec = (max(max_rec,max_abs_reconstruction/evalin('base','zef.inv_dynamic_range')));
elseif evalin('base','zef.inv_scale') == 3
min_rec = sqrt(max(min_rec,max_abs_reconstruction/evalin('base','zef.inv_dynamic_range')));
max_rec = sqrt(max(max_rec,max_abs_reconstruction/evalin('base','zef.inv_dynamic_range')));
end
end
elseif  evalin('base','zef.visualization_type') == 2
%s_i_ind = evalin('base','zef.source_interpolation_ind{1}');
reconstruction = volumetric_distribution;
reconstruction = reconstruction(:);
reconstruction = reshape(reconstruction,3,length(reconstruction)/3);
if ismember(evalin('base','zef.reconstruction_type'), 6)
reconstruction = (1/sqrt(3))*sum(reconstruction)';
else
reconstruction = sqrt(sum(reconstruction.^2))';
end
reconstruction = sum(reconstruction(s_i_ind),2)/size(s_i_ind,2);
max_abs_reconstruction = max([max_abs_reconstruction ; (reconstruction(:))]);
min_rec = min([min_rec ; (reconstruction(:))]);
max_rec = max_abs_reconstruction;
if not(ismember(evalin('base','zef.reconstruction_type'), [6]))
if evalin('base','zef.inv_scale') == 1
min_rec_log10 = 20*log10(max(min_rec,max_abs_reconstruction/evalin('base','zef.inv_dynamic_range')));
max_rec = -min_rec_log10 + 20*log10(max(max_rec,max_abs_reconstruction/evalin('base','zef.inv_dynamic_range')));
min_rec = 0;
elseif evalin('base','zef.inv_scale') == 2
min_rec = (max(min_rec,max_abs_reconstruction/evalin('base','zef.inv_dynamic_range')));
max_rec = (max(max_rec,max_abs_reconstruction/evalin('base','zef.inv_dynamic_range')));
elseif evalin('base','zef.inv_scale') == 3
min_rec = sqrt(max(min_rec,max_abs_reconstruction/evalin('base','zef.inv_dynamic_range')));
max_rec = sqrt(max(max_rec,max_abs_reconstruction/evalin('base','zef.inv_dynamic_range')));
end
end
end
%if  iscell(volumetric_distribution) & evalin('base','zef.visualization_type') == 2
%h_waitbar = waitbar(1/number_of_frames,['Frame ' int2str(1) ' of ' int2str(number_of_frames) '.']);
%set(h_waitbar,'handlevisibility','off');
%end

loop_count = 0;
while loop_movie && loop_count <= evalin('base','zef.loop_movie_count')
loop_count = loop_count + 1;
axes(evalin('base','zef.h_axes1'));
set(evalin('base','zef.h_axes1'),'layer','top');
set(evalin('base','zef.h_axes1'),'YDir','normal');
hold on;

f_ind_aux = 1;
for f_ind = frame_start : frame_start
%if  iscell(volumetric_distribution) & evalin('base','zef.visualization_type') == 2
%waitbar(f_ind_aux/number_of_frames,h_waitbar,['Frame ' int2str(f_ind_aux) ' of ' int2str(number_of_frames) '.']);
%set(h_waitbar,'handlevisibility','off');
%end
axes(evalin('base','zef.h_axes1'));
if not(isempty(h_colorbar))
delete(h_colorbar(:));
h_colorbar = [];
end
hold on;
%**************************************************************************
if ismember(evalin('base','zef.visualization_type'),[2,4])
if ismember(evalin('base','zef.volumetric_distribution_mode'), [2,4])
brain_ind_aux = [1:evalin('base','size(zef.tetra,1)')]';
brain_ind = [1:length(I_aux)]';
I_2  = I_aux;
else
brain_ind_aux = evalin('base','zef.brain_ind');
brain_ind = brain_ind_aux;
[~, brain_ind, I_2] = intersect(I_aux,brain_ind);
end
johtavuus(aux_ind(brain_ind))=0;
I_3 = find(ismember(tetra_ind,brain_ind));

if evalin('base','zef.use_parcellation')
reconstruction_p_1 = ones(size(I_3,1),1);
reconstruction_p_2 = zeros(size(I_3,1),1);
p_rec_aux = ones(size(nodes,1),1)*evalin('base','zef.layer_transparency');
p_cell = cell(0);
for p_ind = selected_list
p_ind_aux = brain_ind_aux(p_i_ind{p_ind}{1});
[p_ind_aux,p_ind_aux_1,p_ind_aux_2] = intersect(I_aux, p_ind_aux);
[p_ind_aux] = find(ismember(tetra_ind(I_3),p_ind_aux_1));
reconstruction_p_1(p_ind_aux) = p_ind+1;
reconstruction_p_2(p_ind_aux) = 1;
p_cell{p_ind+1} = p_ind_aux;
p_rec_aux(unique(surface_triangles(I_3(p_ind_aux),:))) = evalin('base','zef.brain_transparency');
end
end
end

if ismember(evalin('base','zef.visualization_type'),[4])
reconstruction = reconstruction_p_1;
min_rec = 1;
max_rec = size(evalin('base','zef.parcellation_colormap'),1);
end

if ismember(evalin('base','zef.visualization_type'),[2])
if iscell(volumetric_distribution)
reconstruction = single(volumetric_distribution{f_ind});
else
reconstruction = volumetric_distribution;
end
reconstruction = reconstruction(:);
reconstruction = reshape(reconstruction,3,length(reconstruction)/3);

if ismember(evalin('base','zef.reconstruction_type'),[1 7])
reconstruction = sqrt(sum(reconstruction.^2))';
elseif evalin('base','zef.reconstruction_type') == 6
reconstruction = (1/sqrt(3))*sum(reconstruction)';
end
if ismember(evalin('base','zef.reconstruction_type'), [1 6 7])
reconstruction = sum(reconstruction(s_i_ind),2)/size(s_i_ind,2);
reconstruction = reconstruction(I_2);
I_2_b_rec = I_2;
I_3_rec = I_3;
I_2 = zeros(length(aux_ind),1);
I_2(brain_ind) = [1:length(brain_ind)]';
I_2_rec = I_2;
I_1 = tetra_ind(I_3);
I_1_rec = I_1;
reconstruction = reconstruction(I_2(I_1));
end

if ismember(evalin('base','zef.reconstruction_type'), [2 3 4 5])
rec_x = reconstruction(1,:)';
rec_y = reconstruction(2,:)';
rec_z = reconstruction(3,:)';
rec_x = sum(rec_x(s_i_ind),2)/size(s_i_ind,2);
rec_y = sum(rec_y(s_i_ind),2)/size(s_i_ind,2);
rec_z = sum(rec_z(s_i_ind),2)/size(s_i_ind,2);
rec_x = rec_x(I_2);
rec_y = rec_y(I_2);
rec_z = rec_z(I_2);
I_2_b_rec = I_2;
I_3_rec = I_3;
I_2 = zeros(length(aux_ind),1);
I_2(brain_ind) = [1:length(brain_ind)]';
I_2_rec = I_2;
I_1 = tetra_ind(I_3);
I_1_rec = I_1;
rec_x = rec_x(I_2(I_1));
rec_y = rec_y(I_2(I_1));
rec_z = rec_z(I_2(I_1));
n_vec_aux = cross(nodes(surface_triangles(I_3,2),:)' - nodes(surface_triangles(I_3,1),:)',...
nodes(surface_triangles(I_3,3),:)' - nodes(surface_triangles(I_3,1),:)')';
n_vec_aux = n_vec_aux./repmat(sqrt(sum(n_vec_aux.^2,2)),1,3);
end

if ismember(evalin('base','zef.reconstruction_type'), [2 3 4 5])
reconstruction = sqrt((rec_x.*n_vec_aux(:,1)).^2 + (rec_y.*n_vec_aux(:,2)).^2 + (rec_z.*n_vec_aux(:,3)).^2);
end

if evalin('base','zef.reconstruction_type') == 3
reconstruction = sqrt((rec_x - rec_x.*abs(n_vec_aux(:,1))).^2 + (rec_y - rec_y.*abs(n_vec_aux(:,2))).^2 + (rec_z - rec_z.*abs(n_vec_aux(:,3))).^2);
end

if evalin('base','zef.reconstruction_type') == 4
aux_rec = rec_x.*n_vec_aux(:,1) + rec_y.*n_vec_aux(:,2) + rec_z.*n_vec_aux(:,3);
I_aux_rec = find(aux_rec > 0);
reconstruction(I_aux_rec) = 0;
%reconstruction = reconstruction./max(abs(reconstruction(:)));
end

if evalin('base','zef.reconstruction_type') == 5
aux_rec = rec_x.*n_vec_aux(:,1) + rec_y.*n_vec_aux(:,2) + rec_z.*n_vec_aux(:,3);
I_aux_rec = find(aux_rec <= 0);
reconstruction(I_aux_rec) = 0;
%reconstruction = reconstruction./max(abs(reconstruction(:)));
end

if ismember(evalin('base','zef.reconstruction_type'), [2 3 4 5 7])
reconstruction = smooth_field(surface_triangles(I_3,:), reconstruction, size(nodes,1),3);
end

if not(ismember(evalin('base','zef.reconstruction_type'),[6]))
if evalin('base','zef.inv_scale') == 1
reconstruction = -min_rec_log10 + 20*log10(max(reconstruction,max_abs_reconstruction/evalin('base','zef.inv_dynamic_range')));
elseif evalin('base','zef.inv_scale') == 2
reconstruction = (max(reconstruction,max_abs_reconstruction/evalin('base','zef.inv_dynamic_range')));
elseif evalin('base','zef.inv_scale') == 3
reconstruction = sqrt(max(reconstruction,max_abs_reconstruction/evalin('base','zef.inv_dynamic_range')));
end
end
end

if ismember(evalin('base','zef.visualization_type'),[2,4])

if not(ismember(evalin('base','zef.visualization_type'),[4]))
if evalin('base','zef.use_parcellation')

if evalin('base','zef.parcellation_type') > 1
rec_aux = zeros(size(reconstruction));
if evalin('base','zef.parcellation_type') == 2
for p_ind = selected_list
rec_aux(p_cell{p_ind+1}) = quantile(reconstruction(p_cell{p_ind+1}),evalin('base','zef.parcellation_quantile'));
end
elseif evalin('base','zef.parcellation_type') == 3
for p_ind = selected_list
rec_aux(p_cell{p_ind+1}) = quantile(sqrt(reconstruction(p_cell{p_ind+1})),evalin('base','zef.parcellation_quantile'));
end
elseif evalin('base','zef.parcellation_type') == 4
for p_ind = selected_list
rec_aux(p_cell{p_ind+1}) = quantile((reconstruction(p_cell{p_ind+1})).^(1/3),evalin('base','zef.parcellation_quantile'));
end
elseif evalin('base','zef.parcellation_type') == 5
for p_ind = selected_list
rec_aux(p_cell{p_ind+1}) = mean(reconstruction(p_cell{p_ind+1}));
end
end
reconstruction = rec_aux;
end

reconstruction = reconstruction.*reconstruction_p_2;
end
end

colormap_size = evalin('base','zef.colormap_size');
colortune_param = evalin('base','zef.colortune_param');
colormap_cell = evalin('base','zef.colormap_cell');
set(evalin('base','zef.h_zeffiro'),'colormap', evalin('base',[colormap_cell{evalin('base','zef.inv_colormap')} '(' num2str(colortune_param) ',' num2str(colormap_size) ')']));
h_surf_2 = trimesh(surface_triangles(I_3,:),nodes(:,1),nodes(:,2),nodes(:,3),reconstruction);
set(h_surf_2,'Tag','reconstruction');
if ismember(evalin('base','zef.volumetric_distribution_mode'),[1, 3])
zef_plot_cone_field(evalin('base','zef.h_axes1'), f_ind);
end

set(h_surf_2,'edgecolor','none','facecolor','flat','facelighting','flat','CDataMapping','scaled');
set(gca,'CLim',[min_rec max_rec]);
%set(h_surf_2,'specularstrength',0.2);
%set(h_surf_2,'specularexponent',0.8);
%set(h_surf_2,'SpecularColorReflectance',0.8);
%set(h_surf_2,'diffusestrength',1);
%set(h_surf_2,'ambientstrength',1);
if evalin('base','zef.brain_transparency') < 1 || evalin('base','zef.use_parcellation')
f_alpha_aux = zeros(size(nodes,1),1);
I_tr = I_3;
if evalin('base','zef.inv_scale') == 1
r_alpha_aux = (reconstruction-min(reconstruction))/(max(reconstruction)-min(reconstruction));
else
r_alpha_aux = abs(reconstruction)/max(abs(reconstruction));
end
r_alpha_aux= max(0,r_alpha_aux-min(r_alpha_aux));
r_alpha_aux = r_alpha_aux/max(r_alpha_aux);
f_alpha_aux(surface_triangles(I_tr,1)) = r_alpha_aux/3;
f_alpha_aux(surface_triangles(I_tr,2)) = f_alpha_aux(surface_triangles(I_tr,2)) + r_alpha_aux/3;
f_alpha_aux(surface_triangles(I_tr,3)) = f_alpha_aux(surface_triangles(I_tr,3)) + r_alpha_aux/3;
if evalin('base','zef.use_parcellation')
if evalin('base','zef.inv_colormap') == 13
set(h_surf_2,'FaceVertexAlpha',p_rec_aux);
else
set(h_surf_2,'FaceVertexAlpha',max(p_rec_aux,f_alpha_aux));
end
else
set(h_surf_2,'FaceVertexAlpha',max(evalin('base','zef.brain_transparency'),f_alpha_aux));
end
set(h_surf_2,'FaceAlpha','interp');
set(h_surf_2,'AlphaDataMapping','none');
end

if ismember(evalin('base','zef.visualization_type'),[2])
h_colorbar = colorbar('EastOutside','Position',colorbar_position);
set(h_colorbar,'Tag','rightColorbar');
end
%set(h_colorbar,'layer','bottom');
lighting phong;
end

%**************************************************************************

for i = 1 : n_compartments

if visible_vec(i)
I_2 = find(johtavuus(aux_ind) == i);
I_3 = find(ismember(tetra_ind,I_2));
% I = sub2ind(size(tetra),repmat(tetra_ind(I_3),1,3),ind_m(face_ind(I_3),:));
% surface_triangles = tetra(I);
color_str = color_cell{i};
if not(isempty(I_3))

[min_n_aux, min_t_aux] = zef_minimal_mesh(nodes,surface_triangles(I_3,:));
h_surf = trimesh(min_t_aux,min_n_aux(:,1),min_n_aux(:,2),min_n_aux(:,3),'edgecolor','none','facecolor',color_str,'facelighting','flat');
set(h_surf,'Tag','surface')
%set(h_surf,'specularstrength',0.1);
%set(h_surf,'diffusestrength',0.5);
%set(h_surf,'ambientstrength',0.85);
if not(ismember(evalin('base','zef.visualization_type'),[2,4])) || not(ismember(i,aux_brain_ind))
set(h_surf,'facealpha',evalin('base','zef.layer_transparency'));
end
lighting phong;
end
end
end

if loop_count == 1
view(evalin('base','zef.azimuth'),evalin('base','zef.elevation'));
axis('image');
end
camva(evalin('base','zef.cam_va'));

if not(isempty(h_axes_text))
delete(h_axes_text);
h_axes_text = [];
end

 if evalin('base','zef.visualization_type') == 2
  h_axes_text = axes('position',[0.0325 0.95 0.5 0.05],'visible','off');
  set(h_axes_text,'tag','image_details');
  h_text = text(0, 0.5, ['Time: ' num2str(evalin('base','zef.inv_time_1') + evalin('base','zef.inv_time_2')/2 + frame_step*(f_ind - 1)*evalin('base','zef.inv_time_3'),'%0.6f') ' s, Frame: ' num2str(f_ind) ' / ' num2str(length_reconstruction_cell) '.']);
  set(h_text,'visible','on');
  set(h_axes_text,'layer','bottom');
end
if evalin('base','zef.axes_visible')
set(evalin('base','zef.h_axes1'),'visible','on');
set(evalin('base','zef.h_axes1'),'xGrid','on');
set(evalin('base','zef.h_axes1'),'yGrid','on');
set(evalin('base','zef.h_axes1'),'zGrid','on');
else
set(evalin('base','zef.h_axes1'),'visible','off');
set(evalin('base','zef.h_axes1'),'xGrid','off');
set(evalin('base','zef.h_axes1'),'yGrid','off');
set(evalin('base','zef.h_axes1'),'zGrid','off');
end
%drawnow;
hold off;

end

        sensor_patches = findobj(evalin('base','zef.h_axes1'),'Type','Patch','Tag','sensor');
        uistack(sensor_patches,'top');
zef_plot_dpq('static');
zef_plot_dpq('dynamical');
        zef_set_sliders_plot(1);

%&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&
%&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&

for f_ind = frame_start + frame_step : frame_step : frame_stop
              evalin('base',['zef.h_slider.Value=' num2str(f_ind*frame_step/(frame_stop-frame_start+frame_step)) ';']);
pause(0.01);
stop_movie = evalin('base','zef.stop_movie');
pause(0.01);
if stop_movie
    if get(evalin('base','zef.h_pause_movie'),'value') == 1
    waitfor(evalin('base','zef.h_pause_movie'),'value');
    else
return;
    end
end

f_ind_aux = f_ind_aux + 1;
%if  iscell(volumetric_distribution) & evalin('base','zef.visualization_type') == 2
%waitbar(f_ind_aux/number_of_frames,h_waitbar,['Frame ' int2str(f_ind_aux) ' of ' int2str(number_of_frames) '.']);
%set(h_waitbar,'handlevisibility','off');
%end
%delete(h_text);
%delete(h_surf_2);
axes(evalin('base','zef.h_axes1'));
hold on;

if iscell(volumetric_distribution)
reconstruction = single(volumetric_distribution{f_ind});
else
reconstruction = volumetric_distribution;
end
reconstruction = reconstruction(:);
reconstruction = reshape(reconstruction,3,length(reconstruction)/3);

if ismember(evalin('base','zef.reconstruction_type'),[1 7])
reconstruction = sqrt(sum(reconstruction.^2))';
elseif evalin('base','zef.reconstruction_type') == 6
reconstruction = (1/sqrt(3))*sum(reconstruction)';
end
if ismember(evalin('base','zef.reconstruction_type'), [1 6 7])
reconstruction = sum(reconstruction(s_i_ind),2)/size(s_i_ind,2);
reconstruction = reconstruction(I_2_b_rec);
reconstruction = reconstruction(I_2_rec(I_1_rec));
end

if ismember(evalin('base','zef.reconstruction_type'), [2 3 4 5])
rec_x = reconstruction(1,:)';
rec_y = reconstruction(2,:)';
rec_z = reconstruction(3,:)';
rec_x = sum(rec_x(s_i_ind),2)/size(s_i_ind,2);
rec_y = sum(rec_y(s_i_ind),2)/size(s_i_ind,2);
rec_z = sum(rec_z(s_i_ind),2)/size(s_i_ind,2);
rec_x = rec_x(I_2_b_rec);
rec_y = rec_y(I_2_b_rec);
rec_z = rec_z(I_2_b_rec);
rec_x = rec_x(I_2_rec(I_1_rec));
rec_y = rec_y(I_2_rec(I_1_rec));
rec_z = rec_z(I_2_rec(I_1_rec));
end

if ismember(evalin('base','zef.reconstruction_type'), [2 3 4 5])
reconstruction = sqrt((rec_x.*n_vec_aux(:,1)).^2 + (rec_y.*n_vec_aux(:,2)).^2 + (rec_z.*n_vec_aux(:,3)).^2);
end

if evalin('base','zef.reconstruction_type') == 3
reconstruction = sqrt((rec_x - rec_x.*abs(n_vec_aux(:,1))).^2 + (rec_y - rec_y.*abs(n_vec_aux(:,2))).^2 + (rec_z - rec_z.*abs(n_vec_aux(:,3))).^2);
end

if evalin('base','zef.reconstruction_type') == 4
aux_rec = rec_x.*n_vec_aux(:,1) + rec_y.*n_vec_aux(:,2) + rec_z.*n_vec_aux(:,3);
I_aux_rec = find(aux_rec > 0);
reconstruction(I_aux_rec) = 0;
%reconstruction = reconstruction./max(abs(reconstruction(:)));
end

if evalin('base','zef.reconstruction_type') == 5
aux_rec = rec_x.*n_vec_aux(:,1) + rec_y.*n_vec_aux(:,2) + rec_z.*n_vec_aux(:,3);
I_aux_rec = find(aux_rec <= 0);
reconstruction(I_aux_rec) = 0;
%reconstruction = reconstruction./max(abs(reconstruction(:)));
end

if ismember(evalin('base','zef.reconstruction_type'), [2 3 4 5 7])
reconstruction = smooth_field(surface_triangles(I_3_rec,:), reconstruction, size(nodes,1),3);
end

if not(ismember(evalin('base','zef.reconstruction_type'), [6]))
if evalin('base','zef.inv_scale') == 1
reconstruction = -min_rec_log10 + 20*log10(max(reconstruction,max_abs_reconstruction/evalin('base','zef.inv_dynamic_range')));
elseif evalin('base','zef.inv_scale') == 2
reconstruction = (max(reconstruction,max_abs_reconstruction/evalin('base','zef.inv_dynamic_range')));
elseif evalin('base','zef.inv_scale') == 3
reconstruction = sqrt(max(reconstruction,max_abs_reconstruction/evalin('base','zef.inv_dynamic_range')));
end
end

if evalin('base','zef.use_parcellation')

if evalin('base','zef.parcellation_type') > 1
rec_aux = zeros(size(reconstruction));
if evalin('base','zef.parcellation_type') == 2
for p_ind = selected_list
rec_aux(p_cell{p_ind+1}) = quantile(reconstruction(p_cell{p_ind+1}),evalin('base','zef.parcellation_quantile'));
end
elseif evalin('base','zef.parcellation_type') == 3
for p_ind = selected_list
rec_aux(p_cell{p_ind+1}) = quantile(sqrt(reconstruction(p_cell{p_ind+1})),evalin('base','zef.parcellation_quantile'));
end
elseif evalin('base','zef.parcellation_type') == 4
for p_ind = selected_list
rec_aux(p_cell{p_ind+1}) = quantile((reconstruction(p_cell{p_ind+1})).^(1/3),evalin('base','zef.parcellation_quantile'));
end
elseif evalin('base','zef.parcellation_type') == 5
for p_ind = selected_list
rec_aux(p_cell{p_ind+1}) = mean(reconstruction(p_cell{p_ind+1}));
end
end
reconstruction = rec_aux;
end

reconstruction = reconstruction.*reconstruction_p_2;
end

%h_surf_2 = trimesh(surface_triangles(I_3_rec,:),nodes(:,1),nodes(:,2),nodes(:,3),reconstruction);
set(h_surf_2,'CData',reconstruction);
if ismember(evalin('base','zef.volumetric_distribution_mode'),[1, 3])
zef_plot_cone_field(evalin('base','zef.h_axes1'), f_ind);
end

%set(gca,'CLim',[min_rec max_rec]);
%set(h_surf_2,'edgecolor','none','facecolor','flat','facelighting','flat','CDataMapping','scaled');
%set(gca,'CLim',[min_rec max_rec]);
%set(h_surf_2,'specularstrength',0.2);
%set(h_surf_2,'specularexponent',0.8);
%set(h_surf_2,'SpecularColorReflectance',0.8);
%set(h_surf_2,'diffusestrength',1);
%set(h_surf_2,'ambientstrength',1);
if evalin('base','zef.brain_transparency') < 1 || evalin('base','zef.use_parcellation')
f_alpha_aux = zeros(size(nodes,1),1);
if evalin('base','zef.inv_scale') == 1
r_alpha_aux = (reconstruction-min(reconstruction))/(max(reconstruction)-min(reconstruction));
else
r_alpha_aux = abs(reconstruction)/max(abs(reconstruction));
end
r_alpha_aux= max(0,r_alpha_aux-min(r_alpha_aux));
r_alpha_aux = r_alpha_aux/max(r_alpha_aux);
f_alpha_aux(surface_triangles(I_tr,1)) = r_alpha_aux/3;
f_alpha_aux(surface_triangles(I_tr,2)) = f_alpha_aux(surface_triangles(I_tr,2)) + r_alpha_aux/3;
f_alpha_aux(surface_triangles(I_tr,3)) = f_alpha_aux(surface_triangles(I_tr,3)) + r_alpha_aux/3;
if evalin('base','zef.use_parcellation')
if evalin('base','zef.inv_colormap') == 13
set(h_surf_2,'FaceVertexAlpha',p_rec_aux);
else
set(h_surf_2,'FaceVertexAlpha',max(p_rec_aux,f_alpha_aux));
end
else
set(h_surf_2,'FaceVertexAlpha',max(evalin('base','zef.brain_transparency'),f_alpha_aux));
end
set(h_surf_2,'FaceAlpha','interp');
set(h_surf_2,'AlphaDataMapping','none');
end
zef_plot_dpq('dynamical');
zef_set_sliders_plot(2);
camorbit(frame_step*evalin('base','zef.orbit_1')/movie_fps,frame_step*evalin('base','zef.orbit_2')/movie_fps);

  axes(h_axes_text);% = axes('position',[0.0325 0.95 0.5 0.05],'visible','off');
  %set(h_axes_text,'tag','image_details');
  set(h_text, 'string', ['Time: ' num2str(evalin('base','zef.inv_time_1') + evalin('base','zef.inv_time_2')/2 + frame_step*(f_ind - 1)*evalin('base','zef.inv_time_3'),'%0.6f') ' s, Frame: ' num2str(f_ind) ' / ' num2str(length_reconstruction_cell) '.']);
  set(h_text,'visible','on');
  set(h_axes_text,'layer','bottom');
  drawnow limitrate;
  %drawnow;

end

if iscell(volumetric_distribution) && evalin('base','zef.visualization_type') == 2
loop_movie = evalin('base','zef.loop_movie');
else
loop_movie = 0;
end

hold off;

end

%&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&
%&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&

rotate3d on;

%if  iscell(volumetric_distribution) &  evalin('base','zef.visualization_type') == 2
%close(h_waitbar);
%end

