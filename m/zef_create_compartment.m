function zef = zef_create_compartment(zef,compartment_tag, varargin)

n_compartments = eval('length(zef.compartment_tags)');
color_default = [ 0.3984    0.7615    0.4435 ;
                  0.5810    0.4690    0.3430 ; 
                   0.7000    0.7000    0.6000 ; 
                   0.4200    0.4800    0.4200 ;
                    0.3500    0.3500    0.3500 ;
                     0.8000    0.8000    0.8000];
                          

rng('default');
rng(n_compartments);
rand_aux = randperm(500);
rng(rand_aux(1));
zef_struct_name = 'zef';
field_cell_update = cell(0);
if not(isempty(varargin))
    zef_struct_name = varargin{1};
    if length(varargin) > 1
field_cell_update = varargin{2};
    end
end

field_cell_default =  {{'on', '1'       }
    {'color',   '0.2 + 0.8*rand(1,3)'   }
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
    {'affine_transform','{[1 0 0 0; 0 1 0 0; 0 0 1 0; 0 0 0 1]}'}
    {'transform_name','{''Transform 1''}'}};

if n_compartments < size(color_default,1)
field_cell_default{2}{2} = mat2str(color_default(n_compartments+1,:));
end

for i = 1 : length(field_cell_default)

eval([zef_struct_name '.' compartment_tag '_' field_cell_default{i}{1} '=' field_cell_default{i}{2} ';' ]);

end

for i = 1 : length(field_cell_update)

eval([zef_struct_name '.' compartment_tag '_' field_cell_update{i}{1} '=[' field_cell_update{i}{2} '];' ]);

end

eval([zef_struct_name '.compartment_tags = ['''  compartment_tag ''', ' zef_struct_name '.compartment_tags];']);

end
