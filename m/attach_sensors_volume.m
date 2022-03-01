%Copyright © 2018- Sampsa Pursiainen & ZI Development Team
%See: https://github.com/sampsapursiainen/zeffiro_interface
function  [sensors_attached_volume] = attach_sensors_volume(sensors,varargin)

attach_type = 'mesh';
nodes = evalin('base','zef.nodes');
 tetra = evalin('base','zef.tetra');

if not(isempty(varargin))
   if length(varargin) > 0
   attach_type = varargin{1};
   if length(varargin) > 1
       nodes = varargin{2};
   end
      if length(varargin) > 2
       tetra = varargin{3};
      end
   end
end

if ismember(evalin('base','zef.imaging_method'),[1,4,5])

%if ismember(attach_type,{'geometry','points'});
geometry_triangles = evalin('base','zef.reuna_t{end}');
geometry_nodes = evalin('base','zef.reuna_p{end}');
%end

surface_triangles = evalin('base','zef.surface_triangles');
use_depth_electrodes = evalin('base','zef.use_depth_electrodes');

%if evalin('base','zef.use_gpu')
%    nodes = gpuArray(nodes);
%    sensors = gpuArray(sensors);
%end

if size(sensors,2) == 6
    electrode_model = 2;
else
    electrode_model = 1;
end

if electrode_model == 1 || isequal(attach_type,'points')

if electrode_model == 1 && use_depth_electrodes == 1
surface_ind = [];
deep_ind = [1:size(sensors,1)]';
elseif electrode_model == 1 && use_depth_electrodes == 0
surface_ind = [1:size(sensors,1)]';
deep_ind = [];
else
    surface_ind = find(not(ismember(sensors(:,5),0)));
    deep_ind = setdiff(find(ismember(sensors(:,4),0)),surface_ind);
end
sensors_attached_volume = sensors;
for i = 1 : length(deep_ind)
[min_val, min_ind] = min(sqrt(sum((nodes - repmat(sensors(deep_ind(i),1:3),size(nodes,1),1)).^2,2)));
sensors_attached_volume(deep_ind(i),1:3) = nodes(min_ind,:);
end
for i = 1 : length(surface_ind)
[min_val, min_ind] = min(sqrt(sum((geometry_nodes - repmat(sensors(surface_ind(i),1:3),size(geometry_nodes,1),1)).^2,2)));
sensors_attached_volume(surface_ind(i),1:3) = geometry_nodes(min_ind,:);
end

else

if (isequal(attach_type,'geometry'))
geometry_center_points_aux = (1/3)*(geometry_nodes(geometry_triangles(:,1),:) + ...
                           geometry_nodes(geometry_triangles(:,2),:) + ...
                           geometry_nodes(geometry_triangles(:,3),:));
else
    center_points_aux = (1/3)*(nodes(surface_triangles(:,1),:) + ...
                           nodes(surface_triangles(:,2),:) + ...
                           nodes(surface_triangles(:,3),:));

unique_surface_triangles = unique(surface_triangles);
ele_nodes = nodes(unique_surface_triangles,:);

if not(isempty(find(sensors(:,4) == 0)))
    diff_vec_1 = (nodes(tetra(:,2),:) - nodes(tetra(:,1),:));
    diff_vec_2 = (nodes(tetra(:,3),:) - nodes(tetra(:,1),:));
    diff_vec_3 = (nodes(tetra(:,4),:) - nodes(tetra(:,1),:));
    det_system = zef_determinant(diff_vec_1,diff_vec_2,diff_vec_3);
end

end

sensors_aux = [];

for i = 1 : size(sensors,1)

if sensors(i,4) == 0 && sensors(i,5) == 0

if isequal(attach_type,'mesh')

    diff_vec_sensor = (repmat(sensors(i,1:3),size(tetra,1),1)- nodes(tetra(:,1),:));
    lambda_2 = zef_determinant(diff_vec_sensor,diff_vec_2,diff_vec_3);
    lambda_3 = zef_determinant(diff_vec_1,diff_vec_sensor,diff_vec_3);
    lambda_4 = zef_determinant(diff_vec_1,diff_vec_2,diff_vec_sensor);
    lambda_2 = lambda_2./det_system;
    lambda_3 = lambda_3./det_system;
    lambda_4 = lambda_4./det_system;
    lambda_1 = 1 - lambda_2 - lambda_3 - lambda_4;
    sensor_index = find(lambda_1 <= 1 & lambda_2 <= 1 & lambda_3 <= 1  & lambda_4 <= 1 ...
       &  lambda_1 >= 0 & lambda_2 >= 0 & lambda_3 >= 0  & lambda_4 >= 0,1);
        lambda_vec = [lambda_1(sensor_index) ; lambda_2(sensor_index) ; lambda_3(sensor_index) ; lambda_4(sensor_index)];
    sensors_aux = [sensors_aux ; i*ones(4,1)  tetra(sensor_index,:)' lambda_vec zeros(4,1)];

      end

if isequal(attach_type,'geometry')

[min_val, min_ind] = min(sqrt(sum((geometry_nodes - repmat(sensors(i,1:3),size(geometry_nodes,1),1)).^2,2)));
sensors_aux = [sensors_aux ; i 0 1 0];

end

elseif sensors(i,4) == 0 && sensors(i,5) == 1

if isequal(attach_type,'mesh')

[min_val, min_ind] = min(sqrt(sum((ele_nodes - repmat(sensors(i,1:3),size(ele_nodes,1),1)).^2,2)));
min_ind = unique_surface_triangles(min_ind);
sensors_aux = [sensors_aux ; i min_ind 1 0];

end

if isequal(attach_type,'geometry')

[min_val, min_ind] = min(sqrt(sum((geometry_nodes - repmat(sensors(i,1:3),size(geometry_nodes,1),1)).^2,2)));
sensors_aux = [sensors_aux ; i min_ind 1 0];

end

else

 if isequal(attach_type,'mesh')

[min_val, min_ind] = min(sqrt(sum((ele_nodes - repmat(sensors(i,1:3),size(ele_nodes,1),1)).^2,2)));
sensors(i,1:3) = ele_nodes(min_ind,:);
[dist_val] = (sqrt(sum((center_points_aux - repmat(sensors(i,1:3),size(center_points_aux,1),1)).^2,2)));
dist_ind = find(dist_val < sensors(i,4) & dist_val >= sensors(i,5));
sensors_aux = [sensors_aux ; i*ones(length(dist_ind),1) surface_triangles(dist_ind,:)];

elseif isequal(attach_type,'geometry')

[min_val, min_ind] = min(sqrt(sum((geometry_nodes - repmat(sensors(i,1:3),size(geometry_nodes,1),1)).^2,2)));
sensors(i,1:3) = geometry_nodes(min_ind,:);
[dist_val] = (sqrt(sum((geometry_center_points_aux - repmat(sensors(i,1:3),size(geometry_center_points_aux,1),1)).^2,2)));
dist_ind = find(dist_val < sensors(i,4) & dist_val >= sensors(i,5));
sensors_aux = [sensors_aux ; i*ones(length(dist_ind),1) geometry_triangles(dist_ind,:)];

end
end

end

sensors_attached_volume = sensors_aux;

end

else
sensors_attached_volume = [];
end

sensors_attached_volume = gather(sensors_attached_volume);

end
