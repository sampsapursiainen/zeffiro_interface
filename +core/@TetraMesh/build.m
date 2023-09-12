function self = build ( self, kwargs )
%
% build (
%   self,
%   kwargs.adaptive_refinement_compartments
%   kwargs.adaptive_refinement_k_param
%   kwargs.adaptive_refinement_number
%   kwargs.adaptive_refinement_on
%   kwargs.adaptive_refinement_thresh_val
%   kwargs.exclude_box
%   kwargs.fem_mesh_inflation_strength
%   kwargs.fix_outer_surface
%   kwargs.initial_mesh_mode
%   kwargs.mesh_labeling_approach
%   kwargs.mesh_optimization_parameter
%   kwargs.mesh_optimization_repetitions
%   kwargs.mesh_relabeling
%   kwargs.mesh_resolution
%   kwargs.mesh_smoothing_on
%   kwargs.mesh_smoothing_repetitions
%   kwargs.meshing_threshold
%   kwargs.pml_max_size
%   kwargs.pml_max_size_unit
%   kwargs.pml_outer_radius
%   kwargs.pml_outer_radius_unit
%   kwargs.reduce_labeling_outliers
%   kwargs.refinement_on
%   kwargs.refinement_surface_compartments
%   kwargs.refinement_surface_compartments_2
%   kwargs.refinement_surface_number
%   kwargs.refinement_surface_number_2
%   kwargs.refinement_surface_on
%   kwargs.refinement_surface_on_2
%   kwargs.refinement_volume_compartments
%   kwargs.refinement_volume_compartments_2
%   kwargs.refinement_volume_number
%   kwargs.refinement_volume_number_2
%   kwargs.refinement_volume_on
%   kwargs.refinement_volume_on_2
%   kwargs.smoothing_steps_ele
%   kwargs.smoothing_steps_surf
%   kwargs.smoothing_steps_vol
%   kwargs.use_fem_mesh_inflation
%   kwargs.use_gpu
% )
%
% Builds a finite element mesh based on the set of input kwargs.
%
    arguments
        self (1,1) core.TetraMesh
        kwargs.adaptive_refinement_compartments (1,:) double { mustBeInteger } = -1
        kwargs.adaptive_refinement_k_param (1,1) double { mustBePositive, mustBeInteger } = 5
        kwargs.adaptive_refinement_number (1,:) double { mustBeInteger } = 1
        kwargs.adaptive_refinement_on (1,1) logical = false
        kwargs.adaptive_refinement_thresh_val (1,1) double { mustBePositive } = 2
        kwargs.exclude_box (1,1) logical = true
        kwargs.fem_mesh_inflation_strength (1,1) double { mustBeNonnegative } = 0.05
        kwargs.fix_outer_surface (1,1) logical = true
        kwargs.initial_mesh_mode (1,1) double { mustBeMember (kwargs.initial_mesh_mode, [1, 2]) } = 1
        kwargs.mesh_labeling_approach (1,1) double { mustBeMember (kwargs.mesh_labeling_approach, [1, 2]) } = 1
        kwargs.mesh_optimization_parameter (1,1) double { mustBePositive } = 1e-5
        kwargs.mesh_optimization_repetitions (1,1) double { mustBeNonnegative, mustBeInteger } = 10
        kwargs.mesh_relabeling (1,1) logical = true
        kwargs.mesh_resolution (1,1) double { mustBePositive } = 4.5
        kwargs.mesh_smoothing_on (1,1) logical = true;
        kwargs.mesh_smoothing_repetitions (1,1) double { mustBeNonnegative, mustBeInteger } = 1
        kwargs.meshing_threshold (1,1) double { mustBePositive } = 0.25
        kwargs.pml_max_size (1,1) double { mustBePositive } = 2
        kwargs.pml_max_size_unit (1,1) double { mustBeMember ( kwargs.pml_max_size_unit, [1, 2] ) } = 1
        kwargs.pml_outer_radius (1,1) double { mustBePositive } = 1.1
        kwargs.pml_outer_radius_unit (1,1) double { mustBeMember ( kwargs.pml_outer_radius_unit, [1, 2] ) } = 1
        kwargs.reduce_labeling_outliers (1,1) logical = true
        kwargs.refinement_on (1,1) logical = true;
        kwargs.refinement_surface_compartments (1,:) double { mustBeInteger } = [10 -1 1 18 17]
        kwargs.refinement_surface_compartments_2 (1,:) double { mustBeInteger } = -1
        kwargs.refinement_surface_number (1,:) double { mustBeInteger } = 1
        kwargs.refinement_surface_number_2 (1,:) double { mustBeInteger } = 1
        kwargs.refinement_surface_on (1,1) logical = true
        kwargs.refinement_surface_on_2 (1,1) logical = false
        kwargs.refinement_volume_compartments (1,:) double { mustBeInteger } = -1
        kwargs.refinement_volume_compartments_2 (1,:) double { mustBeInteger } = -1
        kwargs.refinement_volume_number (1,:) double { mustBeInteger } = 1
        kwargs.refinement_volume_number_2 (1,:) double { mustBeInteger } = 1
        kwargs.refinement_volume_on (1,1) logical = false
        kwargs.refinement_volume_on_2 (1,1) logical = false
        kwargs.smoothing_steps_ele (1,1) double { mustBePositive } = 0.2
        kwargs.smoothing_steps_surf (1,1) double { mustBePositive } = 0.10
        kwargs.smoothing_steps_vol (1,1) double { mustBePositive } = 0.90
        kwargs.use_fem_mesh_inflation (1,1) logical = true
        kwargs.use_gpu (1,1) logical = true;
    end % arguments

end % function
