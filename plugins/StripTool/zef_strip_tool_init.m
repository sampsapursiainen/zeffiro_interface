function zef = zef_strip_tool_init(zef)

if not(isfield(zef,[zef.current_sensors '_strip_cell']))
zef.([zef.current_sensors '_strip_cell']) = cell(0);
zef.([zef.current_sensors '_strip_cell']){1} = struct;
zef.([zef.current_sensors '_strip_cell']){1}.strip_id = zef.strip_tool.strip_current_id;
end

if not(isfield(zef,'strip_tool'))
zef.strip_tool = struct;
end

if not(isfield(zef.strip_tool,'current_strip'))
zef.strip_tool.current_strip = 1;
end

struct_aux = zef.([zef.current_sensors '_strip_cell']){zef.strip_tool.current_strip};

if not(isfield(struct_aux,'tip_point'))
zef.strip_tool.h_tip_point_1.String = num2str(0); 
zef.strip_tool.h_tip_point_2.String = num2str(0); 
zef.strip_tool.h_tip_point_3.String = num2str(0);
else
zef.strip_tool.h_tip_point_1.String = num2str(struct_aux.tip_point(1));
zef.strip_tool.h_tip_point_2.String = num2str(struct_aux.tip_point(2));
zef.strip_tool.h_tip_point_3.String = num2str(struct_aux.tip_point(3));
end

if not(isfield(struct_aux,'orientation_axis'))
zef.strip_tool.h_orientation_axis_1.String = num2str(0); 
zef.strip_tool.h_orientation_axis_2.String = num2str(0); 
zef.strip_tool.h_orientation_axis_3.String = num2str(1);
else
zef.strip_tool.h_orientation_axis_1.String = num2str(struct_aux.orientation_axis(1));
zef.strip_tool.h_orientation_axis_2.String = num2str(struct_aux.orientation_axis(2));
zef.strip_tool.h_orientation_axis_3.String = num2str(struct_aux.orientation_axis(3));
end

if not(isfield(struct_aux,'strip_mode'))
zef.strip_tool.h_strip_mode.String = num2str(1); 
else
zef.strip_tool.h_strip_mode.String = struct_aux.strip_mode;
end

if not(isfield(struct_aux,'strip_tag'))
zef.strip_tool.h_strip_tag.String = ''; 
else
zef.strip_tool.h_strip_tag.String = struct_aux.strip_tag;
end

if not(isfield(struct_aux,'strip_impedance'))
zef.strip_tool.h_strip_impedance.String = num2str(1000); 
else
zef.strip_tool.h_strip_impedance.String = num2str(struct_aux.strip_impedance);
end

if not(isfield(struct_aux,'strip_length'))
zef.strip_tool.h_strip_length.String = num2str(80); 
else
zef.strip_tool.h_strip_length.String = num2str(struct_aux.strip_length);
end

if not(isfield(struct_aux,'strip_n_sectors'))
zef.strip_tool.h_strip_n_sectors.String = num2str(20); 
else
zef.strip_tool.h_strip_n_sectors.String = num2str(struct_aux.strip_n_sectors);
end

if not(isfield(struct_aux,'strip_conductivity'))
struct_aux.strip_conductivity = 1e-15; 
end

if not(isfield(struct_aux,'strip_angle'))
zef.strip_tool.h_strip_angle.String = num2str(0); 
else
zef.strip_tool.h_strip_angle.String = num2str(struct_aux.strip_angle);
end

zef.([zef.current_sensors '_strip_cell']){zef.strip_tool.current_strip} = struct_aux;



