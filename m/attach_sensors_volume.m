%Copyright © 2018, Sampsa Pursiainen
function  [sensors_attached_volume] = attach_sensors_volume(void) 

if evalin('base','zef.imaging_method') == 1 & not(isempty(evalin('base','zef.tetra')))  
    
sensors = evalin('base','zef.sensors');
surface_triangles = evalin('base','zef.surface_triangles');
nodes = evalin('base','zef.nodes');
use_depth_electrodes = evalin('base','zef.use_depth_electrodes');
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
sensors_attached_volume = [];    
end
