% Parameter values and their initial values for Zeffiro-Brainstorm plugin.
%
% zef_bst.save_project = 1;             
%
%                               This flag (logical 1 or 0) defines whether the
%                               Zeffiro's project file with mesh is saved on disk.
%
% zef_bst.import_settings = "";         
%
%                               This parameter (string) enables importing
%                               more of Zeffiro's parameters into its project file zef.
% 
% zef_bst.verbose_mode = 1;       
%
%                               This parameter (logical 0 or 1) will allow the
%                               waitbar information to be printed
%                               in command window, if the waitbar window is not opened.   
% 
% zef_bst.use_waitbar = 1;      
%
%                               This parameter determines whether
%                               waitbar (graphical or command line
%                               version is used (logical 0 or 1).
% 
% zef_bst.surface_names = cell(0);
%
%                               This cell array can contain the names of
%                               individual surfaces in the respective order
%                               with the surface_mesh_files (cell array).
%                               
% zef_bst.mesh_resolution = 3;
%
%                               This parameter determines the base
%                               resolution for an unstructured tetrahedral
%                               mesh created by Zeffiro (double).
%                                
% zef_bst.refine_surface = {'Scalp','OuterSkull','InnerSkull','Cortex','Other'};
%
%                               This cell array contains those surface
%                               types towards which the Zeffiro's tetrahedral mesh is refined 
%                               (cell array).
%
% zef_bst.refine_surface_number = 1; 
%
%                               This parameter defines the total number of consecutive surface 
%                               mesh refinements in the tetrahedral mesh generation procedure
%                               (double).
%
% zef_bst.refine_surface_on = 1;
%
%                               This parameter determines whether surfaces
%                               of Zeffiro's tetrahedral mesh are refined 
%                               (logical 1 or 0).
%
% zef_bst.refine_surface_mode = 2;
%
%                               This parameter sets the surface refinement
%                               mode (double 1 or 2). With 
%                               (1) external surface of the
%                               total volume restricted by the selected surfaces
%                               is refined. With (2) the union of the
%                               selected surfaces is refined.
%
% zef_bst.refine_volume = cell(0);
%
%                               This parameter determines whether
%                               volumetric refinements are made (cell array, 
%                               initial value cell(0)).
%
% zef_bst.refine_volume_number = 1;
%
%                               This parameter determines the total number
%                               of consecutive volume refinements (logical 
%                               1 or 0).
%
% zef_bst.refine_volume_on = 0;
%
%                               This parameter determines whether surfaces
%                               of Zeffiro's tetrahedral mesh are refined 
%                               (logical 1 or 0). 
%
% zef_bst.inflation_on = 1;
%
%                               This parameter determines whether the
%                               surfaces are inflated in the tetrahedral mesh
%                               generation process (logical 1 or 0). 
%
% zef_bst.inflation_strength = 0.05;
%
%                               This parameter determines the inflation
%                               strength applied in the tetrahedral mesh
%                               generation process (double).
%
%zef_bst.surface_mesh_density = 0.5;
%
%                               This parameter defines the approximative relative density
%                               of the triangular surface meshes determining the
%                               the tissue boundaries of a head segmentation 
%                               with respect to the tetrahedral mesh
%                               resolution (double). 
%
% zef_bst.surface_priority = {'Scalp','OuterSkull','InnerSkull','Cortex','Other'};
%
%                               This cell array defines the priority of
%                               surface types in labeling from outermost to the
%                               innermost (cell array).
%                                
% zef_bst.use_gpu = 1;

%                               This parameter determines whether Zeffiro 
%                               tries to use GPU acceleration (logical 0 or 1).
%
% zef_bst.always_show_waitbar = 1;
%
%                               This parameter (logical 0 or 1) determines
%                               whether the graphical waitbar is always
%                               shown.
%
% zef_bst.parallel_processes = 10;
%
%                               This parameter (double) determines the
%                               number of parallel processes that Zeffiro tries to 
%                               utilize if computing is purely performed in CPU. 
%
% zef_bst.surface_mesh_files = cell(0);
%                               
%                               This parameter (cell array) determines the
%                               files of triangular head segmentation
%                               surfaces selected by the user.
%
% zef_bst.unit_conversion = 1000;
%
%                               This is the standard spatial unit conversion 
%                               (double) from meters (Brainstorm) to millimeters
%                               (Zeffiro).
%
%zef_bst.extensive_relabeling = 0; 
%               
%                               This parameter (logical 1 or 0) selects
%                               whether the relabeling process will be
%                               performed in extensive mode, in which a backward 
%                               labeling front is used in addition to the
%                               forward (standard) one.
%                        
%zef_bst.priority_mode = 1;
%
%                               This parameter (value 1, 2, or 3) selects whether the 
%                               domain labeling process is controlled by a user-defined labeling 
%                               priority index vector. In mode (1), the default
%                               priority (from outermost to the innermost)
%                               is used and any user-defined vector is
%                               ignored. In mode (2), user-defined priority
%                               is used in labeling the initial mesh, and
%                               in mode (3), it is used in both initial
%                               labeling and re-labeling.
%                                                         
%zef_bst.labeling_priority = []; 
%
%                               This parameter can contain a user-defined labeling priority order, i.e., a permuted 
%                               vector containing compartment indices from 1 to N+1 with 1 (greatest priority) 
%                               corresponding to outermost comparment, which is an additional 
%                               bounding box containing all N head model compartments, and N+1 (smallest priority) 
%                               to innermost one. The quality of small details can be enhanced by choosing a greater 
%                               priority for the corresponding compartment.
%
%zef_bst.mesh_smoothing_on = 1; 
%
%                               This parameter (logical 1 or 0) determines
%                               whether the tetrahedral mesh generated by
%                               Zeffiro is smoothed or not.
%
%zef_bst.distance_smoothing_on = 1; 
%
%                               This parameter (logical 1 or 0) determines
%                               whether an exponential distance weighting is 
%                               applied, when smoothing the tetrahedral mesh 
%                               generated by Zeffiro.
%
%zef_bst.subject_struct = struct;
%
%                               This parameter (struct) can contain the
%                               Brainstorm subject to be processed.
%
%zef_bst.subject_folder = "";
%
%                               This parameter (string) can contain
%                               Brainstorm's subject folder.
%                               

zef_bst.mesh_resolution = 5;
zef_bst.surface_priority = {'Scalp','OuterSkull','InnerSkull','Cortex','Other','white','subcortical'};
zef_bst.refine_surface = {'Scalp','OuterSkull','InnerSkull','Cortex','Other','subcortical'};
zef_bst.refine_surface_mode = 2; 
zef_bst.use_gpu = 1;
zef_bst.parallel_processes = 10;
zef_bst.verbose_mode = 0;
zef_bst.use_waitbar = 1;
zef_bst.surface_mesh_density = 0.25;