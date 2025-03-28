zef.source_direction_mode = 1;
zef.inv_sampling_frequency = 2400;
zef.inv_low_cut_frequency = 0;
zef.inv_high_cut_frequency = 0;
evalin('base',['zef.' zef.compartment_tags{1} '_sources = 3;']);
evalin('base',['zef.' zef.compartment_tags{2} '_sources = 2;']);
zef = zef_build_compartment_table(zef);
zef_mesh_tool;
zef = zef_process_meshes(zef);
zef = zef_downsample_surfaces(zef);
zef = zef_process_meshes(zef);
zef = zef_source_interpolation(zef);