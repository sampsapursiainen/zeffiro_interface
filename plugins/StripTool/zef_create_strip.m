function strip_struct = zef_create_strip(strip_struct)

strip_struct = zef_get_strip_parameters(strip_struct);
[triangles{1}, points{1}] = zef_simple_cylinder_generator(strip_struct.strip_radius,strip_struct.strip_n_sectors,strip_struct.strip_length);
[triangles{2}, points{2}] = zef_simple_cylinder_generator(strip_struct.strip_radius+strip_struct.encapsulation_thickness,strip_struct.strip_n_sectors,strip_struct.encapsulation_length+2*strip_struct.encapsulation_thickness);
points{1}(:,3) = points{1}(:,3) + strip_struct.strip_length/2;
points{2}(:,3) = points{2}(:,3) + strip_struct.strip_length/2 - strip_struct.encapsulation_thickness;
strip_struct.points = points;
strip_struct.triangles = triangles;

for i = 1 : 2

    strip_struct.orientation_axis{i} = 1/norm(strip_struct.orientation_axis{i})*strip_struct.orientation_axis{i};

    strip_struct.rotation_angle{i} = acos(dot([0 ; 0 ; 1], strip_struct.orientation_axis{i}));
    if strip_struct.rotation_angle{i} > 0
    strip_struct.rotation_axis{i} = cross([0 ; 0 ; 1], strip_struct.orientation_axis{i});
    else 
    strip_struct.rotation_axis{i} = [1; 0 ; 0];
    end
    strip_struct.rotation_axis{i} = 1/norm(strip_struct.rotation_axis{i})*strip_struct.rotation_axis{i};
    strip_struct.orientation_axis_normal{i} = cross(strip_struct.rotation_axis{i}, strip_struct.orientation_axis{i});
   
end

end

