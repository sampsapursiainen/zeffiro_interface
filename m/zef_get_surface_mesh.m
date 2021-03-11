zef.file = 0;
[zef.file zef.file_path zef.surface_mesh_type] = zef_import_surface_mesh_type; 

if not(isequal(zef.file,0));
[zef.aux_points,zef.aux_triangles,zef.aux_submesh_ind] = zef_get_mesh([zef.file_path zef.file], zef.current_compartment, zef.surface_mesh_type,'full'); 

evalin('base',['zef.' zef.current_compartment '_points = [' num2str(zef.aux_points(:)') '];']);
evalin('base',['zef.' zef.current_compartment '_triangles = [' num2str(zef.aux_triangles(:)') '];']);
evalin('base',['zef.' zef.current_compartment '_submesh_ind = [' num2str(zef.aux_submesh_ind) '];']);
evalin('base',['zef.' zef.current_compartment '_points = reshape(zef.' zef.current_compartment '_points, length(' 'zef.' zef.current_compartment '_points)/3,3);']);
evalin('base',['zef.' zef.current_compartment '_triangles = reshape(zef.' zef.current_compartment '_triangles, length(' 'zef.' zef.current_compartment '_triangles)/3,3);']);
zef = rmfield(zef,{'aux_points','aux_triangles','aux_submesh_ind'});
end; 
