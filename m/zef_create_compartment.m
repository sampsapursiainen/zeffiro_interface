function zef_create_compartment(compartment_tag, varargin)

zef_struct_name = 'zef';
field_cell_update = cell(0);
if not(isempty(varargin))
    zef_struct_name = varargin{1};
    if length(varargin) > 1
field_cell_update = varargin{2};
    end
end

field_cell_default =  {{'on', '1'       }
    {'color',   '0.3 + 0.7*rand(1,3)'   }
    {'priority', ['length(' zef_struct_name '.compartment_tags) + 1']   }
    {'sources',  '0'  }
    {'sources_old', '-1'}
    {'visible', '1'   }
    {'triangles', '[]' }
    {'points'  , '[]'  }
    {'sigma'    ,'0.33'  }
    {'name'    , ['[''Compartment ''  num2str(length(' zef_struct_name '.compartment_tags) + 1)]'] }
    {'submesh_ind', '[]'}
    {'points_inf','[]' }
    {'merge'    ,  '1' }
    {'invert'  , '0'   }
    {'scaling'  , '1'   }
    {'zx_rotation', '0' }
    {'yz_rotation', '0' }
    {'xy_rotation', '0' }
    {'z_correction', '0'}
    {'y_correction', '0'}
    {'x_correction', '0'}
    {'transform_name','{''Transform 1''}'}};

for i = 1 : length(field_cell_default)

evalin('base',[zef_struct_name '.' compartment_tag '_' field_cell_default{i}{1} '=' field_cell_default{i}{2} ';' ]);

end

for i = 1 : length(field_cell_update)

evalin('base',[zef_struct_name '.' compartment_tag '_' field_cell_update{i}{1} '=[' field_cell_update{i}{2} '];' ]);

end

evalin('base',[zef_struct_name '.compartment_tags = ['''  compartment_tag ''',' zef_struct_name '.compartment_tags];']);