%Copyright (c) 2018- Sampsa Pursiainen & ZI Development Team
%See: https://github.com/sampsapursiainen/zeffiro_interface
function project_struct = zef_meshing_example ( kwargs )
%
% examples.zef_meshing_example ( kwargs )
%
% This is a code snip to serve as an example for generating the
% multi-compartment head model accordingly to the paper:
%
% "Multi-compartment head modeling in EEG: unstructured boundary-fitted tetra meshing with subcortical structures"
% https://doi.org/10.48550/arXiv.2203.10000
%
% See the wiki page https://github.com/sampsapursiainen/zeffiro_interface/wiki/Finite-Element-Mesh-generation
% for what the different keyword arguments mean.
%
% NOTE: The comparment values for the compartment surfaces being refined (inner-most to outer-most)
% can be found in the script that was used in importing a segmentation from FreeSurfer:
% scripts_for_importing/multicomparmnet_head_project/import_segmentation.zef.
% Example: [1] = Ventricle, [10] = Cingulate Cortex, [17] = Skull, [18] = Scalp.
%

% Specify possible input keyword arguments, their restrictions and default values.

arguments
    kwargs.start_mode = "nodisplay"
    kwargs.input_project_path (1,1) string { mustBeFile } = fullfile ( "data", "segmentations", "multicompartment_head_project", "import_segmentation.zef" )
    kwargs.output_project_dir (1,:) char { mustBeFolder } = "data"
    kwargs.output_project_file (1,:) char = "meshing_example.mat"
    kwargs.use_gpu (1,1) logical = true;
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
end

% Start up Zeffiro Interface.

project_struct = zeffiro_interface( 'start_mode', kwargs.start_mode, 'import_to_existing_project', kwargs.input_project_path, 'use_gpu', kwargs.use_gpu ) ;

% Set all parameters needed in mesh construction as an example.

project_struct = utilities.copy_fields ( kwargs, project_struct ) ;

% Create finite element mesh.

project_struct = zef_create_finite_element_mesh ( project_struct ) ;

% Save the mesh to a file.

zef_save ( project_struct, kwargs.output_project_file, kwargs.output_project_dir ) ;

end % function
