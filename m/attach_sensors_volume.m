%Copyright © 2018, Sampsa Pursiainen
function  [sensors_attached_volume] = attach_sensors_volume(sensors) 

if ismember(evalin('base','zef.imaging_method'),[1,4,5]) & not(isempty(evalin('base','zef.tetra')))  
    
surface_triangles = evalin('base','zef.surface_triangles');
nodes = evalin('base','zef.nodes');
use_depth_electrodes = evalin('base','zef.use_depth_electrodes');

if size(sensors,2) == 6
    electrode_model = 2;
else
    electrode_model = 1;
end

if electrode_model == 1
if use_depth_electrodes == 1
ele_nodes = nodes;
else
ele_nodes = nodes(unique(surface_triangles),:);
end
sensors_attached_volume = sensors;
for i = 1 : size(sensors,1)
[min_val, min_ind] = min(sqrt(sum((ele_nodes - repmat(sensors(i,1:3),size(ele_nodes,1),1)).^2,2)));
sensors_attached_volume(i,1:3) = ele_nodes(min_ind,:);
end
else
 center_points_aux = (1/3)*(nodes(surface_triangles(:,1),:) + ...
                       nodes(surface_triangles(:,2),:) + ...
                       nodes(surface_triangles(:,3),:));
ele_nodes = nodes(unique(surface_triangles),:);
for i = 1 : size(sensors,1)
[min_val, min_ind] = min(sqrt(sum((ele_nodes - repmat(sensors(i,1:3),size(ele_nodes,1),1)).^2,2)));
sensors(i,1:3) = ele_nodes(min_ind,:);
end                 
 sensors_aux = []; 
 for i = 1 : size(sensors,1)
 [dist_val] = (sqrt(sum((center_points_aux - repmat(sensors(i,1:3),size(center_points_aux,1),1)).^2,2)));
 dist_ind = find(dist_val <= sensors(i,4) & dist_val >= sensors(i,5)); 
 sensors_aux = [sensors_aux ; i*ones(length(dist_ind),1) surface_triangles(dist_ind,:)];
 end
 sensors_attached_volume = sensors_aux;   
end

else
sensors_attached_volume = [];    
end
