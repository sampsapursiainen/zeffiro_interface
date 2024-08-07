function zef = zef_strip_tool_add_contacts(zef)

points_1 = zef.([zef.current_sensors '_points']);
impedance_1 = zef.([zef.current_sensors '_electrode_impedance']);
inner_radius_1 = zef.([zef.current_sensors '_electrode_inner_radius']);
outer_radius_1 = zef.([zef.current_sensors '_electrode_outer_radius']);

strip_struct = zef.([zef.current_sensors '_strip_cell']);
strip_struct = strip_struct{zef.strip_tool.current_strip};
strip_struct = zef_get_strip_parameters(strip_struct);
strip_struct = zef_create_strip(strip_struct);

points_2 = zeros(strip_struct.strip_n_contacts, 3);

for i = 1 : strip_struct.strip_n_contacts

points_2(i,:) = zef_get_strip_contacts(i,strip_struct,zef,'points');

end

if not(isempty(points_1))
points_2 = points_2(:,1:size(points_1,2));
end

zef.([zef.current_sensors '_points']) = [points_1 ; points_2];
zef.([zef.current_sensors '_electrode_impedance']) = [impedance_1 ; strip_struct.strip_impedance*ones(size(points_2,1),1)];
zef.([zef.current_sensors '_electrode_inner_radius']) = [inner_radius_1 ; zeros(size(points_2,1),1)];
zef.([zef.current_sensors '_electrode_outer_radius']) = [outer_radius_1 ; zeros(size(points_2,1),1)];
zef = zef_init_sensors_name_table(zef);

current_strip_string = num2str(zef.strip_tool.current_strip);
for i = 1 : size(points_2,1)
zef.([zef.current_sensors '_get_functions']){i+size(points_1,1)} = ['zef_get_strip_contacts(' num2str(i) ',project_struct.' zef.current_sensors '_strip_cell{' current_strip_string '}, project_struct, domain_type,' num2str(size(points_1,1)+1) ');'];
end

end