function zef_strip_tool_plot(zef)

strip_struct = zef.([zef.current_sensors '_strip_cell']){zef.strip_tool.current_strip};
[strip_struct] = zef_create_strip(strip_struct);
points = zef_strip_coordinate_transform(strip_struct,'forward');

axes(zef.h_axes1)

h_strip = findobj(zef.h_axes1.Children,'Tag','additional: strip');
h_strip_contact = findobj(zef.h_axes1.Children,'Tag','additional: strip contact');

if not(isempty(h_strip))
    delete(h_strip)
end

if not(isempty(h_strip_contact))
    delete(h_strip_contact)
end

hold on
h_strip = trimesh(strip_struct.triangles,points(:,1),points(:,2),points(:,3));
h_strip.FaceColor = [0 1 1];
h_strip.EdgeColor = 'none';
h_strip.Tag = 'additional: strip';

for i = 1 : strip_struct.strip_n_contacts

[triangles] = zef_get_strip_contacts(i,strip_struct,zef);
h_strip_contact = trimesh(triangles,points(:,1),points(:,2),points(:,3));
h_strip_contact.FaceColor = [0 0 0];
h_strip_contact.EdgeColor = 'none';
h_strip_contact.Tag = 'additional: strip contact';

end

hold off

end