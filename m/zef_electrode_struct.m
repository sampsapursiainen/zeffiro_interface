function [electrode_struct] = zef_electrode_struct(sensors_attached_volume)

electrode_struct = [];

if size(sensors_attached_volume,2) == 4

   for i = 1 : max(sensors_attached_volume(:,1))

       sensor_triangles = sensors_attached_volume(find(sensors_attached_volume(:,1)==i),2:4);
       sensor_edges_aux = [sensor_triangles(:,[1 2]); sensor_triangles(:,[2 3]); sensor_triangles(:,[3 1])];
       sensor_edges_aux = sortrows(sort(sensor_edges_aux,2));
       is_not_on_boundary = find(sum(abs(sensor_edges_aux(1:end-1,:) - sensor_edges_aux(2:end,:)),2)==0);
       is_not_on_boundary = [is_not_on_boundary ; is_not_on_boundary + 1];
       is_on_boundary = setdiff([1:size(sensor_edges_aux,1)]',is_not_on_boundary);
       electrode_struct(i).edges = sensor_edges_aux(is_on_boundary,:);
       electrode_struct(i).nodes = unique(electrode_struct(i).edges);
       electrode_struct(i).triangles = sensor_triangles;

   end

end
end

