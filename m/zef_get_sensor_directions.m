if not(isequal(zef.file,0));
zef.aux_field = zef_get_mesh([zef.file_path zef.file],zef.current_sensors,'triangles');
evalin('base',['zef.' zef.current_sensors '_directions = zef.aux_field;']);
zef = rmfield(zef,'aux_field');
end;
