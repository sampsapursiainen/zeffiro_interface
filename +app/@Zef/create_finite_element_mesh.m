function self = create_finite_element_mesh(self)

    % create_finite_element_mesh
    %
    % Calls the functions needed to construct a finite element mesh.

    arguments
        self app.Zef
    end

    if self.surface_downsampling_on
        self = self.downsample_surfaces();
    end

    self = process_meshes(self);

    self = create_fem_mesh(self);

    self = postprocess_fem_mesh(self);

    self.data.n_sources_mod = 1;

    self.data.source_ind = [];

end