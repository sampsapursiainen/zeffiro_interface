function zef = zef_strip_tool_embed(zef)

cell_aux = zef.([zef.current_sensors '_strip_cell']);

i = zef.strip_tool.current_strip;

cell_aux{i}.compartment_tag = cell(0);

[strip_struct] = zef_create_strip(cell_aux{i});
points = zef_strip_coordinate_transform(strip_struct,'forward');

if cell_aux{i}.encapsulation_on 

zef = zef_add_compartment(zef);
cell_aux{i}.compartment_tag{2} = zef.compartment_tags{1};
zef.([zef.compartment_tags{1} '_name']) =  ['Encapsulation, ID: ' num2str(cell_aux{i}.strip_id) ', Tag: ' cell_aux{i}.strip_tag ', Model: ' zef.strip_tool.h_strip_model.String{cell_aux{i}.strip_model} ];
zef.([zef.compartment_tags{1} '_triangles']) = strip_struct.triangles{2};
zef.([zef.compartment_tags{1} '_points']) = points{2};
zef = zef_update_compartment_table_data(zef);

end

zef = zef_add_compartment(zef);
cell_aux{i}.compartment_tag{1} = zef.compartment_tags{1};
zef.([zef.compartment_tags{1} '_name']) =  ['Strip, ID: ' num2str(cell_aux{i}.strip_id) ', Tag: ' cell_aux{i}.strip_tag ', Model: ' zef.strip_tool.h_strip_model.String{cell_aux{i}.strip_model} ];
zef.([zef.compartment_tags{1} '_triangles']) = strip_struct.triangles{1};
zef.([zef.compartment_tags{1} '_points']) = points{1};
zef = zef_update_compartment_table_data(zef);

cell_aux{i}.strip_status = 'Embedded';

zef.([zef.current_sensors '_strip_cell']) = cell_aux;

zef = zef_strip_tool_init(zef);
zef = zef_strip_tool_update(zef);

end