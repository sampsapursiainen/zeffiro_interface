function zef_create_sensors(sensor_tag, varargin)

zef_struct_name = 'zef';
field_cell_update = cell(0);
if not(isempty(varargin))
    zef_struct_name = varargin{1};
    if length(varargin) > 1
field_cell_update = varargin{2};
    end
end


field_cell_default =  {{'on', '1'       }
{'color', '[0.1 0.1 0.1]'       }
    {'visible', '1'   }
    {'directions', '[]' }
     {'directions_g', '[]' }
    {'points'  , '[]'  }
    {'merge'  , '0'  }
    {'invert'  , '0'  }
    {'name'    , ['[''Sensors ''  num2str(length(' zef_struct_name '.sensor_tags) + 1)]'] }
    {'scaling'  , '1'   }
    {'zx_rotation', '0' }
    {'yz_rotation', '0' }
    {'xy_rotation', '0' }
    {'z_correction', '0'}
    {'y_correction', '0'}
    {'x_correction', '0'}
    {'transform_name','{''Transform 1''}'}
    {'type','''EEG'''},
    {'name_list','[]'},};

for i = 1 : length(field_cell_default)

evalin('base',[zef_struct_name '.' sensor_tag '_' field_cell_default{i}{1} '=' field_cell_default{i}{2} ';' ]); 

end

for i = 1 : length(field_cell_update)

evalin('base',[zef_struct_name '.' sensor_tag '_' field_cell_update{i}{1} '=[' field_cell_update{i}{2} '];' ]); 

end

evalin('base',[zef_struct_name '.sensor_tags = ['''  sensor_tag ''',' zef_struct_name '.sensor_tags];']);