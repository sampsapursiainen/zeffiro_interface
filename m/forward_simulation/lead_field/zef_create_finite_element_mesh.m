function zef = zef_create_finite_element_mesh(zef)

if nargin == 0
    zef = evalin('base','zef');
end 

if zef.downsample_surfaces == 1
    zef = zef_downsample_surfaces(zef);
end
zef = zef_process_meshes(zef);
zef = zef_create_fem_mesh(zef);
zef = zef_postprocess_fem_mesh(zef);
zef.n_sources_mod = 1;
zef.source_ind = [];
zef = zef_update(zef);

if nargout == 0
    assignin('base','zef',zef);
end

end
