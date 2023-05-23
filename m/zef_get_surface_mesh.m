
if not(isequal(zef.file,0))
    [zef.aux_points,zef.aux_triangles,zef.aux_submesh_ind] = zef_get_mesh(zef,[zef.file_path zef.file],zef.current_compartment,zef.surface_mesh_type,'full');
    eval(['zef.' zef.current_compartment '_points = zef.aux_points;']);
    eval(['zef.' zef.current_compartment '_triangles = zef.aux_triangles;']);
    eval(['zef.' zef.current_compartment '_submesh_ind = zef.aux_submesh_ind;']);

    eval(['zef.' zef.current_compartment '_points_original_surface_mesh = zef.aux_points;']);
    eval(['zef.' zef.current_compartment '_triangles_original_surface_mesh = zef.aux_triangles;']);
    eval(['zef.' zef.current_compartment '_submesh_ind_original_surface_mesh = zef.aux_submesh_ind;']);

    zef = rmfield(zef,{'aux_points','aux_triangles','aux_submesh_ind'});
end;
