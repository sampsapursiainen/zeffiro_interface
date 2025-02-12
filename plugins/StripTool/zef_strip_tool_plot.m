function zef_strip_tool_plot(zef)

strip_struct = zef.([zef.current_sensors '_strip_cell']){zef.strip_tool.current_strip};
[strip_struct] = zef_create_strip(strip_struct);
points = zef_strip_coordinate_transform(strip_struct,'forward');

axes(zef.h_axes1)

h_strip = findobj(zef.h_axes1.Children,'Tag','additional: strip');
h_strip_contact = findobj(zef.h_axes1.Children,'Tag','additional: strip contact');
h_strip_encapsulation = findobj(zef.h_axes1.Children,'Tag','additional: strip encapsulation');

if not(isempty(h_strip))
    delete(h_strip)
end

if not(isempty(h_strip_contact))
    delete(h_strip_contact)
end

if not(isempty(h_strip_encapsulation))
    delete(h_strip_encapsulation)
end

hold on

triangle_ind = [1:size(strip_struct.triangles{1},1)];


if strip_struct.encapsulation_on

h_strip_encapsulation = trimesh(strip_struct.triangles{2},points{2}(:,1),points{2}(:,2),points{2}(:,3));
h_strip_encapsulation.FaceColor = [0 1 0];
h_strip_encapsulation.EdgeColor = 'none';
h_strip_encapsulation.Tag = 'additional: strip encapsulation';

end

for i = 1 : strip_struct.strip_n_contacts

[contacts, ~, triangle_ind_aux] = zef_get_strip_contacts(i,strip_struct,zef);
h_strip_contact = trimesh(contacts(:,1:3),points{1}(:,1),points{1}(:,2),points{1}(:,3));
h_strip_contact.FaceColor = [0 0 0];
h_strip_contact.EdgeColor = 'none';
h_strip_contact.Tag = 'additional: strip contact';
triangle_ind = setdiff(triangle_ind, triangle_ind_aux);

end

h_strip = trimesh(strip_struct.triangles{1}(triangle_ind,:),points{1}(:,1),points{1}(:,2),points{1}(:,3));
h_strip.FaceColor = [0 1 1];
h_strip.EdgeColor = 'none';
h_strip.Tag = 'additional: strip';

hold off

end