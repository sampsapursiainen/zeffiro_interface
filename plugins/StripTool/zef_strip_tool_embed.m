function zef = zef_strip_tool_embed(zef)

cell_aux = zef.([zef.current_sensors '_strip_cell']);

strip_struct = zef_get_strip_parameters(cell_aux{zef.strip_tool.current_strip});
[strip_struct] = zef_create_strip(strip_struct);
points = zef_strip_coordinate_transform(strip_struct,'forward');

strip_struct.compartment_tag = cell(0);

if strip_struct.encapsulation_on 

zef = zef_add_compartment(zef);
strip_struct.compartment_tag{2} = zef.compartment_tags{1};
zef.([zef.compartment_tags{1} '_name']) =  ['Encapsulation, ID: ' num2str(strip_struct.strip_id) ', Tag: ' strip_struct.strip_tag ', Model: ' zef.strip_tool.h_strip_model.String{strip_struct.strip_model} ];
zef.([zef.compartment_tags{1} '_triangles']) = strip_struct.triangles{2};
zef.([zef.compartment_tags{1} '_points']) = points{2};
zef.([zef.compartment_tags{1} '_sigma']) = strip_struct.encapsulation_conductivity;
zef = zef_update_compartment_table_data(zef);

end

zef = zef_add_compartment(zef);
strip_struct.compartment_tag{1} = zef.compartment_tags{1};
zef.([zef.compartment_tags{1} '_name']) =  ['Strip, ID: ' num2str(strip_struct.strip_id) ', Tag: ' strip_struct.strip_tag ', Model: ' zef.strip_tool.h_strip_model.String{strip_struct.strip_model} ];
zef.([zef.compartment_tags{1} '_triangles']) = strip_struct.triangles{1};
zef.([zef.compartment_tags{1} '_points']) = points{1};
zef.([zef.compartment_tags{1} '_sigma']) = strip_struct.strip_conductivity;

zef = zef_update_compartment_table_data(zef);

strip_struct.strip_status = 'Embedded';

cell_aux{zef.strip_tool.current_strip} = strip_struct;
zef.([zef.current_sensors '_strip_cell']) = cell_aux;

zef = zef_strip_tool_init(zef);
zef = zef_strip_tool_update(zef);

end