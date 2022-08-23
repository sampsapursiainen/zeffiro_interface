if zef.downsample_surfaces == 1; zef_downsample_surfaces; end; zef_process_meshes; zef_create_fem_mesh; zef_postprocess_fem_mesh; zef.n_sources_mod = 1; zef.source_ind = []; zef_update_fig_details;
