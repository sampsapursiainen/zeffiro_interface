%This script calculates averaged sensitivity maps using the MNE and dipole
%scan tools. Start the script from the root folder by first adding the
%script folder into the path (addpath('scripts/inverse_sensitivity')).

%Import the spherical Ary domain.
project_struct = zeffiro_interface('start_mode','nodisplay','open_project','data/example_projects/ary_sphere_project');

%Set mesh resolution and generate a finite element mesh.
project_struct.mesh_resolution = 6;
project_struct = zef_create_finite_element_mesh(project_struct);

%Set the desired number of source positions and generate a lead field.
project_struct.n_sources = 500;
project_struct = zef_eeg_lead_field(project_struct);

%Set noise level and number of cases to be averaged.
noise_level = -30;
n_cases = 2;

%Start the MNE tool and calculate a map for sLORETA.
project_struct = zef_minimum_norm_estimation(project_struct);
sensitivity_map_sLoreta = zef_sensitivity_map_mne(project_struct, 'sLORETA', n_cases, noise_level);

%Start the dipole scan tool and calculate a map. 
project_struct = zef_dipole_start(project_struct);
sensitivity_map_dipoleScan = zef_sensitivity_map_dipoleScan(project_struct, n_cases, noise_level);

%Close Zeffiro.
zef_close_all;
