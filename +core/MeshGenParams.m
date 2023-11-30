classdef MeshGenParams
%
% MeshGenParams
%
% This class defines the input parameters to the finite element mesh generation
% routine, that are only utilized inside of it and are not stored into the
% central data structure zef. The user of the mesh generator should construct
% an object of this class, and then pass it to the mesh generation routine as
% the "params" keyword argument.
%

    properties
        adaptive_refinement_compartments (1,:) double { mustBeInteger } = -1
        adaptive_refinement_k_param (1,1) double { mustBePositive, mustBeInteger } = 5
        adaptive_refinement_number (1,:) double { mustBeInteger } = 1
        adaptive_refinement_on (1,1) logical = false
        adaptive_refinement_thresh_val (1,1) double { mustBePositive } = 2
        exclude_box (1,1) logical = true
        fem_mesh_inflation_strength (1,1) double { mustBeNonnegative } = 0.05
        fix_outer_surface (1,1) logical = true
        initial_mesh_mode (1,1) double { mustBeMember (initial_mesh_mode, [1, 2]) } = 1
        mesh_labeling_approach (1,1) double { mustBeMember (mesh_labeling_approach, [1, 2]) } = 1
        mesh_optimization_parameter (1,1) double { mustBePositive } = 1e-5
        mesh_optimization_repetitions (1,1) double { mustBeNonnegative, mustBeInteger } = 10
        mesh_relabeling (1,1) logical = true
        mesh_resolution (1,1) double { mustBePositive } = 4.5
        mesh_smoothing_on (1,1) logical = true;
        mesh_smoothing_repetitions (1,1) double { mustBeNonnegative, mustBeInteger } = 1
        meshing_threshold (1,1) double { mustBePositive } = 0.25
        pml_max_size (1,1) double { mustBePositive } = 2
        pml_max_size_unit (1,1) double { mustBeMember ( pml_max_size_unit, [1, 2] ) } = 1
        pml_outer_radius (1,1) double { mustBePositive } = 1.1
        pml_outer_radius_unit (1,1) double { mustBeMember ( pml_outer_radius_unit, [1, 2] ) } = 1
        reduce_labeling_outliers (1,1) logical = true
        refinement_on (1,1) logical = true;
        refinement_surface_compartments (1,:) double { mustBeInteger } = [10 -1 1 18 17]
        refinement_surface_compartments_2 (1,:) double { mustBeInteger } = -1
        refinement_surface_number (1,:) double { mustBeInteger } = 1
        refinement_surface_number_2 (1,:) double { mustBeInteger } = 1
        refinement_surface_on (1,1) logical = true
        refinement_surface_on_2 (1,1) logical = false
        refinement_volume_compartments (1,:) double { mustBeInteger } = -1
        refinement_volume_compartments_2 (1,:) double { mustBeInteger } = -1
        refinement_volume_number (1,:) double { mustBeInteger } = 1
        refinement_volume_number_2 (1,:) double { mustBeInteger } = 1
        refinement_volume_on (1,1) logical = false
        refinement_volume_on_2 (1,1) logical = false
        smoothing_steps_ele (1,1) double { mustBePositive } = 0.2
        smoothing_steps_surf (1,1) double { mustBePositive } = 0.10
        smoothing_steps_vol (1,1) double { mustBePositive } = 0.90
        use_fem_mesh_inflation (1,1) logical = true
    end % properties

    methods

        function self = MeshGenParams ( kwargs )
        %
        % self = MeshGenParams ( kwargs )
        %
        % A constructor of this class. The kwargs contain the properties of
        % this class, that one wishes to set. The ones that are omitted will
        % use the default values.
        %

            arguments
                kwargs.adaptive_refinement_compartments = -1
                kwargs.adaptive_refinement_k_param = 5
                kwargs.adaptive_refinement_number = 1
                kwargs.adaptive_refinement_on = false
                kwargs.adaptive_refinement_thresh_val = 2
                kwargs.exclude_box = true
                kwargs.fem_mesh_inflation_strength = 0.05
                kwargs.fix_outer_surface = true
                kwargs.initial_mesh_mode = 1
                kwargs.mesh_labeling_approach = 1
                kwargs.mesh_optimization_parameter = 1e-5
                kwargs.mesh_optimization_repetitions = 10
                kwargs.mesh_relabeling = true
                kwargs.mesh_resolution = 4.5
                kwargs.mesh_smoothing_on = true;
                kwargs.mesh_smoothing_repetitions = 1
                kwargs.meshing_threshold = 0.25
                kwargs.pml_max_size = 2
                kwargs.pml_max_size_unit = 1
                kwargs.pml_outer_radius = 1.1
                kwargs.pml_outer_radius_unit = 1
                kwargs.reduce_labeling_outliers = true
                kwargs.refinement_on = true;
                kwargs.refinement_surface_compartments = [10 -1 1 18 17]
                kwargs.refinement_surface_compartments_2 = -1
                kwargs.refinement_surface_number = 1
                kwargs.refinement_surface_number_2 = 1
                kwargs.refinement_surface_on = true
                kwargs.refinement_surface_on_2 = false
                kwargs.refinement_volume_compartments = -1
                kwargs.refinement_volume_compartments_2 = -1
                kwargs.refinement_volume_number = 1
                kwargs.refinement_volume_number_2 = 1
                kwargs.refinement_volume_on = false
                kwargs.refinement_volume_on_2 = false
                kwargs.smoothing_steps_ele = 0.2
                kwargs.smoothing_steps_surf = 0.10
                kwargs.smoothing_steps_vol = 0.90
                kwargs.use_fem_mesh_inflation = true
            end

            fns = string ( fieldnames ( kwargs ) ) ;

            for fnI = 1 : numel ( fns )

                self.(fns(fnI)) = kwargs.(fns(fnI)) ;

            end % for

        end % function

    end % methods

end % classdef
