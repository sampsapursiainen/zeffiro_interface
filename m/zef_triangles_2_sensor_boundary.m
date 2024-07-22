function [triangles_out] = zef_triangles_2_sensor_boundary(zef,compartment_tag,triangles_in)

triangles_out = [];
    points_ind = []; 

    if isfield(zef,[zef.current_sensors '_boundary_cell'])

    boundary_cell = zef.([zef.current_sensors '_boundary_cell']);    
    points_ind = zeros(length(boundary_cell)+1,1);
    points_ind(1) = size(zef.reuna_p{end},1);

    end

for i = 1 : length(boundary_cell)

    compartment_tag_aux = boundary_cell{i};
    I = find(ismember(zef.compartment_tags,compartment_tag_aux),1);
    points_ind(i) = size(zef.reuna_p{I},1);

end

points_ind = cumsum(points_ind);
I = find(ismember(boundary_cell,compartment_tag),1);

if not(isempty(I))
triangles_out = points_ind(I-1)+triangles_in;
end

end
