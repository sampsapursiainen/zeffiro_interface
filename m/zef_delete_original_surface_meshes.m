zef.fieldnames = fieldnames(zef);
zef = rmfield(zef,zef.fieldnames(find(contains(zef.fieldnames, 'original_surface_mesh'))));
zef = rmfield(zef,{'fieldnames'});
