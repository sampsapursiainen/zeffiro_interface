function zef = zef_strip_tool_init(zef)

if not(isfield(zef.strip_tool,'current_strip'))
zef.strip_tool.current_strip = 1;
end

if not(isfield(zef,[zef.current_sensors '_strip_cell']))
zef.([zef.current_sensors '_strip_cell']) = cell(0);
zef.([zef.current_sensors '_strip_cell']){1} = struct;
zef.([zef.current_sensors '_strip_cell']){1}.strip_id = zef.strip_tool.strip_current_id;
elseif length(zef.([zef.current_sensors '_strip_cell'])) < zef.strip_tool.current_strip
 zef.([zef.current_sensors '_strip_cell']){zef.strip_tool.current_strip} = struct;
zef.([zef.current_sensors '_strip_cell']){zef.strip_tool.current_strip}.strip_id = zef.strip_tool.strip_current_id;   
end

if not(isfield(zef,'strip_tool'))
zef.strip_tool = struct;
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

if not(isfield(struct_aux,'encapsulation_shift'))
zef.strip_tool.h_encapsulation_shift_1.String = num2str(0); 
zef.strip_tool.h_encapsulation_shift_2.String = num2str(0); 
zef.strip_tool.h_encapsulation_shift_3.String = num2str(0);
else
zef.strip_tool.h_encapsulation_shift_1.String = num2str(struct_aux.encapsulation_shift(1));
zef.strip_tool.h_encapsulation_shift_2.String = num2str(struct_aux.encapsulation_shift(2));
zef.strip_tool.h_encapsulation_shift_3.String = num2str(struct_aux.encapsulation_shift(3));
end

if not(isfield(struct_aux,'orientation_axis'))
zef.strip_tool.h_orientation_axis_1.String = num2str(0); 
zef.strip_tool.h_orientation_axis_2.String = num2str(0); 
zef.strip_tool.h_orientation_axis_3.String = num2str(1);
else
zef.strip_tool.h_orientation_axis_1.String = num2str(struct_aux.orientation_axis{1}(1));
zef.strip_tool.h_orientation_axis_2.String = num2str(struct_aux.orientation_axis{1}(2));
zef.strip_tool.h_orientation_axis_3.String = num2str(struct_aux.orientation_axis{1}(3));
end

if not(isfield(struct_aux,'orientation_axis'))
zef.strip_tool.h_encapsulation_orientation_axis_1.String = num2str(0); 
zef.strip_tool.h_encapsulation_orientation_axis_2.String = num2str(0); 
zef.strip_tool.h_encapsulation_orientation_axis_3.String = num2str(1);
else
zef.strip_tool.h_encapsulation_orientation_axis_1.String = num2str(struct_aux.orientation_axis{2}(1));
zef.strip_tool.h_encapsulation_orientation_axis_2.String = num2str(struct_aux.orientation_axis{2}(2));
zef.strip_tool.h_encapsulation_orientation_axis_3.String = num2str(struct_aux.orientation_axis{2}(3));
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

if not(isfield(struct_aux,'encapsulation_thickness'))
zef.strip_tool.h_encapsulation_thickness.String = num2str(0.5); 
else
zef.strip_tool.h_encapsulation_thickness.String = num2str(struct_aux.encapsulation_thickness);
end

if not(isfield(struct_aux,'encapsulation_conductivity'))
zef.strip_tool.h_encapsulation_conductivity.String = num2str(0.33); 
else
zef.strip_tool.h_encapsulation_conductivity.String = num2str(struct_aux.encapsulation_conductivity);
end

if not(isfield(struct_aux,'strip_length'))
zef.strip_tool.h_strip_length.String = num2str(80); 
else
zef.strip_tool.h_strip_length.String = num2str(struct_aux.strip_length);
end

if not(isfield(struct_aux,'encapsulation_length'))
zef.strip_tool.h_encapsulation_length.String = num2str(80); 
else
zef.strip_tool.h_encapsulation_length.String = num2str(struct_aux.encapsulation_length);
end

if not(isfield(struct_aux,'encapsulation_on'))
zef.strip_tool.h_encapsulation_on.Value = 1; 
else
zef.strip_tool.h_encapsulation_on.Value = struct_aux.encapsulation_on;
end

if not(isfield(struct_aux,'strip_n_sectors'))
zef.strip_tool.h_strip_n_sectors.String = num2str(20); 
else
zef.strip_tool.h_strip_n_sectors.String = num2str(struct_aux.strip_n_sectors);
end

if not(isfield(struct_aux,'strip_conductivity'))
zef.strip_tool.h_strip_conductivity.String = num2str(1e-15); 
else
zef.strip_tool.h_strip_conductivity.String = num2str(struct_aux.strip_conductivity);    
end

if not(isfield(struct_aux,'strip_angle'))
zef.strip_tool.h_strip_angle.String = num2str(0); 
else
zef.strip_tool.h_strip_angle.String = num2str(struct_aux.strip_angle);
end

if isfield(struct_aux,'strip_status')
    if isequal(struct_aux.strip_status,'Embedded')
       zef.strip_tool.h_tip_point_1.Enable = 'off';
                        zef.strip_tool.h_tip_point_2.Enable = 'off';
                        zef.strip_tool.h_tip_point_3.Enable = 'off';
                 zef.strip_tool.h_orientation_axis_1.Enable = 'off';
                 zef.strip_tool.h_orientation_axis_2.Enable = 'off';
                 zef.strip_tool.h_orientation_axis_3.Enable = 'off';
                        zef.strip_tool.h_strip_model.Enable = 'off';
                          zef.strip_tool.h_strip_tag.Enable = 'off';
                   zef.strip_tool.h_strip_impedance.Enable = 'off';
                    zef.strip_tool.h_strip_n_sectors.Enable = 'off';
                       zef.strip_tool.h_strip_length.Enable = 'off';
                    zef.strip_tool.h_embed.Enable = 'off';
                        zef.strip_tool.h_strip_angle.Enable = 'off';
                 zef.strip_tool.h_strip_conductivity.Enable = 'off';
              zef.strip_tool.h_encapsulation_shift_1.Enable = 'off';
              zef.strip_tool.h_encapsulation_shift_2.Enable = 'off';
              zef.strip_tool.h_encapsulation_shift_3.Enable = 'off';
                   zef.strip_tool.h_encapsulation_on.Enable = 'off';
   zef.strip_tool.h_encapsulation_orientation_axis_1.Enable = 'off';
   zef.strip_tool.h_encapsulation_orientation_axis_2.Enable = 'off';
   zef.strip_tool.h_encapsulation_orientation_axis_3.Enable = 'off';
         zef.strip_tool.h_encapsulation_conductivity.Enable = 'off';
               zef.strip_tool.h_encapsulation_length.Enable = 'off';
            zef.strip_tool.h_encapsulation_thickness.Enable = 'off';
                         zef.strip_tool.h_strip_mode.Enable = 'off';
    else
       zef.strip_tool.h_tip_point_1.Enable = 'on';
                        zef.strip_tool.h_tip_point_2.Enable = 'on';
                        zef.strip_tool.h_tip_point_3.Enable = 'on';
                 zef.strip_tool.h_orientation_axis_1.Enable = 'on';
                 zef.strip_tool.h_orientation_axis_2.Enable = 'on';
                 zef.strip_tool.h_orientation_axis_3.Enable = 'on';
                        zef.strip_tool.h_strip_model.Enable = 'on';
                          zef.strip_tool.h_strip_tag.Enable = 'on';
                   zef.strip_tool.h_strip_impedance.Enable = 'on';
                    zef.strip_tool.h_strip_n_sectors.Enable = 'on';
                       zef.strip_tool.h_strip_length.Enable = 'on';
                    zef.strip_tool.h_embed.Enable = 'on';
                        zef.strip_tool.h_strip_angle.Enable = 'on';
                 zef.strip_tool.h_strip_conductivity.Enable = 'on';
              zef.strip_tool.h_encapsulation_shift_1.Enable = 'on';
              zef.strip_tool.h_encapsulation_shift_2.Enable = 'on';
              zef.strip_tool.h_encapsulation_shift_3.Enable = 'on';
                   zef.strip_tool.h_encapsulation_on.Enable = 'on';
   zef.strip_tool.h_encapsulation_orientation_axis_1.Enable = 'on';
   zef.strip_tool.h_encapsulation_orientation_axis_2.Enable = 'on';
   zef.strip_tool.h_encapsulation_orientation_axis_3.Enable = 'on';
         zef.strip_tool.h_encapsulation_conductivity.Enable = 'on';
               zef.strip_tool.h_encapsulation_length.Enable = 'on';
            zef.strip_tool.h_encapsulation_thickness.Enable = 'on';
                         zef.strip_tool.h_strip_mode.Enable = 'on';
    end
end

zef.([zef.current_sensors '_strip_cell']){zef.strip_tool.current_strip} = struct_aux;

end



