function self = create_finite_element_mesh( ...
    self, ...
    n_of_surface_refinements, ...
    n_of_volume_refinements, ...
    n_of_adaptive_volume_refinements, ...
    adaptive_tolerance, ...
    adaptive_iteration_param ...
)

    % create_finite_element_mesh
    %
    % Calls the functions needed to construct a finite element mesh with the
    % specified arguments.
    %
    % Inputs:
    %
    % - self
    %
    %   The instance of Zef that called this method.
    %
    % - n_of_surface_refinements
    %
    %   The number of surface refinements that are to be performed by the
    %   surface refinement routine.
    %
    %   default = 0
    %
    % - n_of_volume_refinements
    %
    %   The number of volume refinements that are to be performed by the
    %   surface refinement routine.
    %
    %   default = 0
    %
    % - n_of_adaptive_volume_refinements
    %
    %   The number of adaptive volume refinements that are to be performed by
    %   the surface refinement routine.
    %
    %   default = 0
    %
    % - adaptive_tolerance
    %
    %   The adaptive tolerance used by the adaptive volume refinement routine.
    %
    %   default = 1 (mm)
    %
    % - adaptive_iteration_param
    %
    %   The maximum number of iterations used by the adaptive volume
    %   refinement routine.
    %
    %   default = 10
    %
    % Outputs:
    %
    % - self
    %
    %   The instance of Zef that called this method. The generated mesh is
    %   stored within and can be retrieved with the method Zef.get_mesh.

    arguments
        self zef_as_class.Zef
        n_of_surface_refinements (1,1) double { mustBeInteger, mustBeNonnegative } = 0;
        n_of_volume_refinements (1,1) double { mustBeInteger, mustBeNonnegative }  = 0;
        n_of_adaptive_volume_refinements (1,1) double { mustBeInteger, mustBeNonnegative }  = 0;
        adaptive_tolerance (1,1) double { mustBeReal, mustBeNonnegative }  = 1;
        adaptive_iteration_param (1,1) double { mustBeInteger, mustBeNonnegative }  = 10;
    end

    if self.surface_downsampling_on
        self = self.downsample_surfaces();
    end

    self = self ...
        .preprocess_mesh() ...
        .build_initial_mesh() ...
        .label_mesh("initial") ...
        .refine_surface(n_of_surface_refinements) ...
        .refine_volume(n_of_volume_refinements) ...
        .refine_volume_adaptively(n_of_adaptive_volume_refinements) ...
        .postprocess_fem_mesh() ...
        .with_mesh_generation_phase("done");

    self.data.n_sources_mod = 1;

    self.data.source_ind = [];

end
