function [triangles_out, points_out] = zef_get_sensor_boundary(zef)

    points_ind = []; 
    triangles_ind = [];
    compartments_ind = [];

    if isfield(zef,[zef.current_sensors '_boundary_cell'])

    boundary_cell = zef.([zef.current_sensors '_boundary_cell']);    
    points_ind = zeros(length(boundary_cell)+1,1);
    triangles_ind = zeros(length(boundary_cell)+1,1);
    points_ind(1) = size(zef.reuna_p{end},1);
    triangles_ind(1) = size(zef.reuna_t{end},1);
    compartments_ind(1) = length(reuna_t);

for i = 1 : length(boundary_cell)

    compartment_tag = boundary_cell{i};
    I = find(ismember(zef.compartment_tags,compartment_tag),1);
    points_ind(i+1) = size(zef.reuna_p{I},1);
    triangles_ind(i+1) = size(zef.reuna_t{I},1);
    compartments_ind(i+1) = I;

end

points_ind = cumsum(points_ind);
triangles_ind = cumsum(triangles_ind);

    end

if not(isempty(points_ind))
triangles_out = zeros(triangles_ind(end),3);
points_out = zeros(points_ind(end),3);
triangles_out(1:triangles_ind(1),:) = zef.reuna_t{end};
points_out(1:triangles_ind(1),:) = zef.reuna_p{end};
for i = 2 : length(points_ind)
triangles_out(triangles_ind(i-1)+1:triangles_ind(i),:) = reuna_t{compartments_ind(i)}+points_ind(i-1);
points_out(points_ind(i-1)+1:points_ind(i),:) = reuna_t{compartments_ind(i)};
end 
else
triangles_out = zef.reuna_t{end};
points_out = zef.reuna_p{end};
end


end