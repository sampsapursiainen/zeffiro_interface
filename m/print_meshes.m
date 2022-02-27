%Copyright © 2018- Sampsa Pursiainen & ZI Development Team
%See: https://github.com/sampsapursiainen/zeffiro_interface
function [void] = print_meshes(void);

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

void = [];

sensors_point_like = [];

length_reconstruction_cell = 1;

aux_wm_ind = -1;

movie_fps = evalin('base','zef.movie_fps');

sensor_tag = evalin('base','zef.current_sensors');
compartment_tags = evalin('base','zef.compartment_tags');

number_of_frames = evalin('base','zef.number_of_frames');
file_index = evalin('base','zef.file_index');
file_name = evalin('base','zef.file');
file_path = evalin('base','zef.file_path');
snapshot_resolution = round([evalin('base','zef.snapshot_vertical_resolution') evalin('base','zef.snapshot_horizontal_resolution')]);

c_va = camva(evalin('base','zef.h_axes1'));
c_pos = campos(evalin('base','zef.h_axes1'));
c_ta = camtarget(evalin('base','zef.h_axes1'));
c_p = camproj(evalin('base','zef.h_axes1'));
c_u = camup(evalin('base','zef.h_axes1'));

if ismember(evalin('base','zef.on_screen'), [0,1]) && not(evalin('base','zef.visualization_type')==3)

h_axes_text = [];
h_fig_aux = figure;set(h_fig_aux,'visible','on');
clf;
set(h_fig_aux,'renderer','opengl');
set(h_fig_aux,'paperunits','inches');
set(h_fig_aux,'papersize',snapshot_resolution);
set(h_fig_aux,'paperposition',[0 0 fliplr(snapshot_resolution)]);
%light('Position',[0 0 1],'Style','infinite');
%light('Position',[0 0 -1],'Style','infinite');
if not(evalin('base','zef.axes_visible'))
h_axes_image = axes('visible','off');
set(h_axes_image,'Tag','axes1');
else
h_axes_image = axes;
end
hold on;

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

if iscell(volumetric_distribution)
length_reconstruction_cell = length(volumetric_distribution);
else
length_reconstruction_cell = 1;
end
frame_start = evalin('base','zef.frame_start');
frame_stop = evalin('base','zef.frame_stop');
frame_step = evalin('base','zef.frame_step');
frame_step = max(frame_step,1);
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
if length([frame_start : frame_step : frame_stop]) > 1
is_video = 1;
else
is_video = 0;
end

if iscell(volumetric_distribution) &  evalin('base','zef.visualization_type') == 2 & is_video & file_index == 4
avi_file_temp = [file_path file_name(1:end-4) '_temp.avi'];
avi_file = [file_path file_name];
video_quality = str2num(evalin('base','zef.video_codec'));
h_aviobj = VideoWriter(avi_file_temp);
h_aviobj.Quality = video_quality;
open(h_aviobj);
end

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
set(h_text,'FontSize',1500);
end
set(h,'facecolor',sensors_color_table(i,:));
%April 2021
set(h,'edgecolor','none');
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
set(h_text,'FontSize',1500);
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
set(h,'facecolor',evalin('base',['zef.' sensor_tag 'color']));
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
submesh_cell = cell(0);
for k = 1 : length(compartment_tags)
        var_0 = ['zef.'  compartment_tags{k} '_on'];
        var_1 = ['zef.' compartment_tags{k} '_sigma'];
        var_2 = ['zef.' compartment_tags{k} '_priority'];
        var_3 = ['zef.' compartment_tags{k} '_visible'];
        var_4 = ['zef.' compartment_tags{k} '_submesh_ind'];
    color_str = evalin('base',['zef.' compartment_tags{k} '_color']);
on_val = evalin('base',var_0);
sigma_val = evalin('base',var_1);
priority_val = evalin('base',var_2);
visible_val = evalin('base',var_3);
submesh_ind = evalin('base',var_4);
if on_val
i = i + 1;
sigma_vec(i,1) = sigma_val;
priority_vec(i,1) = priority_val;
color_cell{i} = color_str;
visible_vec(i,1) = i*visible_val;
submesh_cell{i} = submesh_ind;
if evalin('base',['zef.' compartment_tags{k} '_sources']);
    aux_brain_ind = [aux_brain_ind i];
end
end
end

johtavuus = evalin('base','zef.sigma');
johtavuus = johtavuus(:,2);

I = find(ismember(johtavuus,visible_vec));
johtavuus = johtavuus(I);
tetra = evalin('base','zef.tetra');

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

tetra_sort = [tetra(:,[2 3 4]) ones(size(tetra,1),1) [1:size(tetra,1)]';
              tetra(:,[1 4 3]) 2*ones(size(tetra,1),1) [1:size(tetra,1)]';
              tetra(:,[1 2 4]) 3*ones(size(tetra,1),1) [1:size(tetra,1)]';
              tetra(:,[1 3 2]) 4*ones(size(tetra,1),1) [1:size(tetra,1)]';];
tetra_sort(:,1:3) = sort(tetra_sort(:,1:3),2);

if evalin('base','zef.use_gpu_graphic') == 1 & evalin('base','zef.use_gpu') == 1 & gpuDeviceCount > 0
tetra_sort = gpuArray(uint32(tetra_sort));
tetra_sort = gather(sortrows(tetra_sort,[1 2 3]));
else
tetra_sort = sortrows(tetra_sort,[1 2 3]);
end
tetra_ind = zeros(size(tetra_sort,1),1);
I = find(sum(abs(tetra_sort(2:end,1:3)-tetra_sort(1:end-1,1:3)),2)==0);
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
reconstruction = volumetric_distribution{f_ind};
reconstruction = reconstruction(:);
reconstruction = reshape(reconstruction,3,length(reconstruction)/3);
if ismember(evalin('base','zef.reconstruction_type'), 6)
reconstruction = (1/sqrt(3))*sum(reconstruction)';
else
reconstruction = sqrt(sum(reconstruction.^2))';
end
reconstruction = sum(reconstruction(s_i_ind),2)/4;
max_abs_reconstruction = max([max_abs_reconstruction ; (reconstruction(:))]);
min_rec = min([min_rec ; (reconstruction(:))]);
max_rec = max_abs_reconstruction;
end
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
reconstruction = sum(reconstruction(s_i_ind),2)/4;
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

if ismember(evalin('base','zef.visualization_type'),[2])
if  iscell(volumetric_distribution) & evalin('base','zef.visualization_type') == 2
h_waitbar = waitbar(1/number_of_frames,['Frame ' int2str(1) ' of ' int2str(number_of_frames) '.']);
set(h_waitbar,'handlevisibility','off');
end
end

f_ind_aux = 1;
for f_ind = frame_start : frame_start
if  iscell(volumetric_distribution) & evalin('base','zef.visualization_type') == 2
waitbar(f_ind_aux/number_of_frames,h_waitbar,['Frame ' int2str(f_ind_aux) ' of ' int2str(number_of_frames) '.']);
set(h_waitbar,'handlevisibility','off');
end
%axes(evalin('base','zef.h_axes1'));
%if not(isempty(h_colorbar))
%colorbar(h_colorbar,'delete');
%h_colorbar = [];
%end
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

%******************************************************
if iscell(volumetric_distribution)
reconstruction = evalin('base',['zef.reconstruction{' int2str(frame_start) '}']);
else
reconstruction = volumetric_distribution;
end
reconstruction = reconstruction(:);
reconstruction = reshape(reconstruction,3,length(reconstruction)/3);
reconstruction = sqrt(sum(reconstruction.^2))';
reconstruction = sum(reconstruction(s_i_ind),2)/4;
if evalin('base','zef.inv_scale') == 1
reconstruction = -min_rec_log10 + 20*log10(max(reconstruction,max_abs_reconstruction/evalin('base','zef.inv_dynamic_range')));
elseif evalin('base','zef.inv_scale') == 2
reconstruction = (max(reconstruction,max_abs_reconstruction/evalin('base','zef.inv_dynamic_range')));
elseif evalin('base','zef.inv_scale') == 3
reconstruction = sqrt(max(reconstruction,max_abs_reconstruction/evalin('base','zef.inv_dynamic_range')));
end
[a_hist, b_hist] = hist(reconstruction,min_rec:(max_rec-min_rec)/50:max_rec - (max_rec - min_rec)/50);
a_hist = max(0,real(log10(a_hist)));
length_reconstruction = length(reconstruction);
%******************************************************

%******************************************************
if iscell(volumetric_distribution)
reconstruction = evalin('base',['zef.reconstruction{' int2str(frame_start) '}']);
else
reconstruction = volumetric_distribution;
end
reconstruction = reconstruction(:);
reconstruction = reshape(reconstruction,3,length(reconstruction)/3);
reconstruction = sqrt(sum(reconstruction.^2))';
reconstruction = sum(reconstruction(s_i_ind),2)/4;
if evalin('base','zef.inv_scale') == 1
reconstruction = -min_rec_log10 + 20*log10(max(reconstruction,max_abs_reconstruction/evalin('base','zef.inv_dynamic_range')));
elseif evalin('base','zef.inv_scale') == 2
reconstruction = (max(reconstruction,max_abs_reconstruction/evalin('base','zef.inv_dynamic_range')));
elseif evalin('base','zef.inv_scale') == 3
reconstruction = sqrt(max(reconstruction,max_abs_reconstruction/evalin('base','zef.inv_dynamic_range')));
end
[a_hist, b_hist] = hist(reconstruction,min_rec:(max_rec-min_rec)/50:max_rec - (max_rec - min_rec)/50);
a_hist = max(0,real(log10(a_hist)));
length_reconstruction = length(reconstruction);
%******************************************************

if iscell(volumetric_distribution)
reconstruction = volumetric_distribution{f_ind};
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
reconstruction = sum(reconstruction(s_i_ind),2)/4;
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
rec_x = sum(rec_x(s_i_ind),2)/4;
rec_y = sum(rec_y(s_i_ind),2)/4;
rec_z = sum(rec_z(s_i_ind),2)/4;
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
set(h_fig_aux,'colormap', evalin('base',[colormap_cell{evalin('base','zef.inv_colormap')} '(' num2str(colortune_param) ',' num2str(colormap_size) ')']));

axes(h_axes_image); set(h_fig_aux,'visible','on');
h_surf_2 = trimesh(surface_triangles(I_3,:),nodes(:,1),nodes(:,2),nodes(:,3),reconstruction);
set(h_surf_2,'Tag','sensor');
if ismember(evalin('base','zef.volumetric_distribution_mode'),[1, 3])
zef_plot_cone_field(h_axes_image, f_ind, 2);
end

set(h_surf_2,'edgecolor','none','facecolor','flat','facelighting','flat','CDataMapping','scaled');
set(h_axes_image,'CLim',[min_rec max_rec]);
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
h_colorbar = colorbar('EastOutside','Position',[0.92 0.647 0.01 0.29]);
set(h_colorbar,'Tag','rightColorbar');
h_colorbar_axes = get(h_colorbar,'axes');
set(h_colorbar_axes,'fontsize',1500);
end

lighting phong;

if evalin('base','zef.visualization_type') == 2
%h_colorbar = colorbar('EastOutside','Position',[0.94 0.675 0.01 0.29],'fontsize',1500);
h_axes_hist = axes('position',[0.03 0.035 0.2 0.1],'visible','off');
h_bar = bar(h_axes_hist,b_hist+(max_rec-min_rec)/(2*50),a_hist,'hist');
set(h_bar,'facecolor',[0.5 0.5 0.5]);
set(h_axes_hist,'ytick',[]);
hist_ylim =  [0 log10(length_reconstruction)];
set(h_axes_hist,'ylim',hist_ylim);
set(h_axes_hist,'fontsize',1500);
set(h_axes_hist,'xlim',[min_rec max_rec]);
set(h_axes_hist,'linewidth',200);
set(h_axes_hist,'ticklength',[0 0]);
end
end
axes(h_axes_image);set(h_fig_aux,'visible','on');

for i = 1 : n_compartments

if visible_vec(i)
I_2 = find(johtavuus(aux_ind) == i);
I_3 = find(ismember(tetra_ind,I_2));
color_str = color_cell{i};
if not(isempty(I_3))
[min_n_aux, min_t_aux] = zef_minimal_mesh(nodes,surface_triangles(I_3,:));
h_surf = trimesh(min_t_aux,min_n_aux(:,1),min_n_aux(:,2),min_n_aux(:,3),'edgecolor','none','facecolor',color_str,'facelighting','flat');
set(h_surf,'Tag','surface');
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

if iscell(volumetric_distribution) &  evalin('base','zef.visualization_type') == 2
view(evalin('base','zef.azimuth'),evalin('base','zef.elevation'));
else
view(get(evalin('base','zef.h_axes1'),'view'));
end

axis('image');
camva(evalin('base','zef.cam_va'));
if evalin('base','zef.axes_visible')
set(gca,'visible','on');
set(gca,'xGrid','on');
set(gca,'yGrid','on');
set(gca,'zGrid','on');
else
set(gca,'visible','off');
set(gca,'xGrid','off');
set(gca,'yGrid','off');
set(gca,'zGrid','off');
end

  if evalin('base','zef.visualization_type') == 2
  h_axes_text = axes('position',[0.03 0.94 0.01 0.05],'visible','off');
  h_text = text(0, 0.5, ['Time: ' num2str(evalin('base','zef.inv_time_1') + evalin('base','zef.inv_time_2')/2 + frame_step*(f_ind - 1)*evalin('base','zef.inv_time_3'),'%0.6f') ' s, Frame: ' num2str(f_ind) ' / ' num2str(length_reconstruction_cell) '.']);
  set(h_text,'visible','on','fontsize',1500);
  end

camva(c_va);
campos(c_pos);
camtarget(c_ta);
camproj(c_p);
camup(c_u);

sensor_patches = findobj(h_axes_image,'Type','Patch','Tag','sensor');
uistack(sensor_patches,'top');
zef_plot_dpq('static');
zef_plot_dpq('dynamical');
zef_set_sliders_print(1,h_axes_image);

%drawnow;

if iscell(volumetric_distribution) &  evalin('base','zef.visualization_type') == 2

  if is_video
  if file_index == 1;
  print(h_fig_aux,'-djpeg95','-r1',[file_path  file_name(1:end-4) '_' int2str(f_ind) file_name(end-3:end)]);
  elseif file_index ==2;
  print(h_fig_aux,'-dtiff','-r1',[file_path  file_name(1:end-4) '_' int2str(f_ind) file_name(end-3:end)]);
  elseif file_index ==3;
  print(h_fig_aux,'-dpng','-r1',[file_path  file_name(1:end-4) '_' int2str(f_ind) file_name(end-3:end)]);
  elseif file_index ==4;
  bmp_file_temp = [file_path  file_name(1:end-4) '_temp.bmp'];
  print(h_fig_aux,'-dbmp','-r1',bmp_file_temp);
  [movie_frame] = imread(bmp_file_temp,'bmp');
  h_frame = im2frame(movie_frame);
  writeVideo(h_aviobj,h_frame);
  delete(bmp_file_temp);
  end;
  else
  if file_index == 1;
  print(h_fig_aux,'-djpeg95','-r1',[file_path  file_name]);
  elseif file_index ==2;
  print(h_fig_aux,'-dtiff','-r1',[file_path  file_name]);
  elseif file_index==3;
  print(h_fig_aux,'-dpng','-r1',[file_path  file_name]);
  end;
  end;

else

if file_index == 1;
print(h_fig_aux,[file_path file_name],'-djpeg95','-r1');
elseif file_index ==2;
print(h_fig_aux,[file_path file_name],'-dtiff','-r1');
elseif file_index ==3;
print(h_fig_aux,[file_path file_name],'-dpng','-r1');
end;
end

end

%&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&
%&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&
tic;
for f_ind = frame_start + frame_step : frame_step : frame_stop
pause(1/30);
f_ind_aux = f_ind_aux + 1;
if  iscell(volumetric_distribution) & evalin('base','zef.visualization_type') == 2
waitbar(f_ind_aux/number_of_frames,h_waitbar,['Frame ' int2str(f_ind_aux) ' of ' int2str(number_of_frames) '.']);
set(h_waitbar,'handlevisibility','off');
end
delete(h_bar);
delete(h_text);
axes(h_axes_image);set(h_fig_aux,'visible','on');
delete(h_surf_2);
hold on;

%******************************************************
if iscell(volumetric_distribution)
reconstruction = volumetric_distribution{f_ind};
else
reconstruction = volumetric_distribution;
end
reconstruction = reconstruction(:);
reconstruction = reshape(reconstruction,3,length(reconstruction)/3);
reconstruction = sqrt(sum(reconstruction.^2))';
reconstruction = sum(reconstruction(s_i_ind),2)/4;
if evalin('base','zef.inv_scale') == 1
reconstruction = -min_rec_log10 + 20*log10(max(reconstruction,max_abs_reconstruction/evalin('base','zef.inv_dynamic_range')));
elseif evalin('base','zef.inv_scale') == 2
reconstruction = (max(reconstruction,max_abs_reconstruction/evalin('base','zef.inv_dynamic_range')));
elseif evalin('base','zef.inv_scale') == 3
reconstruction = sqrt(max(reconstruction,max_abs_reconstruction/evalin('base','zef.inv_dynamic_range')));
end
[a_hist, b_hist] = hist(reconstruction,min_rec:(max_rec-min_rec)/50:max_rec - (max_rec - min_rec)/50);
a_hist = max(0,real(log10(a_hist)));
length_reconstruction = length(reconstruction);
%******************************************************

if iscell(volumetric_distribution)
reconstruction = volumetric_distribution{f_ind};
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
reconstruction = sum(reconstruction(s_i_ind),2)/4;
reconstruction = reconstruction(I_2_b_rec);
reconstruction = reconstruction(I_2_rec(I_1_rec));
end

if ismember(evalin('base','zef.reconstruction_type'), [2 3 4 5])
rec_x = reconstruction(1,:)';
rec_y = reconstruction(2,:)';
rec_z = reconstruction(3,:)';
rec_x = sum(rec_x(s_i_ind),2)/4;
rec_y = sum(rec_y(s_i_ind),2)/4;
rec_z = sum(rec_z(s_i_ind),2)/4;
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

h_surf_2 = trimesh(surface_triangles(I_3,:),nodes(:,1),nodes(:,2),nodes(:,3),reconstruction);
set(h_surf_2,'Tag','reconstruction');
if ismember(evalin('base','zef.volumetric_distribution_mode'),[1, 3])
zef_plot_cone_field(h_axes_image, f_ind, 2);
end

set(h_surf_2,'edgecolor','none','facecolor','flat','facelighting','flat','CDataMapping','scaled');
set(gca,'CLim',[min_rec max_rec]);
%set(h_surf_2,'specularstrength',0.2);
%set(h_surf_2,'specularexponent',0.8);
%set(h_surf_2,'SpecularColorReflectance',0.8);
%set(h_surf_2,'diffusestrength',1);
%set(h_surf_2,'ambientstrength',1);
if evalin('base','zef.brain_transparency') < 1 || evalin('base','zef.use_parcellation')
%f_alpha_aux = zeros(size(nodes,1),1);
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
zef_set_sliders_print(1,h_axes_image);
camorbit(frame_step*evalin('base','zef.orbit_1')/movie_fps,frame_step*evalin('base','zef.orbit_2')/movie_fps);

if evalin('base','zef.visualization_type') == 2
h_bar = bar(h_axes_hist,b_hist+(max_rec-min_rec)/(2*50),a_hist,'hist');
set(h_bar,'facecolor',[0.5 0.5 0.5]);
set(h_axes_hist,'ytick',[]);
hist_ylim =  [0 log10(length_reconstruction)];
set(h_axes_hist,'ylim',hist_ylim);
set(h_axes_hist,'fontsize',1500);
set(h_axes_hist,'xlim',[min_rec max_rec]);
set(h_axes_hist,'linewidth',200);
set(h_axes_hist,'ticklength',[0 0]);

  axes(h_axes_text);set(h_fig_aux,'visible','on');
  h_text = text(0, 0.5, ['Time: ' num2str(evalin('base','zef.inv_time_1') + evalin('base','zef.inv_time_2')/2 + frame_step*(f_ind - 1)*evalin('base','zef.inv_time_3'),'%0.6f') ' s, Frame: ' num2str(f_ind) ' / ' num2str(length_reconstruction_cell) '.']);
  set(h_text,'visible','on','fontsize',1500);

end

  if file_index == 1;
  print(h_fig_aux,'-djpeg95','-r1',[file_path  file_name(1:end-4) '_' int2str(f_ind) file_name(end-3:end)]);
  elseif file_index ==2;
  print(h_fig_aux,'-dtiff','-r1',[file_path  file_name(1:end-4) '_' int2str(f_ind) file_name(end-3:end)]);
  elseif file_index ==3;
  print(h_fig_aux,'-dpng','-r1',[file_path  file_name(1:end-4) '_' int2str(f_ind) file_name(end-3:end)]);
  elseif file_index == 4;
  print(h_fig_aux,'-dbmp','-r1',bmp_file_temp);
  [movie_frame] = imread(bmp_file_temp,'bmp');
  h_frame = im2frame(movie_frame);
  writeVideo(h_aviobj,h_frame);
  delete(bmp_file_temp);
  end;

end

%&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&
%&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&

if iscell(volumetric_distribution) &  evalin('base','zef.visualization_type') == 2 & is_video & file_index == 4
close(h_aviobj);
warning off; delete('avi_file'); warning on
movefile(avi_file_temp, avi_file, 'f');
end
close(h_fig_aux);
if  iscell(volumetric_distribution) &  evalin('base','zef.visualization_type') == 2
close(h_waitbar);
end
%**************************************************************************
%**************************************************************************
%**************************************************************************
%**************************************************************************
%**************************************************************************
%**************************************************************************
%**************************************************************************

else

if ismember(evalin('base','zef.visualization_type'),[3,4])
if iscell(volumetric_distribution)
length_reconstruction_cell = length(volumetric_distribution);
else
length_reconstruction_cell = 1;
end
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
if length([frame_start : frame_step : frame_stop]) > 1
is_video = 1;
else
is_video = 0;
end
end

if ismember(evalin('base','zef.visualization_type'),[5])
if iscell(evalin('base','zef.top_reconstruction'))
length_reconstruction_cell = length(evalin('base','zef.top_reconstruction'));
else
length_reconstruction_cell = 1;
end
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
if length([frame_start : frame_step : frame_stop]) > 1
is_video = 1;
else
is_video = 0;
end
end

if iscell(volumetric_distribution) &  evalin('base','zef.visualization_type') == 3 & is_video & file_index == 4
avi_file_temp = [file_path file_name(1:end-4) '_temp.avi'];
avi_file = [file_path file_name];
video_quality = str2num(evalin('base','zef.video_codec'));
h_aviobj = VideoWriter(avi_file_temp);
h_aviobj.Quality = video_quality;
h_aviobj.FrameRate = movie_fps;
open(h_aviobj);
end

if iscell(evalin('base','zef.top_reconstruction')) &  evalin('base','zef.visualization_type') == 5 & is_video & file_index == 4
avi_file_temp = [file_path file_name(1:end-4) '_temp.avi'];
avi_file = [file_path file_name];
video_quality = str2num(evalin('base','zef.video_codec'));
h_aviobj = VideoWriter(avi_file_temp);
h_aviobj.Quality = video_quality;
h_aviobj.FrameRate = movie_fps;
open(h_aviobj);
end

submesh_num = evalin('base','zef.submesh_num');

if ismember(evalin('base','zef.visualization_type'), [3,4])
    s_i_ind = evalin('base','zef.source_interpolation_ind{2}');
        if ismember(evalin('base','zef.volumetric_distribution_mode'), [1,3])
s_i_ind_2 = evalin('base','zef.source_interpolation_ind{1}');
    elseif ismember(evalin('base','zef.volumetric_distribution_mode'), [2,4])
    s_i_ind_2 = evalin('base','zef.brain_ind');
        end
end

if evalin('base','zef.use_parcellation')
selected_list = evalin('base','zef.parcellation_selected');
p_i_ind = evalin('base','zef.parcellation_interp_ind');
end

if ismember(evalin('base','zef.visualization_type'),[3])
max_abs_reconstruction = 0;
min_rec = Inf;
max_rec = -Inf;
if iscell(volumetric_distribution)
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
reconstruction = sum(reconstruction(s_i_ind_2),2)/4;
max_abs_reconstruction = max([max_abs_reconstruction ; (reconstruction(:))]);
min_rec = min([min_rec ; (reconstruction(:))]);
max_rec = max_abs_reconstruction;
end
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
else
frame_start = 1;
frame_stop = 1;
frame_step = 1;
number_of_frames = 1;
reconstruction = volumetric_distribution;
reconstruction = reconstruction(:);
reconstruction = reshape(reconstruction,3,length(reconstruction)/3);
if ismember(evalin('base','zef.reconstruction_type'), 6)
reconstruction = (1/sqrt(3))*sum(reconstruction)';
else
reconstruction = sqrt(sum(reconstruction.^2))';
end
reconstruction = sum(reconstruction(s_i_ind_2),2)/4;
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
end

if ismember(evalin('base','zef.visualization_type'),[5])
max_abs_reconstruction = 0;
min_rec = Inf;
max_rec = -Inf;
if iscell(evalin('base','zef.top_reconstruction'))
length_reconstruction_cell = length(evalin('base','zef.top_reconstruction'));
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
reconstruction = single(evalin('base',['zef.top_reconstruction{' int2str(f_ind) '}']));
reconstruction = reconstruction(:);
max_abs_reconstruction = max([max_abs_reconstruction ; (reconstruction(:))]);
min_rec = min([min_rec ; (reconstruction(:))]);
max_rec = max_abs_reconstruction;
end
else
frame_start = 1;
frame_stop = 1;
frame_step = 1;
number_of_frames = 1;
reconstruction = evalin('base','zef.top_reconstruction');
reconstruction = reconstruction(:);
max_abs_reconstruction = max([max_abs_reconstruction ; (reconstruction(:))]);
min_rec = min([min_rec ; (reconstruction(:))]);
max_rec = max_abs_reconstruction;
end
end

cb_done = 0;
i = 0;
length_reuna = 0;
sigma_vec = [];
priority_vec = [];
visible_vec = [];
color_cell = cell(0);
aux_brain_ind = [];
aux_dir_mode = [];
submesh_cell = cell(0);
for k = 1 : length(compartment_tags)
        var_0 = ['zef.'  compartment_tags{k} '_on'];
        var_1 = ['zef.' compartment_tags{k} '_sigma'];
        var_2 = ['zef.' compartment_tags{k} '_priority'];
        var_3 = ['zef.' compartment_tags{k} '_visible'];
        var_4 = ['zef.' compartment_tags{k} '_submesh_ind'];
    color_str = evalin('base',['zef.' compartment_tags{k} '_color']);
on_val = evalin('base',var_0);
sigma_val = evalin('base',var_1);
priority_val = evalin('base',var_2);
visible_val = evalin('base',var_3);
submesh_ind = evalin('base',var_4);
if on_val
i = i + 1;
sigma_vec(i,1) = sigma_val;
priority_vec(i,1) = priority_val;
color_cell{i} = color_str;
visible_vec(i,1) = i*visible_val;
submesh_cell{i} = submesh_ind;
if evalin('base',['zef.' compartment_tags{k} '_sources']);
    aux_brain_ind = [aux_brain_ind i];
end
end
end

snapshot_resolution = round([evalin('base','zef.snapshot_vertical_resolution') evalin('base','zef.snapshot_horizontal_resolution')]);

h_fig_aux = figure;set(h_fig_aux,'visible','on');
clf;
set(h_fig_aux,'renderer','opengl');
set(h_fig_aux,'paperunits','inches');
set(h_fig_aux,'papersize',snapshot_resolution);
set(h_fig_aux,'paperposition',[0 0 fliplr(snapshot_resolution)]);
light('Position',[0 0 1],'Style','infinite');
light('Position',[0 0 -1],'Style','infinite');
h_axes_image = get(h_fig_aux,'currentaxes');
set(h_axes_image,'Tag','axes1');
hold on;
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
reuna_p_inf = evalin('base','zef.reuna_p_inf');
reuna_p = evalin('base','zef.reuna_p');
reuna_t = evalin('base','zef.reuna_t');
if evalin('base','zef.cp_on') || evalin('base','zef.cp2_on') || evalin('base','zef.cp3_on')
    for i = 1 : length(reuna_t)
        reuna_t{i} = uint32(reuna_t{i});
triangle_c{i} = (1/3)*(reuna_p{i}(reuna_t{i}(:,1),:) + reuna_p{i}(reuna_t{i}(:,2),:) + reuna_p{i}(reuna_t{i}(:,3),:));
    end
end

aux_ind_1 = [];
aux_ind_2 = cell(1,length(reuna_t));
if submesh_num > 0
    for i = 1 : length(reuna_t)
    if submesh_num <= length(submesh_cell{i})
        if submesh_num == 1
        aux_ind_2{i} = [1:submesh_cell{i}(submesh_num)]';
        else
        aux_ind_2{i} = [submesh_cell{i}(submesh_num-1)+1:submesh_cell{i}(submesh_num)]';
    end
    end
    end
end

clipped = 0;

if evalin('base','zef.cp_on')
cp_a = evalin('base','zef.cp_a');
cp_b = evalin('base','zef.cp_b');
cp_c = evalin('base','zef.cp_c');
cp_d = evalin('base','zef.cp_d');

clipping_plane = {cp_a,cp_b,cp_c,cp_d};
% if cp_a ~= 0 | cp_b ~=0
% light('Position',[-cp_a -cp_b -cp_b],'Style','infinite');
% end
if clipped
aux_ind_1 = zef_clipping_plane(sensors(:,1:3),clipping_plane,aux_ind_1);
else
aux_ind_1 = zef_clipping_plane(sensors(:,1:3),clipping_plane);
end
for i = 1 : length(reuna_t)
    if clipped
aux_ind_2{i} = zef_clipping_plane(triangle_c{i},clipping_plane,aux_ind_2{i});
else
aux_ind_2{i} = zef_clipping_plane(tetra_c{i},clipping_plane);
    end
end
clipped = 1;
end

if evalin('base','zef.cp2_on')
cp2_a = evalin('base','zef.cp2_a');
cp2_b = evalin('base','zef.cp2_b');
cp2_c = evalin('base','zef.cp2_c');
cp2_d = evalin('base','zef.cp2_d');

clipping_plane = {cp2_a,cp2_b,cp2_c,cp2_d};
% if cp2_a ~= 0 | cp2_b ~=0
% light('Position',[-cp2_a -cp2_b -cp2_b],'Style','infinite');
% end
if clipped
aux_ind_1 = zef_clipping_plane(sensors(:,1:3),clipping_plane,aux_ind_1);
else
aux_ind_1 = zef_clipping_plane(sensors(:,1:3),clipping_plane);
end
for i = 1 : length(reuna_t)
    if clipped
aux_ind_2{i} = zef_clipping_plane(triangle_c{i},clipping_plane,aux_ind_2{i});
else
aux_ind_2{i} = zef_clipping_plane(tetra_c{i},clipping_plane);
    end
end
clipped = 1;
end

if evalin('base','zef.cp3_on')
cp3_a = evalin('base','zef.cp3_a');
cp3_b = evalin('base','zef.cp3_b');
cp3_c = evalin('base','zef.cp3_c');
cp3_d = evalin('base','zef.cp3_d');

clipping_plane = {cp3_a,cp3_b,cp3_c,cp3_d};
% if cp3_a ~= 0 | cp3_b ~=0
% light('Position',[-cp3_a -cp3_b -cp3_b],'Style','infinite');
% end
if clipped
aux_ind_1 = zef_clipping_plane(sensors(:,1:3),clipping_plane,aux_ind_1);
else
aux_ind_1 = zef_clipping_plane(sensors(:,1:3),clipping_plane);
end
for i = 1 : length(reuna_t)
    if clipped
aux_ind_2{i} = zef_clipping_plane(triangle_c{i},clipping_plane,aux_ind_2{i});
else
aux_ind_2{i} = zef_clipping_plane(tetra_c{i},clipping_plane);
    end
end
clipped = 1;
end

if evalin('base','zef.cp_on') || evalin('base','zef.cp2_on') || evalin('base','zef.cp3_on')
if evalin('base','zef.cp_mode') == 1
sensors = sensors(aux_ind_1,:);
if not(isempty(sensors_visible))
sensors_visible = sensors_visible(aux_ind_1,:);
end
sensors_color_table = sensors_color_table(aux_ind_1,:);
sensors_name = sensors_name(aux_ind_1);
elseif evalin('base','zef.cp_mode') == 2
aux_ind_1 = setdiff([1:size(sensors,1)]',aux_ind_1);
sensors = sensors(aux_ind_1,:);
if not(isempty(sensors_visible))
sensors_visible = sensors_visible(aux_ind_1,:);
end
sensors_color_table = sensors_color_table(aux_ind_1,:);
sensors_name = sensors_name(aux_ind_1);
end
for i = 1 : length(reuna_t)
if evalin('base','zef.cp_mode') == 1
reuna_t{i} = reuna_t{i}(aux_ind_2{i},:);
if ismember(evalin('base','zef.visualization_type'), [3,4])
if ismember(i, aux_brain_ind)
ab_ind = find(aux_brain_ind==i);
s_i_ind{ab_ind} = s_i_ind{ab_ind}(aux_ind_2{i},:);
if evalin('base','zef.use_parcellation')
for p_ind = selected_list
[aux_is_1, aux_is_2, aux_is_3] = intersect(p_i_ind{p_ind}{2}{ab_ind},aux_ind_2{i});
p_i_ind{p_ind}{2}{ab_ind}= aux_is_3;
end
end
end;
end
elseif evalin('base','zef.cp_mode') == 2
aux_ind_2{i} = setdiff([1:size(reuna_t{i},1)]',aux_ind_2{i});
reuna_t{i} = reuna_t{i}(aux_ind_2{i},:);
if ismember(evalin('base','zef.visualization_type'), [3,4])
if ismember(i, aux_brain_ind)
ab_ind = find(aux_brain_ind==i);
s_i_ind{ab_ind} = s_i_ind{ab_ind}(aux_ind_2{i},:);
if evalin('base','zef.use_parcellation')
for p_ind = selected_list
[aux_is_1, aux_is_2, aux_is_3] = intersect(p_i_ind{p_ind}{2}{ab_ind},aux_ind_2{i});
p_i_ind{p_ind}{2}{ab_ind}= aux_is_3;
end
end
end;
end
elseif evalin('base','zef.cp_mode') == 3
if ismember(i, aux_brain_ind)
aux_ind_2{i} = reuna_t{i};
else
reuna_t{i} = reuna_t{i}(aux_ind_2{i},:);
end
elseif evalin('base','zef.cp_mode') == 4
if ismember(i, aux_brain_ind)
aux_ind_2{i} = reuna_t{i};
else
aux_ind_2{i} = setdiff([1:size(reuna_t{i},1)]',aux_ind_2{i});
reuna_t{i} = reuna_t{i}(aux_ind_2{i},:);
end
end
end
elseif submesh_num > 0
for i = 1 : length(reuna_t)
    if not(isempty(aux_ind_2{i}))
reuna_t{i} = reuna_t{i}(aux_ind_2{i},:);
if ismember(evalin('base','zef.visualization_type'),[3 4])
if ismember(i, aux_brain_ind)
ab_ind = find(aux_brain_ind==i);
s_i_ind{ab_ind} = s_i_ind{ab_ind}(aux_ind_2{i},:);
if evalin('base','zef.use_parcellation')
for p_ind = selected_list
[aux_is_1, aux_is_2, aux_is_3] = intersect(p_i_ind{p_ind}{2}{ab_ind},aux_ind_2{i});
p_i_ind{p_ind}{2}{ab_ind} = aux_is_3;
end
end
end;
end
end
end
end

aux_ind_1 = [];
aux_ind_2 = cell(1,length(reuna_t));
triangle_c = cell(1,length(reuna_t));

if ismember(evalin('base','zef.imaging_method'), [1 4 5])  & size(sensors,2) == 6
    electrode_model = 2;
elseif ismember(evalin('base','zef.imaging_method'), [1 4 5])
    electrode_model = 1;
else
    electrode_model = 0;
end

%April 2021
if not(evalin('base','zef.attach_electrodes'))
    sensors_name_points = sensors(:,1:3);
end
%April 2021

if evalin('base','zef.attach_electrodes') & electrode_model == 1
sensors = attach_sensors_volume(sensors,'geometry');
elseif evalin('base','zef.attach_electrodes') & electrode_model == 2
  sensors_aux = attach_sensors_volume(sensors,'geometry');
  sensors_point_like_index = find(sensors_aux(:,4)==0);
  sensors_point_like = zeros(length(sensors_point_like_index),3);

%April 2021
sensors_name_points = attach_sensors_volume(sensors,'points');
sensors_point_like_id = find(sensors(:,4)==0);
%April 2021

for spl_ind = 1 : length(sensors_point_like_index)
if sensors_aux(sensors_point_like_index(spl_ind),2) == 0
sensors_point_like(spl_ind,:) = sensors(sensors_aux(sensors_point_like_index(spl_ind),1),1:3);
else
sensors_point_like(spl_ind,:) = reuna_p{end}(sensors_aux(sensors_point_like_index(spl_ind),2),:);
end
  end
sensors = sensors_aux;
sensors_patch_like_index = setdiff(1:size(sensors,1),sensors_point_like_index);
  sensors = sensors(sensors_patch_like_index,:);
else
    electrode_model = 1;
end

if evalin('base',['zef.' sensor_tag '_visible'])
if electrode_model == 1 | not(ismember(evalin('base','zef.imaging_method'),[1,4,5]))
for i = 1 : size(sensors,1)
h = surf(sensors(i,1) + X_s, sensors(i,2) + Y_s, sensors(i,3) + Z_s);
h.Tag = 'sensor';
%April 2021
if evalin('base',['zef.' evalin('base','zef.current_sensors') '_names_visible'])
h_text = text(sensors(i,1),sensors(i,2),sensors(i,3),sensors_name{i});
set(h_text,'FontSize',1500);
end
set(h,'facecolor',sensors_color_table(i,:));
%April 2021
set(h,'edgecolor','none');
%set(h,'specularstrength',0.3);
%set(h,'diffusestrength',0.7);
%set(h,'ambientstrength',0.7);
set(h,'facealpha',evalin('base','zef.layer_transparency'));
end
elseif electrode_model == 2
 %April 2021
if evalin('base',['zef.' evalin('base','zef.current_sensors') '_names_visible'])
for i = 1 : size(sensors_name_points,1)
h_text = text(sensors_name_points(i,1),sensors_name_points(i,2),sensors_name_points(i,3),sensors_name{i});
set(h_text,'FontSize',1500);
end
end
if not(isempty(sensors))
unique_sensors_aux_1 = unique(sensors(:,1));
h = zeros(length(unique_sensors_aux_1),1);
for i = 1 : length(unique_sensors_aux_1)
unique_sensors_aux_2 = find(sensors(:,1)==unique_sensors_aux_1(i));
[min_n_aux, min_t_aux] = zef_minimal_mesh(reuna_p{end},sensors(unique_sensors_aux_2,2:4));
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
%April 2021;
set(h,'edgecolor','none');
%set(h,'specularstrength',0.3);
%set(h,'diffusestrength',0.7);
%set(h,'ambientstrength',0.7);
set(h,'facealpha',evalin('base','zef.layer_transparency'));
end
end

if ismember(evalin('base','zef.imaging_method'),[2 3])
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
set(h,'facecolor', 0.9*[1 1 1]);
set(h,'edgecolor','none');
%set(h,'specularstrength',0.3);
%set(h,'diffusestrength',0.7);
%set(h,'ambientstrength',0.7);
set(h,'facealpha',evalin('base','zef.layer_transparency'));
end
end
end

if ismember(evalin('base','zef.visualization_type'),[3,4,5])

    if ismember(evalin('base','zef.visualization_type'),[3,5])
f_ind = frame_start;
end

i = 0;

aux_brain_visible_ind = [];

for k = 1 : length(compartment_tags)
        on_val = evalin('base',['zef.' compartment_tags{k} '_on']);
        visible_val = evalin('base',['zef.' compartment_tags{k} '_visible']);
        color_str =  evalin('base',['zef.' compartment_tags{k} '_color']);
if on_val
i = i + 1;
if visible_val
if ismember(i, aux_brain_ind) &&  (ismember(evalin('base','zef.visualization_type'), [3,4]))
ab_ind = find(aux_brain_ind==i);
aux_brain_visible_ind = [aux_brain_visible_ind i];

if ismember(evalin('base','zef.visualization_type'),[3])
if  i == aux_brain_visible_ind
if  iscell(volumetric_distribution)
h_waitbar = waitbar(1/number_of_frames,['Frame ' int2str(1) ' of ' int2str(number_of_frames) '.']);
set(h_waitbar,'handlevisibility','off');
end
end
end

colormap_size = evalin('base','zef.colormap_size');
colortune_param = evalin('base','zef.colortune_param');
colormap_cell = evalin('base','zef.colormap_cell');
set(h_fig_aux,'colormap', evalin('base',[colormap_cell{evalin('base','zef.inv_colormap')} '(' num2str(colortune_param) ',' num2str(colormap_size) ')']));

if ismember(evalin('base','zef.visualization_type'),[4])

if evalin('base','zef.use_parcellation')
reconstruction = ones(size(reuna_t{i},1),1);
p_rec_aux =  ones(size(reuna_p{i},1),1).*evalin('base','zef.layer_transparency');
for p_ind = selected_list
reconstruction(p_i_ind{p_ind}{2}{ab_ind}) = p_ind+1;
p_rec_aux(unique(reuna_t{i}(p_i_ind{p_ind}{2}{ab_ind},:))) = evalin('base','zef.brain_transparency');
end
end
min_rec = 1;
max_rec = size(evalin('base','zef.parcellation_colormap'),1);

else

%******************************************************
if iscell(volumetric_distribution)
reconstruction = evalin('base',['zef.reconstruction{' int2str(frame_start) '}']);
else
reconstruction = volumetric_distribution;
end
reconstruction = reconstruction(:);
reconstruction = reshape(reconstruction,3,length(reconstruction)/3);
reconstruction = sqrt(sum(reconstruction.^2))';
reconstruction = sum(reconstruction(s_i_ind_2),2)/4;
if evalin('base','zef.inv_scale') == 1
reconstruction = -min_rec_log10 + 20*log10(max(reconstruction, max_abs_reconstruction/evalin('base','zef.inv_dynamic_range')));
elseif evalin('base','zef.inv_scale') == 2
reconstruction = (max(reconstruction, max_abs_reconstruction/evalin('base','zef.inv_dynamic_range')));
elseif evalin('base','zef.inv_scale') == 3
reconstruction = sqrt(max(reconstruction, max_abs_reconstruction/evalin('base','zef.inv_dynamic_range')));
end
[a_hist, b_hist] = hist(reconstruction,min_rec:(max_rec-min_rec)/50:max_rec - (max_rec - min_rec)/50);
a_hist = max(0,real(log10(a_hist)));
length_reconstruction = length(reconstruction);
%******************************************************

if iscell(volumetric_distribution)
reconstruction = single(evalin('base',['zef.reconstruction{' int2str(frame_start) '}']));
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
reconstruction = sum(reconstruction(s_i_ind{ab_ind}),2)/3;
end

if ismember(evalin('base','zef.reconstruction_type'), [2 3 4 5])
rec_x = reconstruction(1,:)';
rec_y = reconstruction(2,:)';
rec_z = reconstruction(3,:)';
rec_x = sum(rec_x(s_i_ind{ab_ind}),2)/3;
rec_y = sum(rec_y(s_i_ind{ab_ind}),2)/3;
rec_z = sum(rec_z(s_i_ind{ab_ind}),2)/3;
n_vec_aux = cross(reuna_p{i}(reuna_t{i}(:,2),:)' - reuna_p{i}(reuna_t{i}(:,1),:)',...
reuna_p{i}(reuna_t{i}(:,3),:)' - reuna_p{i}(reuna_t{i}(:,1),:)')';
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
reconstruction = smooth_field(reuna_t{i}, reconstruction, size(reuna_p{i}(:,1),1),3);
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
reconstruction_aux = zeros(size(reconstruction));
p_rec_aux =  ones(size(reuna_p{i},1),1).*evalin('base','zef.layer_transparency');
for p_ind = selected_list
    if evalin('base','zef.parcellation_type') == 1
        reconstruction_aux(p_i_ind{p_ind}{2}{ab_ind}) = reconstruction(p_i_ind{p_ind}{2}{ab_ind});
    elseif evalin('base','zef.parcellation_type') == 2
        reconstruction_aux(p_i_ind{p_ind}{2}{ab_ind}) = quantile(reconstruction(p_i_ind{p_ind}{2}{ab_ind}),evalin('base','zef.parcellation_quantile'));
    elseif evalin('base','zef.parcellation_type') == 3
    reconstruction_aux(p_i_ind{p_ind}{2}{ab_ind}) = quantile(sqrt(reconstruction(p_i_ind{p_ind}{2}{ab_ind})),evalin('base','zef.parcellation_quantile'));
   elseif evalin('base','zef.parcellation_type') == 4
      reconstruction_aux(p_i_ind{p_ind}{2}{ab_ind}) = quantile((reconstruction(p_i_ind{p_ind}{2}{ab_ind}).^(1/3)),evalin('base','zef.parcellation_quantile'));
    elseif evalin('base','zef.parcellation_type') == 5
      reconstruction_aux(p_i_ind{p_ind}{2}{ab_ind}) = mean(reconstruction(p_i_ind{p_ind}{2}{ab_ind}));
    end
p_rec_aux(unique(reuna_t{i}(p_i_ind{p_ind}{2}{ab_ind},:))) = evalin('base','zef.brain_transparency');
end
reconstruction = reconstruction_aux;
end
end

axes(h_axes_image); set(h_fig_aux,'visible','on');

if ismember(i,aux_brain_ind) && evalin('base','zef.use_inflated_surfaces') && not(isempty(reuna_p_inf))
h_surf_2{ab_ind} = trisurf(reuna_t{i},reuna_p_inf{i}(:,1),reuna_p_inf{i}(:,2),reuna_p_inf{i}(:,3),reconstruction,'edgecolor','none');
set(h_surf_2{ab_ind},'Tag','reconstruction');
else
h_surf_2{ab_ind} = trisurf(reuna_t{i},reuna_p{i}(:,1),reuna_p{i}(:,2),reuna_p{i}(:,3),reconstruction,'edgecolor','none');
set(h_surf_2{ab_ind},'Tag','reconstruction');
end
if ismember(evalin('base','zef.volumetric_distribution_mode'),[1, 3])
zef_plot_cone_field(h_axes_image, f_ind, 2);
end

%marker here
set(h_surf_2{ab_ind},'edgecolor','none','facecolor','flat','facelighting','flat','CDataMapping','scaled');
set(gca,'CLim',[min_rec max_rec]);
%set(h_surf_2{ab_ind},'specularstrength',0.2);
%set(h_surf_2{ab_ind},'specularexponent',0.8);
%set(h_surf_2{ab_ind},'SpecularColorReflectance',0.8);
%set(h_surf_2{ab_ind},'diffusestrength',1);
%set(h_surf_2{ab_ind},'ambientstrength',1);
if evalin('base','zef.brain_transparency') < 1 || evalin('base','zef.use_parcellation')
f_alpha_aux = zeros(size(reuna_p{i},1),1);
if evalin('base','zef.inv_scale') == 1
r_alpha_aux = (reconstruction-min(reconstruction))/(max(reconstruction)-min(reconstruction));
else
r_alpha_aux = abs(reconstruction)/max(abs(reconstruction));
end
r_alpha_aux= max(0,r_alpha_aux-min(r_alpha_aux));
r_alpha_aux = r_alpha_aux/max(r_alpha_aux);
f_alpha_aux(reuna_t{i}(:,1)) = f_alpha_aux(reuna_t{i}(:,1)) + r_alpha_aux/3;
f_alpha_aux(reuna_t{i}(:,2)) = f_alpha_aux(reuna_t{i}(:,2)) + r_alpha_aux/3;
f_alpha_aux(reuna_t{i}(:,3)) = f_alpha_aux(reuna_t{i}(:,3)) + r_alpha_aux/3;
if evalin('base','zef.use_parcellation')
if evalin('base','zef.inv_colormap') == 13
set(h_surf_2{ab_ind},'FaceVertexAlpha',p_rec_aux);
else
set(h_surf_2{ab_ind},'FaceVertexAlpha',max(p_rec_aux,f_alpha_aux));
end
else
set(h_surf_2{ab_ind},'FaceVertexAlpha',max(evalin('base','zef.brain_transparency'),f_alpha_aux));
end
set(h_surf_2{ab_ind},'FaceAlpha','interp');
set(h_surf_2{ab_ind},'AlphaDataMapping','none');
end

if ismember(i,aux_brain_ind) && cb_done == 0 && ismember(evalin('base','zef.visualization_type'),[3])
cb_done = 1;
h_colorbar = colorbar(h_axes_image,'EastOutside','Position',[0.94 0.675 0.01 0.29],'fontsize',1500);
set(h_colorbar,'Tag','rightColorbar');
h_colorbar_axes = get(h_colorbar,'axes');
set(h_colorbar_axes,'fontsize',1500);
h_axes_hist = axes('position',[0.03 0.035 0.2 0.1],'visible','off');
h_bar = bar(h_axes_hist,b_hist+(max_rec-min_rec)/(2*50),a_hist,'hist');
set(h_bar,'facecolor',[0.5 0.5 0.5]);
set(h_axes_hist,'ytick',[]);
hist_ylim =  [0 log10(length_reconstruction)];
set(h_axes_hist,'ylim',hist_ylim);
set(h_axes_hist,'fontsize',1500);
set(h_axes_hist,'xlim',[min_rec max_rec]);
set(h_axes_hist,'linewidth',200);
set(h_axes_hist,'ticklength',[0 0]);
axes(h_axes_image); set(h_fig_aux,'visible','on');

h_axes_text = axes('position',[0.03 0.94 0.01 0.05],'visible','off');
h_text = text(0, 0.5, ['Time: ' num2str(evalin('base','zef.inv_time_1') + evalin('base','zef.inv_time_2')/2 + frame_step*(f_ind - 1)*evalin('base','zef.inv_time_3'),'%0.6f') ' s, Frame: ' num2str(f_ind) ' / ' num2str(length_reconstruction_cell) '.']);
  set(h_text,'visible','on','fontsize',1500);
axes(h_axes_image); set(h_fig_aux,'visible','on');
end
%set(h_colorbar,'layer','bottom');
lighting phong;

else

    if ismember(evalin('base','zef.visualization_type'),[5]) && i == length(reuna_p)
%%%%%Topography reconstruction.

if  iscell(evalin('base','zef.top_reconstruction'))
h_waitbar = waitbar(1/number_of_frames,['Frame ' int2str(1) ' of ' int2str(number_of_frames) '.']);
set(h_waitbar,'handlevisibility','off');
end

if  iscell(evalin('base','zef.top_reconstruction'))
h_waitbar = waitbar(1/number_of_frames,['Frame ' int2str(1) ' of ' int2str(number_of_frames) '.']);
set(h_waitbar,'handlevisibility','off');
end

colormap_size = 4096;
colortune_param = evalin('base','zef.colortune_param');
colormap_cell = evalin('base','zef.colormap_cell');
set(h_fig_aux,'colormap', evalin('base',[colormap_cell{evalin('base','zef.inv_colormap')} '(' num2str(colortune_param) ',' num2str(colormap_size) ')']));

if iscell(evalin('base','zef.top_reconstruction'))
reconstruction = single(evalin('base',['zef.top_reconstruction{' int2str(frame_start) '}']));
else
reconstruction = evalin('base','zef.top_reconstruction');
end
reconstruction = reconstruction(:);

if ismember(i,aux_brain_ind) && evalin('base','zef.use_inflated_surfaces') && not(isempty(reuna_p_inf))
h_surf_2{i} = trisurf(reuna_t{i},reuna_p_inf{i}(:,1),reuna_p_inf{i}(:,2),reuna_p_inf{i}(:,3),reconstruction,'edgecolor','none');
set(h_surf2{i},'Tag','reconstruction');
else
h_surf_2{i} = trisurf(reuna_t{i},reuna_p{i}(:,1),reuna_p{i}(:,2),reuna_p{i}(:,3),reconstruction,'edgecolor','none');
set(h_surf2{i},'Tag','reconstruction');
end
if ismember(evalin('base','zef.volumetric_distribution_mode'),[1, 3])
zef_plot_cone_field(h_axes_image, f_ind, 2);
end

set(h_surf_2{i},'edgecolor','none','facecolor','flat','facelighting','flat','CDataMapping','scaled');
set(gca,'CLim',gather([min_rec max_rec]));
%set(h_surf_2{i},'specularstrength',0.2);
%set(h_surf_2{i},'specularexponent',0.8);
%set(h_surf_2{i},'SpecularColorReflectance',0.8);
%set(h_surf_2{i},'diffusestrength',1);
%set(h_surf_2{i},'ambientstrength',1);
if evalin('base','zef.brain_transparency') < 1 || evalin('base','zef.use_parcellation')
f_alpha_aux = zeros(size(reuna_p{i},1),1);
if evalin('base','zef.inv_scale') == 1
r_alpha_aux = (reconstruction-min(reconstruction))/(max(reconstruction)-min(reconstruction));
else
r_alpha_aux = abs(reconstruction)/max(abs(reconstruction));
end
r_alpha_aux= max(0,r_alpha_aux-min(r_alpha_aux));
r_alpha_aux = r_alpha_aux/max(r_alpha_aux);
f_alpha_aux = r_alpha_aux;
if evalin('base','zef.use_parcellation')
if evalin('base','zef.inv_colormap') == 13
set(h_surf_2{i},'FaceVertexAlpha',p_rec_aux);
else
set(h_surf_2{i},'FaceVertexAlpha',max(p_rec_aux,f_alpha_aux));
end
else
set(h_surf_2{i},'FaceVertexAlpha',max(evalin('base','zef.brain_transparency'),f_alpha_aux));
end
set(h_surf_2{i},'FaceAlpha','interp');
set(h_surf_2{i},'AlphaDataMapping','none');
end

cb_done = 1;
h_colorbar = colorbar(h_axes_image,'EastOutside','Position',[0.94 0.675 0.01 0.29],'fontsize',1500);
set(h_colorbar,'Tag','rightColorbar');
h_colorbar_axes = get(h_colorbar,'axes');
set(h_colorbar_axes,'fontsize',1500);
axes(h_axes_image); set(h_fig_aux,'visible','on');

h_axes_text = axes('position',[0.03 0.94 0.01 0.05],'visible','off');
h_text = text(0, 0.5, ['Time: ' num2str(evalin('base','zef.inv_time_1') + evalin('base','zef.inv_time_2')/2 + frame_step*(f_ind - 1)*evalin('base','zef.inv_time_3'),'%0.6f') ' s, Frame: ' num2str(f_ind) ' / ' num2str(length_reconstruction_cell) '.']);
  set(h_text,'visible','on','fontsize',1500);
axes(h_axes_image); set(h_fig_aux,'visible','on');

lighting phong;

%%%% End of topography reconstruction

    else
[min_n_aux, min_t_aux] = zef_minimal_mesh(reuna_p{i},reuna_t{i});
h_surf = trimesh(min_t_aux,min_n_aux(:,1),min_n_aux(:,2),min_n_aux(:,3),'edgecolor','none','facecolor',color_str);
set(h_surf,'Tag','surface');
%set(h_surf,'specularstrength',0.1);
%set(h_surf,'diffusestrength',0.5);
%set(h_surf,'ambientstrength',0.85);
set(h_surf,'facealpha',evalin('base','zef.layer_transparency'));
%if not(evalin('base','zef.visualization_type')==3);
lighting phong;
%end
end

end
end
end
end

if iscell(volumetric_distribution) &&  ismember(evalin('base','zef.visualization_type'),[3])
view(evalin('base','zef.azimuth'),evalin('base','zef.elevation'));
else
view(get(evalin('base','zef.h_axes1'),'view'));
end
if iscell(evalin('base','zef.top_reconstruction')) &&  ismember(evalin('base','zef.visualization_type'),[5])
view(evalin('base','zef.azimuth'),evalin('base','zef.elevation'));
else
view(get(evalin('base','zef.h_axes1'),'view'));
end
axis('image');
camva(evalin('base','zef.cam_va'));
if evalin('base','zef.axes_visible')
set(gca,'visible','on');
set(gca,'xGrid','on');
set(gca,'yGrid','on');
set(gca,'zGrid','on');
else
set(gca,'visible','off');
set(gca,'xGrid','off');
set(gca,'yGrid','off');
set(gca,'zGrid','off');
end

camva(c_va);
campos(c_pos);
camtarget(c_ta);
camproj(c_p);
camup(c_u);

        sensor_patches = findobj(h_axes_image,'Type','Patch','Tag','sensor');
        uistack(sensor_patches,'top');
zef_plot_dpq('static');
zef_plot_dpq('dynamical');
        zef_set_sliders_print(1,h_axes_image);
if not(evalin('base','zef.axes_visible'))
set(h_axes_image,'visible','off');
end

%drawnow;

if iscell(volumetric_distribution) &&  ismember(evalin('base','zef.visualization_type'),[3])

  if is_video
  if file_index == 1;
  print(h_fig_aux,'-djpeg95','-r1',[file_path  file_name(1:end-4) '_' int2str(frame_start) file_name(end-3:end)]);
  elseif file_index ==2;
  print(h_fig_aux,'-dtiff','-r1',[file_path  file_name(1:end-4) '_' int2str(frame_start) file_name(end-3:end)]);
  elseif file_index ==3;
  print(h_fig_aux,'-dpng','-r1',[file_path  file_name(1:end-4) '_' int2str(frame_start) file_name(end-3:end)]);
  elseif file_index ==4;
  bmp_file_temp = [file_path  file_name(1:end-4) '_temp.bmp'];
  print(h_fig_aux,'-dbmp','-r1',bmp_file_temp);
  [movie_frame] = imread(bmp_file_temp,'bmp');
  h_frame = im2frame(movie_frame);
  writeVideo(h_aviobj,h_frame);
   delete(bmp_file_temp);
  end;
  else
  if file_index == 1;
  print(h_fig_aux,'-djpeg95','-r1',[file_path  file_name]);
  elseif file_index ==2;
  print(h_fig_aux,'-dtiff','-r1',[file_path  file_name]);
  elseif file_index==3;
  print(h_fig_aux,'-dpng','-r1',[file_path  file_name]);
  end;
  end;

elseif iscell(evalin('base','zef.top_reconstruction')) &&  ismember(evalin('base','zef.visualization_type'),[5])

    if is_video
  if file_index == 1;
  print(h_fig_aux,'-djpeg95','-r1',[file_path  file_name(1:end-4) '_' int2str(frame_start) file_name(end-3:end)]);
  elseif file_index ==2;
  print(h_fig_aux,'-dtiff','-r1',[file_path  file_name(1:end-4) '_' int2str(frame_start) file_name(end-3:end)]);
  elseif file_index ==3;
  print(h_fig_aux,'-dpng','-r1',[file_path  file_name(1:end-4) '_' int2str(frame_start) file_name(end-3:end)]);
  elseif file_index ==4;
  bmp_file_temp = [file_path  file_name(1:end-4) '_temp.bmp'];
  print(h_fig_aux,'-dbmp','-r1',bmp_file_temp);
  [movie_frame] = imread(bmp_file_temp,'bmp');
  h_frame = im2frame(movie_frame);
  writeVideo(h_aviobj,h_frame);
   delete(bmp_file_temp);
  end;
  else
  if file_index == 1;
  print(h_fig_aux,'-djpeg95','-r1',[file_path  file_name]);
  elseif file_index ==2;
  print(h_fig_aux,'-dtiff','-r1',[file_path  file_name]);
  elseif file_index==3;
  print(h_fig_aux,'-dpng','-r1',[file_path  file_name]);
  end;
  end;

else

if file_index == 1;
print(h_fig_aux,[file_path file_name],'-djpeg95','-r1');
elseif file_index ==2;
print(h_fig_aux,[file_path file_name],'-dtiff','-r1');
elseif file_index ==3;
print(h_fig_aux,[file_path file_name],'-dpng','-r1');
end;
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

if ismember(evalin('base','zef.visualization_type'),[3,5])

tic;
f_ind_aux = 1;
for f_ind = frame_start + frame_step : frame_step : frame_stop
f_ind_aux = f_ind_aux + 1;
if f_ind_aux > 2
time_val = toc;
waitbar(f_ind_aux/number_of_frames,h_waitbar,['Frame ' int2str(f_ind_aux) ' of ' int2str(number_of_frames) '. Ready: ' datestr(datevec(now+((number_of_frames-1)/(f_ind_aux-2) - 1)*time_val/86400)) '.']);
else
waitbar(f_ind_aux/number_of_frames,h_waitbar,['Frame ' int2str(f_ind_aux) ' of ' int2str(number_of_frames) '.'])
end
set(h_waitbar,'handlevisibility','off');
%******************************************************

if ismember(evalin('base','zef.visualization_type'),[3])
if iscell(volumetric_distribution)
reconstruction = volumetric_distribution{f_ind};
else
reconstruction = volumetric_distribution;
end
reconstruction = reconstruction(:);
reconstruction = reshape(reconstruction,3,length(reconstruction)/3);
reconstruction = sqrt(sum(reconstruction.^2))';
reconstruction = sum(reconstruction(s_i_ind_2),2)/4;
if evalin('base','zef.inv_scale') == 1
reconstruction = -min_rec_log10 + 20*log10(max(reconstruction,max_abs_reconstruction/evalin('base','zef.inv_dynamic_range')));
elseif evalin('base','zef.inv_scale') == 2
reconstruction = (max(reconstruction,max_abs_reconstruction/evalin('base','zef.inv_dynamic_range')));
elseif evalin('base','zef.inv_scale') == 3
reconstruction = sqrt(max(reconstruction,max_abs_reconstruction/evalin('base','zef.inv_dynamic_range')));
end
[a_hist, b_hist] = hist(reconstruction,min_rec:(max_rec-min_rec)/50:max_rec - (max_rec - min_rec)/50);
a_hist = max(0,real(log10(a_hist)));
length_reconstruction = length(reconstruction);
%******************************************************

for i = intersect(aux_brain_ind, aux_brain_visible_ind)
ab_ind = find(aux_brain_ind == i);
reconstruction = single(volumetric_distribution{f_ind});
reconstruction = reconstruction(:);
reconstruction = reshape(reconstruction,3,length(reconstruction)/3);

if ismember(evalin('base','zef.reconstruction_type'),[1 7])
reconstruction = sqrt(sum(reconstruction.^2))';
elseif evalin('base','zef.reconstruction_type') == 6
reconstruction = (1/sqrt(3))*sum(reconstruction)';
end
if ismember(evalin('base','zef.reconstruction_type'), [1 6 7])
reconstruction = sum(reconstruction(s_i_ind{ab_ind}),2)/3;
end

if ismember(evalin('base','zef.reconstruction_type'), [2 3 4 5])
rec_x = reconstruction(1,:)';
rec_y = reconstruction(2,:)';
rec_z = reconstruction(3,:)';
rec_x = sum(rec_x(s_i_ind{ab_ind}),2)/3;
rec_y = sum(rec_y(s_i_ind{ab_ind}),2)/3;
rec_z = sum(rec_z(s_i_ind{ab_ind}),2)/3;
n_vec_aux = cross(reuna_p{i}(reuna_t{i}(:,2),:)' - reuna_p{i}(reuna_t{i}(:,1),:)',...
 reuna_p{i}(reuna_t{i}(:,3),:)' - reuna_p{i}(reuna_t{i}(:,1),:)')';
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
reconstruction = smooth_field(reuna_t{i}, reconstruction, size(reuna_p{i}(:,1),1),3);
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
reconstruction_aux = zeros(size(reconstruction));
p_rec_aux =  ones(size(reuna_p{i},1),1).*evalin('base','zef.layer_transparency');
for p_ind = selected_list
    if evalin('base','zef.parcellation_type') == 1
        reconstruction_aux(p_i_ind{p_ind}{2}{ab_ind}) = reconstruction(p_i_ind{p_ind}{2}{ab_ind});
    elseif evalin('base','zef.parcellation_type') == 2
        reconstruction_aux(p_i_ind{p_ind}{2}{ab_ind}) = quantile(reconstruction(p_i_ind{p_ind}{2}{ab_ind}),evalin('base','zef.parcellation_quantile'));
    elseif evalin('base','zef.parcellation_type') == 3
    reconstruction_aux(p_i_ind{p_ind}{2}{ab_ind}) = quantile(sqrt(reconstruction(p_i_ind{p_ind}{2}{ab_ind})),evalin('base','zef.parcellation_quantile'));
   elseif evalin('base','zef.parcellation_type') == 4
      reconstruction_aux(p_i_ind{p_ind}{2}{ab_ind}) = quantile((reconstruction(p_i_ind{p_ind}{2}{ab_ind}).^(1/3)),evalin('base','zef.parcellation_quantile'));
    elseif evalin('base','zef.parcellation_type') == 5
      reconstruction_aux(p_i_ind{p_ind}{2}{ab_ind}) = mean(reconstruction(p_i_ind{p_ind}{2}{ab_ind}));
    end
p_rec_aux(unique(reuna_t{i}(p_i_ind{p_ind}{2}{ab_ind},:))) = evalin('base','zef.brain_transparency');
end
reconstruction = reconstruction_aux;
end

delete(h_surf_2{ab_ind});

axes(h_axes_image); set(h_fig_aux,'visible','on');

if ismember(i,aux_brain_ind) && evalin('base','zef.use_inflated_surfaces') && not(isempty(reuna_p_inf))
h_surf_2{ab_ind} = trisurf(reuna_t{i},reuna_p_inf{i}(:,1),reuna_p_inf{i}(:,2),reuna_p_inf{i}(:,3),reconstruction,'edgecolor','none');
set(h_surf_2{ab_ind},'Tag','reconstruction');
else
h_surf_2{ab_ind} = trisurf(reuna_t{i},reuna_p{i}(:,1),reuna_p{i}(:,2),reuna_p{i}(:,3),reconstruction,'edgecolor','none');
set(h_surf_2{ab_ind},'Tag','reconstruction');
end
if ismember(evalin('base','zef.volumetric_distribution_mode'),[1, 3])
zef_plot_cone_field(h_axes_image, f_ind, 2);
end

set(h_surf_2{ab_ind},'edgecolor','none','facecolor','flat','facelighting','flat','CDataMapping','scaled');
set(gca,'CLim',[min_rec max_rec]);
%set(h_surf_2{ab_ind},'specularstrength',0.2);
%set(h_surf_2{ab_ind},'specularexponent',0.8);
%set(h_surf_2{ab_ind},'SpecularColorReflectance',0.8);
%set(h_surf_2{ab_ind},'diffusestrength',1);
%set(h_surf_2{ab_ind},'ambientstrength',1);
if evalin('base','zef.brain_transparency') < 1 || evalin('base','zef.use_parcellation')
f_alpha_aux = zeros(size(reuna_p{i},1),1);
if evalin('base','zef.inv_scale') == 1
r_alpha_aux = (reconstruction-min(reconstruction))/(max(reconstruction)-min(reconstruction));
else
r_alpha_aux = abs(reconstruction)/max(abs(reconstruction));
end
r_alpha_aux= max(0,r_alpha_aux-min(r_alpha_aux));
r_alpha_aux = r_alpha_aux/max(r_alpha_aux);
f_alpha_aux(reuna_t{i}(:,1)) = f_alpha_aux(reuna_t{i}(:,1)) + r_alpha_aux/3;
f_alpha_aux(reuna_t{i}(:,2)) = f_alpha_aux(reuna_t{i}(:,2)) + r_alpha_aux/3;
f_alpha_aux(reuna_t{i}(:,3)) = f_alpha_aux(reuna_t{i}(:,3)) + r_alpha_aux/3;
if evalin('base','zef.use_parcellation')
if evalin('base','zef.inv_colormap') == 13
set(h_surf_2{ab_ind},'FaceVertexAlpha',p_rec_aux);
else
set(h_surf_2{ab_ind},'FaceVertexAlpha',max(p_rec_aux,f_alpha_aux));
end
else
set(h_surf_2{ab_ind},'FaceVertexAlpha',max(evalin('base','zef.brain_transparency'),f_alpha_aux));
end
set(h_surf_2{ab_ind},'FaceAlpha','interp');
set(h_surf_2{ab_ind},'AlphaDataMapping','none');
end

end

elseif ismember(evalin('base','zef.visualization_type'),[5])

    %Topography reconstruction.

reconstruction = single(evalin('base',['zef.top_reconstruction{' int2str(f_ind) '}']));
reconstruction = reconstruction(:);

axes(h_axes_image);
%h_surf_2{ab_ind} = trisurf(reuna_t{i},reuna_p{i}(:,1),reuna_p{i}(:,2),reuna_p{i}(:,3),reconstruction,'edgecolor','none');
delete(h_surf_2{i});

if ismember(i,aux_brain_ind) && evalin('base','zef.use_inflated_surfaces') && not(isempty(reuna_p_inf))
h_surf_2{i} = trisurf(reuna_t{i},reuna_p_inf{i}(:,1),reuna_p_inf{i}(:,2),reuna_p_inf{i}(:,3),reconstruction,'edgecolor','none');
set(h_surf_2{i},'Tag','reconstruction');
else
h_surf_2{i} = trisurf(reuna_t{i},reuna_p{i}(:,1),reuna_p{i}(:,2),reuna_p{i}(:,3),reconstruction,'edgecolor','none');
set(h_surf_2{i},'Tag','reconstruction');
end
if ismember(evalin('base','zef.volumetric_distribution_mode'),[1, 3])
zef_plot_cone_field(h_axes_image, f_ind, 2);
end

set(h_surf_2{i},'edgecolor','none','facecolor','flat','facelighting','flat','CDataMapping','scaled');
set(gca,'CLim',[min_rec max_rec]);
%set(h_surf_2{i},'specularstrength',0.2);
%set(h_surf_2{i},'specularexponent',0.8);
%set(h_surf_2{i},'SpecularColorReflectance',0.8);
%set(h_surf_2{i},'diffusestrength',1);
%set(h_surf_2{i},'ambientstrength',1);
if evalin('base','zef.brain_transparency') < 1 || evalin('base','zef.use_parcellation')
f_alpha_aux = zeros(size(reuna_p{i},1),1);
if evalin('base','zef.inv_scale') == 1
r_alpha_aux = (reconstruction-min(reconstruction))/(max(reconstruction)-min(reconstruction));
else
r_alpha_aux = abs(reconstruction)/max(abs(reconstruction));
end
r_alpha_aux= max(0,r_alpha_aux-min(r_alpha_aux));
r_alpha_aux = r_alpha_aux/max(r_alpha_aux);
f_alpha_aux = r_alpha_aux;
if evalin('base','zef.use_parcellation')
if evalin('base','zef.inv_colormap') == 13
set(h_surf_2{i},'FaceVertexAlpha',p_rec_aux);
else
set(h_surf_2{i},'FaceVertexAlpha',max(p_rec_aux,f_alpha_aux));
end
else
set(h_surf_2{i},'FaceVertexAlpha',max(evalin('base','zef.brain_transparency'),f_alpha_aux));
end
set(h_surf_2{i},'FaceAlpha','interp');
set(h_surf_2{i},'AlphaDataMapping','none');
end

%End of topography reconstruction.

end
zef_plot_dpq('dynamical');
zef_set_sliders_print(1);
camorbit(frame_step*evalin('base','zef.orbit_1')/movie_fps,frame_step*evalin('base','zef.orbit_2')/movie_fps);
lighting phong;

delete(h_text);
axes(h_axes_text);set(h_fig_aux,'visible','on');
set(h_axes_text,'tag','image_details');
if ismember(evalin('base','zef.visualization_type'),[3])
h_text = text(0, 0.5, ['Time: ' num2str(evalin('base','zef.inv_time_1') + evalin('base','zef.inv_time_2')/2 + frame_step*(f_ind - 1)*evalin('base','zef.inv_time_3'),'%0.6f') ' s, Frame: ' num2str(f_ind) ' / ' num2str(length_reconstruction_cell) '.']);
elseif ismember(evalin('base','zef.visualization_type'),[5])
h_text = text(0, 0.5, ['Time: ' num2str(evalin('base','zef.top_time_1') + evalin('base','zef.top_time_2')/2 + frame_step*(f_ind - 1)*evalin('base','zef.top_time_3'),'%0.6f') ' s, Frame: ' num2str(f_ind) ' / ' num2str(length_reconstruction_cell) '.']);
end
set(h_text,'visible','on','fontsize',1500);
set(h_text,'visible','on');
set(h_axes_text,'layer','bottom');
%drawnow;

if ismember(evalin('base','zef.visualization_type'),[3])
delete(h_bar);
h_bar = bar(h_axes_hist,b_hist+(max_rec-min_rec)/(2*50),a_hist,'hist');
set(h_bar,'facecolor',[0.5 0.5 0.5]);
set(h_axes_hist,'ytick',[]);
hist_ylim =  [0 log10(length_reconstruction)];
set(h_axes_hist,'ylim',hist_ylim);
set(h_axes_hist,'fontsize',1500);
set(h_axes_hist,'xlim',[min_rec max_rec]);
set(h_axes_hist,'linewidth',200);
set(h_axes_hist,'ticklength',[0 0]);
end

  if file_index == 1;
  print(h_fig_aux,'-djpeg95','-r1',[file_path  file_name(1:end-4) '_' int2str(f_ind) file_name(end-3:end)]);
  elseif file_index ==2;
  print(h_fig_aux,'-dtiff','-r1',[file_path  file_name(1:end-4) '_' int2str(f_ind) file_name(end-3:end)]);
  elseif file_index ==3;
  print(h_fig_aux,'-dpng','-r1',[file_path  file_name(1:end-4) '_' int2str(f_ind) file_name(end-3:end)]);
  elseif file_index == 4;
  print(h_fig_aux,'-dbmp','-r1',bmp_file_temp);
  [movie_frame] = imread(bmp_file_temp,'bmp');
  h_frame = im2frame(movie_frame);
  writeVideo(h_aviobj,h_frame);
   delete(bmp_file_temp);
  end;

end

end

else

i = 0;

for k = 1 : length(compartment_tags)
        on_val = evalin('base',['zef.' compartment_tags{k} '_on']);
        visible_val = evalin('base',['zef.' compartment_tags{k} '_visible']);
        color_str =  evalin('base',['zef.' compartment_tags{k} '_color']);
if on_val
i = i + 1;
if visible_val
[min_n_aux, min_t_aux] = zef_minimal_mesh(reuna_p{i},reuna_t{i});
h_surf = trimesh(min_t_aux,min_n_aux(:,1),min_n_aux(:,2),min_n_aux(:,3),'edgecolor','none','facecolor',color_str);
set(h_surf,'Tag','surface');
%set(h_surf,'specularstrength',0.1);
%set(h_surf,'diffusestrength',0.5);
%set(h_surf,'ambientstrength',0.85);
set(h_surf,'facealpha',evalin('base','zef.layer_transparency'));
lighting flat;
end
end
end

%view(evalin('base','zef.azimuth'),evalin('base','zef.elevation'));
view(get(evalin('base','zef.h_axes1'),'view'));
axis('image');
camva(evalin('base','zef.cam_va'));
if evalin('base','zef.axes_visible')
set(gca,'visible','on');
set(gca,'xGrid','on');
set(gca,'yGrid','on');
set(gca,'zGrid','on');
else
set(gca,'visible','off');
set(gca,'xGrid','off');
set(gca,'yGrid','off');
set(gca,'zGrid','off');
end

camva(c_va);
campos(c_pos);
camtarget(c_ta);
camproj(c_p);
camup(c_u);

        sensor_patches = findobj(evalin('base','zef.h_axes1'),'Type','Patch','Tag','sensor');
        uistack(sensor_patches,'top');
zef_plot_dpq('static');
zef_plot_dpq('dynamical');
        zef_set_sliders_print(1,h_axes_image);

%drawnow;

if file_index == 1;
print(h_fig_aux,[file_path file_name],'-djpeg95','-r1');
elseif file_index ==2;
print(h_fig_aux,[file_path file_name],'-dtiff','-r1');
elseif file_index ==3;
print(h_fig_aux,[file_path file_name],'-dpng','-r1');
end;

end

if iscell(volumetric_distribution) &  evalin('base','zef.visualization_type') == 3 & is_video & file_index == 4
close(h_aviobj);
warning off; delete('avi_file'); warning on
movefile(avi_file_temp, avi_file, 'f');
end
close(h_fig_aux);
if  iscell(volumetric_distribution) &  evalin('base','zef.visualization_type') == 3
close(h_waitbar);
end

if iscell(evalin('base','zef.top_reconstruction')) &&  evalin('base','zef.visualization_type') == 5 & is_video & file_index == 4
close(h_aviobj);
warning off; delete('avi_file'); warning on
movefile(avi_file_temp, avi_file, 'f');
end
if  iscell(evalin('base','zef.top_reconstruction')) &&  evalin('base','zef.visualization_type') == 5
close(h_waitbar);
end
%**************************************************************************

end

end

