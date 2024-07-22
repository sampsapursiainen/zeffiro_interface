function [strip_struct] = zef_create_strip(tip_point, orientation_axis, strip_length, n_sectors, strip_model, compartment_tag)

strip_struct = struct;
orientation_axis = orientation_axis(:);
tip_point = tip_point(:);
orientation_axis = 1/norm(orientation_axis)*orientation_axis;
strip_struct.tip_point = tip_point;
strip_struct.orientation_axis = orientation_axis;
strip_struct.n_sectors = n_sectors;
strup_struct.strip_length = strip_length; 
strip_struct.strip_model = strip_model;
strip_struct.compartment_tag = compartment_tag;

strip_struct = zef_get_strip_parameters(strip_struct);


   [triangles, points] = zef_simple_cylinder_generator(strip_struct.strip_radius,n_sectors,strip_length);

    points(:,3) = points(:,3) + strip_length/2;
    
    strip_struct.points = points;
    strip_struct.triangles = triangles;

    rotation_angle = acos(dot([0 ; 0 ; 1], orientation_axis));
    if rotation_angle > 0
    rotation_axis = cross([0 ; 0 ; 1], orientation_axis);
    else 
    rotation_axis = [1; 0 ; 0];
    end
    rotation_axis = 1/norm(rotation_axis)*rotation_axis;
    orientation_axis_normal = cross(rotation_axis, orientation_axis);

    strip_struct.orientation_axis_normal = orientation_axis_normal;
    strip_struct.rotation_axis = rotation_axis;
    strip_struct.rotation_angle = rotation_angle;
    
strip_struct.points = zef_strip_coordinate_transform(strip_struct,'forward') 

   
end

