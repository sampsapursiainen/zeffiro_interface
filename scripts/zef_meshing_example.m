%Copyright © 2018- Sampsa Pursiainen & ZI Development Team
%See: https://github.com/sampsapursiainen/zeffiro_interface
function zef_meshing_example
% This is a code snip to serve as an example for generating a
% multi-compartment head model. This script will automatically prepare the
% 'zef.' structure accordinangly to the paper:
% "Multi-compartment head modeling in EEG: unstructured boundary-fitted tetra meshing with subcortical structures"
% https://doi.org/10.48550/arXiv.2203.10000
%
% The comparment values for the 'project_struct.refinement_surface_compartments' (inner-most to outer-most)
% can be found in  scripts_for_importing/multicomparmnet_head_project/import_segmentation.zef
% Example: [1] = Ventricle, [10] = Cingulate Cortex, [17] = Skull, [18] = Scalp.

project_struct = zeffiro_interface('start_mode','nodisplay','import_to_existing_project', ...
'scripts/scripts_for_importing/multicompartment_head_project/import_segmentation.zef');

% Set mesh resolution
project_struct.mesh_resolution = 4.5;           % A higher number = coarser mesh.
project_struct.mesh_smoothing_on = 1;           % TRUE
project_struct.refinement_on = 1;               % TRUE
project_struct.use_gpu = 1;                     % TRUE
project_struct.refinement_surface_compartments = [10 -1 1 18 17];
project_struct.refinement_surface_on = 1;       % TRUE

% Create finite element mesh
project_struct = zef_create_finite_element_mesh(project_struct);

zef_save(project_struct,'zef_meshing_example.mat','data/');  % return file

end
