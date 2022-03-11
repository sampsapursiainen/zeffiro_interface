function zef_create_sensors(sensor_tag, varargin)

if isequal(sensor_tag,'s') || isequal(sensor_tag,'s1')
evalin('base',['zef.current_sensors =''' sensor_tag ''';']);
end
zef_struct_name = 'zef';
field_cell_update = cell(0);
if not(isempty(varargin))
    zef_struct_name = varargin{1};
    if length(varargin) > 1
field_cell_update = varargin{2};
    end
end

field_cell_default =  {{'on', '1'}
{'color', '[0.1 0.1 0.1]'}
    {'visible', '0'   }
    {'directions', '[]' }
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
    {'imaging_method_name',['''' evalin('base',[zef_struct_name '.imaging_method_cell{' zef_struct_name '.imaging_method}' ]) '''']}
    {'name_list','[]'}
    {'visible_list','[]'}
    {'names_visible','1'}
    {'color_table','[]'}};

for i = 1 : length(field_cell_default)

evalin('base',[zef_struct_name '.' sensor_tag '_' field_cell_default{i}{1} '=' field_cell_default{i}{2} ';' ]);

end

for i = 1 : length(field_cell_update)

evalin('base',[zef_struct_name '.' sensor_tag '_' field_cell_update{i}{1} '=[' field_cell_update{i}{2} '];' ]);

end

evalin('base',[zef_struct_name '.sensor_tags = ['''  sensor_tag ''',' zef_struct_name '.sensor_tags];']);
