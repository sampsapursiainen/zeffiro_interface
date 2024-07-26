function strip_struct = zef_create_strip(strip_struct)

strip_struct.orientation_axis = 1/norm(strip_struct.orientation_axis)*strip_struct.orientation_axis;
strip_struct = zef_get_strip_parameters(strip_struct);
[triangles, points] = zef_simple_cylinder_generator(strip_struct.strip_radius,strip_struct.strip_n_sectors,strip_struct.strip_length);
points(:,3) = points(:,3) + strip_struct.strip_length/2;
strip_struct.points = points;
strip_struct.triangles = triangles;

    strip_struct.rotation_angle = acos(dot([0 ; 0 ; 1], strip_struct.orientation_axis));
    if strip_struct.rotation_angle > 0
    strip_struct.rotation_axis = cross([0 ; 0 ; 1], strip_struct.orientation_axis);
    else 
    strip_struct.rotation_axis = [1; 0 ; 0];
    end
    strip_struct.rotation_axis = 1/norm(strip_struct.rotation_axis)*strip_struct.rotation_axis;
    strip_struct.orientation_axis_normal = cross(strip_struct.rotation_axis, strip_struct.orientation_axis);
   
end

