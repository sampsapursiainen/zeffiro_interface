function project_struct = lead_field_example ( kwargs, mesh_kwargs, lead_field_kwargs )
%
% examples.lead_field_example ( kwargs )
%
% Demonstrates how one might construct a lead field matrix with Zeffirro
% Interface, from the Matlab command line. Look into the wiki page
% https://github.com/sampsapursiainen/zeffiro_interface/wiki/Lead-field-generation
% to find out what the different input values mean.
%

    arguments
        kwargs.start_mode = "nodisplay"
        kwargs.input_project_path (1,1) string { mustBeFile } = fullfile ( "data", "segmentations", "multicompartment_head_project", "import_segmentation.zef" )
        kwargs.output_project_dir (1,:) char { mustBeFolder } = "data"
        kwargs.output_project_file (1,:) char = "lead_field_example.mat"
        kwargs.use_gpu (1,1) logical = true
        % Meshing-related input values.
        %
        % The restrictions of these are already defined in the meshing example,
        % so we only need to repeat the default values, if we don't want the
        % user to have to give them as arguments to this function.
        mesh_kwargs.adaptive_refinement_compartments = -1
        mesh_kwargs.adaptive_refinement_k_param = 5
        mesh_kwargs.adaptive_refinement_number = 1
        mesh_kwargs.adaptive_refinement_on = false
        mesh_kwargs.adaptive_refinement_thresh_val = 2
        mesh_kwargs.exclude_box = true
        mesh_kwargs.fem_mesh_inflation_strength = 0.05
        mesh_kwargs.fix_outer_surface = true
        mesh_kwargs.initial_mesh_mode = 1
        mesh_kwargs.mesh_labeling_approach = 1
        mesh_kwargs.mesh_optimization_parameter = 1e-5
        mesh_kwargs.mesh_optimization_repetitions = 10
        mesh_kwargs.mesh_relabeling = true
        mesh_kwargs.mesh_resolution = 4.5
        mesh_kwargs.mesh_smoothing_on = true;
        mesh_kwargs.mesh_smoothing_repetitions = 1
        mesh_kwargs.meshing_threshold = 0.25
        mesh_kwargs.pml_max_size = 2
        mesh_kwargs.pml_max_size_unit = 1
        mesh_kwargs.pml_outer_radius = 1.1
        mesh_kwargs.pml_outer_radius_unit = 1
        mesh_kwargs.reduce_labeling_outliers = true
        mesh_kwargs.refinement_on = true;
        mesh_kwargs.refinement_surface_compartments = [10 -1 1 18 17]
        mesh_kwargs.refinement_surface_compartments_2 = -1
        mesh_kwargs.refinement_surface_number = 1
        mesh_kwargs.refinement_surface_number_2 = 1
        mesh_kwargs.refinement_surface_on = true
        mesh_kwargs.refinement_surface_on_2 = false
        mesh_kwargs.refinement_volume_compartments = -1
        mesh_kwargs.refinement_volume_compartments_2 = -1
        mesh_kwargs.refinement_volume_number = 1
        mesh_kwargs.refinement_volume_number_2 = 1
        mesh_kwargs.refinement_volume_on = false
        mesh_kwargs.refinement_volume_on_2 = false
        mesh_kwargs.smoothing_steps_ele = 0.2
        mesh_kwargs.smoothing_steps_surf = 0.10
        mesh_kwargs.smoothing_steps_vol = 0.90
        mesh_kwargs.use_fem_mesh_inflation = true
        % Lead field input values.
        lead_field_kwargs.acceptable_source_depth (1,1) double { mustBeNonnegative } = 0
        lead_field_kwargs.lead_field_filter_quantile (1,1) double { mustBeGreaterThanOrEqual( lead_field_kwargs.lead_field_filter_quantile, 0 ), mustBeLessThanOrEqual( lead_field_kwargs.lead_field_filter_quantile, 1 ) } = 1
        lead_field_kwargs.lead_field_type (1,1) double { mustBeMember ( lead_field_kwargs.lead_field_type, [ 1, 2, 3, 4, 5 ] ) } = 1
        lead_field_kwargs.lf_normalization (1,1) double { mustBeMember ( lead_field_kwargs.lf_normalization, [1, 2, 3, 4] ) } = 1
        lead_field_kwargs.location_unit (1,1) double { mustBeMember( lead_field_kwargs.location_unit, [1,2,3]) } = 1
        lead_field_kwargs.n_sources (1,1) double { mustBePositive } = 1e4
        lead_field_kwargs.optimization_system_type (1,:) string { mustBeMember ( lead_field_kwargs.optimization_system_type, [ "pbo", "mpo" ] ) } = "pbo"
        lead_field_kwargs.preconditioner (1,1) double { mustBeMember ( lead_field_kwargs.preconditioner, [1, 2] ) } = 1
        lead_field_kwargs.preconditioner_tolerance (1,1) double { mustBePositive } = 0.001
        lead_field_kwargs.solver_tolerance (1,1) double { mustBePositive } = 1e-8
        lead_field_kwargs.source_direction_mode (1,1) double { mustBeMember ( lead_field_kwargs.source_direction_mode, [1, 2, 3] ) } = 1
        lead_field_kwargs.source_interpolation_on (1,1) logical = true
        lead_field_kwargs.source_model (1,1) zefCore.ZefSourceModel = zefCore.ZefSourceModel.Hdiv
        lead_field_kwargs.source_space_creation_iterations (1,1) double { mustBeInteger, mustBePositive } = 10
        lead_field_kwargs.use_depth_electrodes (1,1) logical = false
    end

    % Build mesh by running the adjacent meshing example.
    %
    % NOTE: We could leave the meshing-related kwargs out of this function to
    % reduce the number of lines required, as the meshing example function
    % input arguments have have default values. However, they are here to
    % demonstrate how they would be passed to the meshing example, and on the
    % other hand allow running this example while adjusting meshing-related
    % values at the same time.

    project_struct = examples.zef_meshing_example ( ...
        'input_project_path'                , kwargs.input_project_path, ...
        'use_gpu'                           , kwargs.use_gpu , ...
        'adaptive_refinement_compartments'  , mesh_kwargs.adaptive_refinement_compartments , ...
        'adaptive_refinement_k_param'       , mesh_kwargs.adaptive_refinement_k_param , ...
        'adaptive_refinement_number'        , mesh_kwargs.adaptive_refinement_number , ...
        'adaptive_refinement_on'            , mesh_kwargs.adaptive_refinement_on , ...
        'adaptive_refinement_thresh_val'    , mesh_kwargs.adaptive_refinement_thresh_val , ...
        'exclude_box'                       , mesh_kwargs.exclude_box , ...
        'fem_mesh_inflation_strength'       , mesh_kwargs.fem_mesh_inflation_strength , ...
        'fix_outer_surface'                 , mesh_kwargs.fix_outer_surface , ...
        'initial_mesh_mode'                 , mesh_kwargs.initial_mesh_mode , ...
        'mesh_labeling_approach'            , mesh_kwargs.mesh_labeling_approach , ...
        'mesh_optimization_parameter'       , mesh_kwargs.mesh_optimization_parameter , ...
        'mesh_optimization_repetitions'     , mesh_kwargs.mesh_optimization_repetitions , ...
        'mesh_relabeling'                   , mesh_kwargs.mesh_relabeling , ...
        'mesh_resolution'                   , mesh_kwargs.mesh_resolution , ...
        'mesh_smoothing_on'                 , mesh_kwargs.mesh_smoothing_on , ...
        'mesh_smoothing_repetitions'        , mesh_kwargs.mesh_smoothing_repetitions , ...
        'meshing_threshold'                 , mesh_kwargs.meshing_threshold , ...
        'pml_max_size'                      , mesh_kwargs.pml_max_size , ...
        'pml_max_size_unit'                 , mesh_kwargs.pml_max_size_unit , ...
        'pml_outer_radius'                  , mesh_kwargs.pml_outer_radius , ...
        'pml_outer_radius_unit'             , mesh_kwargs.pml_outer_radius_unit , ...
        'reduce_labeling_outliers'          , mesh_kwargs.reduce_labeling_outliers , ...
        'refinement_on'                     , mesh_kwargs.refinement_on , ...
        'refinement_surface_compartments'   , mesh_kwargs.refinement_surface_compartments , ...
        'refinement_surface_compartments_2' , mesh_kwargs.refinement_surface_compartments_2 , ...
        'refinement_surface_number'         , mesh_kwargs.refinement_surface_number , ...
        'refinement_surface_number_2'       , mesh_kwargs.refinement_surface_number_2 , ...
        'refinement_surface_on'             , mesh_kwargs.refinement_surface_on , ...
        'refinement_surface_on_2'           , mesh_kwargs.refinement_surface_on_2 , ...
        'refinement_volume_compartments'    , mesh_kwargs.refinement_volume_compartments , ...
        'refinement_volume_compartments_2'  , mesh_kwargs.refinement_volume_compartments_2 , ...
        'refinement_volume_number'          , mesh_kwargs.refinement_volume_number , ...
        'refinement_volume_number_2'        , mesh_kwargs.refinement_volume_number_2 , ...
        'refinement_volume_on'              , mesh_kwargs.refinement_volume_on , ...
        'refinement_volume_on_2'            , mesh_kwargs.refinement_volume_on_2 , ...
        'smoothing_steps_ele'               , mesh_kwargs.smoothing_steps_ele , ...
        'smoothing_steps_surf'              , mesh_kwargs.smoothing_steps_surf , ...
        'smoothing_steps_vol'               , mesh_kwargs.smoothing_steps_vol , ...
        'use_fem_mesh_inflation'            , mesh_kwargs.use_fem_mesh_inflation ...
    ) ;

    % Set lead field values required by project struct from kwargs.

    project_struct = utilities.copy_fields ( lead_field_kwargs, project_struct ) ;

    % Get and adjust sensors.

    project_struct.sensors_attached_volume = zef_attach_sensors_volume ( project_struct, project_struct.sensors ) ;

    % Construct lead field matrix.

    project_struct = zef_lead_field_matrix ( project_struct ) ;

    % Save the project with a lead field to a file.

    zef_save ( project_struct, kwargs.output_project_file, kwargs.output_project_dir ) ;

end
