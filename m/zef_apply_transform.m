for zef_i = 1 : length(zef.compartment_tags)
if eval(['zef.' zef.compartment_tags{zef_i} '_on'])
    if eval(['isfield(zef,''' zef.compartment_tags{zef_i} '_points_original_surface_mesh'')'])
   eval(['zef.' zef.compartment_tags{zef_i} '_points' '= zef.' zef.compartment_tags{zef_i} '_points_original_surface_mesh;'])
   eval(['zef.' zef.compartment_tags{zef_i} '_triangles' '= zef.' zef.compartment_tags{zef_i} '_triangles_original_surface_mesh;'])
  eval(['zef.' zef.compartment_tags{zef_i} '_submesh_ind' '= zef.' zef.compartment_tags{zef_i} '_submesh_ind_original_surface_mesh;'])
    end
end
end

zef = zef_process_meshes(zef);
zef.apply_transform_sensors = zef.sensors;
zef.apply_transform_reuna_p = zef.reuna_p; 
zef.apply_transform_reuna_t = zef.reuna_t; 

eval(['zef.' eval('zef.current_sensors') '_points = zef.apply_transform_sensors(:,1:3);']);

if ismember(eval('zef.imaging_method'),[2 3])
    eval(['zef.' eval('zef.current_sensors')  '_directions(:,1:3) = zef.apply_transform_sensors(:,4:6);']);
end

if size(eval(['zef.' eval('zef.current_sensors') '_directions']),2) == 6
eval(['zef.' eval('zef.current_sensors') '_directions(:,4:6) = zef.apply_transform_sensors(:,7:9);']);
end

eval(['zef.' eval('zef.current_sensors') '_scaling = 1;']);
eval(['zef.' eval('zef.current_sensors') '_x_correction = 0;']);
eval(['zef.' eval('zef.current_sensors') '_y_correction = 0;']);
eval(['zef.' eval('zef.current_sensors') '_z_correction = 0;']);
eval(['zef.' eval('zef.current_sensors') '_xy_rotation = 0;']);
eval(['zef.' eval('zef.current_sensors') '_yz_rotation = 0;']);
eval(['zef.' eval('zef.current_sensors') '_zx_rotation = 0;']);
eval(['zef.' eval('zef.current_sensors') '_affine_transform = {[1 0 0 0; 0 1 0 0; 0 0 1 0; 0 0 0 1]};']);

zef.apply_transform_compartment_tags = eval('zef.compartment_tags');
zef_k = 0;
for zef_i = 1 : length(zef.apply_transform_compartment_tags)

    if  eval(['zef.' zef.apply_transform_compartment_tags{zef_i} '_on'])
    zef_k = zef_k + 1;
        eval(['zef.'  zef.apply_transform_compartment_tags{zef_k} '_points = zef.apply_transform_reuna_p{' num2str(zef_k) '};']);
        eval(['zef.'  zef.apply_transform_compartment_tags{zef_k} '_triangles = zef.apply_transform_reuna_t{' num2str(zef_k) '};']);

        eval(['zef.'  zef.apply_transform_compartment_tags{zef_k} '_scaling = 1;']);
        eval(['zef.'  zef.apply_transform_compartment_tags{zef_k} '_x_correction = 0;']);
        eval(['zef.'  zef.apply_transform_compartment_tags{zef_k} '_y_correction = 0;']);
        eval(['zef.'  zef.apply_transform_compartment_tags{zef_k} '_z_correction = 0;']);
        eval(['zef.'  zef.apply_transform_compartment_tags{zef_k} '_xy_rotation = 0;']);
        eval(['zef.'  zef.apply_transform_compartment_tags{zef_k} '_yz_rotation = 0;']);
        eval(['zef.'  zef.apply_transform_compartment_tags{zef_k} '_zx_rotation = 0;']);
        eval(['zef.'  zef.apply_transform_compartment_tags{zef_k} '_affine_transform = {[1 0 0 0; 0 1 0 0; 0 0 1 0; 0 0 0 1]};']);

    end

end

for zef_i = 1 : length(zef.compartment_tags)
    if eval(['zef.' zef.compartment_tags{zef_i} '_on'])
if eval(['isfield(zef,''' zef.compartment_tags{zef_i} '_points_original_surface_mesh'')'])
   eval(['zef.' zef.compartment_tags{zef_i} '_points_original_surface_mesh' '= zef.' zef.compartment_tags{zef_i} '_points;']);
    eval(['zef.' zef.compartment_tags{zef_i} '_triangles_original_surface_mesh' '= zef.' zef.compartment_tags{zef_i} '_triangles;']);
    eval(['zef.' zef.compartment_tags{zef_i} '_submesh_ind_original_surface_mesh' '= zef.' zef.compartment_tags{zef_i} '_submesh_ind;']);
end
    end
end

zef = rmfield(zef,{'apply_transform_sensors','apply_transform_reuna_p','apply_transform_reuna_t','apply_transform_compartment_tags'});
zef_update;
zef_update_transform;
clear zef_i zef_k;
