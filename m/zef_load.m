%Copyright © 2018, Sampsa Pursiainen
      
if not(isempty(zef.save_file_path)) & not(zef.save_file_path==0)  
[zef.file zef.file_path] = uigetfile('*.mat','Open project',zef.save_file_path);
else
[zef.file zef.file_path] = uigetfile('*.mat','Open project');
end
if not(isequal(zef.file,0));
zef.save_file = zef.file; 
zef.save_file_path = zef.file_path; 
load([zef.file_path zef.file]);
 if (isfield(zef_data,'inv_rec_source'));
          zef.inv_rec_source = zef_data.inv_rec_source; 
          else
          zef.inv_rec_source = [0 0 0 1 0 0 0 3 1];
          end
 if (isfield(zef_data,'inv_synth_source'));
          zef.inv_synth_source = zef_data.inv_synth_source; 
          else
          zef.inv_synth_source = [0 0 0 1 0 0 10 0 3 1];
          end
          if (isfield(zef_data,'inv_roi_sphere'));
          zef.inv_roi_sphere = zef_data.inv_roi_sphere; 
          else
          zef.inv_roi_sphere = [0 0 0 15];
          end
          if (isfield(zef_data,'inv_roi_threshold'));
          zef.inv_roi_threshold = zef_data.inv_roi_threshold; 
          else
          zef.inv_roi_threshold = 0.5;
          end
          if (isfield(zef_data,'inv_roi_mode'));
          zef.inv_roi_mode = zef_data.inv_roi_mode; 
          else
          zef.inv_roi_mode = 1;
          end
          if (isfield(zef_data,'inv_n_sampler'));
          zef.inv_n_sampler = zef_data.inv_n_sampler; 
          else
          zef.inv_n_sampler = 10000;
          end
          if (isfield(zef_data,'inv_n_burn_in'));
          zef.inv_n_burn_in = zef_data.inv_n_burn_in; 
          else
          zef.inv_n_burn_in = 1000;
          end
          if (isfield(zef_data,'use_depth_electrodes'));
          zef.use_depth_electrodes = zef_data.use_depth_electrodes; 
          else
          zef.use_depth_electrodes = 0;
          end;
          if (isfield(zef_data,'source_model'));
          zef.source_model = zef_data.source_model; 
          else
          zef.source_model = 2;
          end;
          if isfield(zef_data,'reconstruction_type')
          zef.reconstruction_type      =      zef_data.reconstruction_type;
          else
          zef.reconstruction_type = 1;
          end
          if isfield(zef_data,'use_gpu')
          zef.use_gpu      =      zef_data.use_gpu;
          else
          zef.use_gpu = 1;
          end
          if isfield(zef_data,'gpu_num') 
          zef.gpu_num      =      zef_data.gpu_num;
          else 
          zef.gpu_num = 1;
          end
          zef.cam_va       =      zef_data.cam_va;
          zef.location_unit=      zef_data.location_unit  ;
              zef.elevation=          zef_data.elevation  ;
                zef.azimuth=            zef_data.azimuth  ;
           zef.axes_visible=       zef_data.axes_visible  ;
              zef.n_sources=          zef_data.n_sources  ;
               zef.sc_sigma=           zef_data.sc_sigma  ;
               zef.sk_sigma=           zef_data.sk_sigma  ;
                zef.c_sigma=            zef_data.c_sigma  ;
                zef.g_sigma=            zef_data.g_sigma  ;
                zef.w_sigma=            zef_data.w_sigma  ;
               zef.d1_sigma=            zef_data.d1_sigma ;
               zef.d2_sigma=           zef_data.d2_sigma ;
               zef.d3_sigma=           zef_data.d3_sigma ;
               zef.d4_sigma=           zef_data.d4_sigma ;
             zef.d1_visible=          zef_data.d1_visible  ;
             zef.d2_visible=          zef_data.d2_visible  ;   
             zef.d1_on     =          zef_data.d1_on;    
             zef.d2_on     =          zef_data.d2_on;    
             zef.d3_on     =          zef_data.d3_on;
             zef.d4_on     =          zef_data.d4_on;
             zef.d1_scaling=         zef_data.d1_scaling  ;
         zef.d1_zx_rotation=     zef_data.d1_zx_rotation  ;
         zef.d1_yz_rotation=     zef_data.d1_yz_rotation  ;
         zef.d1_xy_rotation=     zef_data.d1_xy_rotation  ;
        zef.d1_z_correction=    zef_data.d1_z_correction  ;
        zef.d1_y_correction=    zef_data.d1_y_correction  ;
        zef.d1_x_correction=    zef_data.d1_x_correction  ;
         zef.d2_scaling=         zef_data.d2_scaling  ;
         zef.d2_zx_rotation=     zef_data.d2_zx_rotation  ;
         zef.d2_yz_rotation=     zef_data.d2_yz_rotation  ;
         zef.d2_xy_rotation=     zef_data.d2_xy_rotation  ;
        zef.d2_z_correction=    zef_data.d2_z_correction  ;
        zef.d2_y_correction=    zef_data.d2_y_correction  ;
        zef.d2_x_correction=    zef_data.d2_x_correction  ; 
             zef.d3_scaling=         zef_data.d3_scaling  ;
         zef.d3_zx_rotation=     zef_data.d3_zx_rotation  ;
         zef.d3_yz_rotation=     zef_data.d3_yz_rotation  ;
         zef.d3_xy_rotation=     zef_data.d3_xy_rotation  ;
        zef.d3_z_correction=    zef_data.d3_z_correction  ;
        zef.d3_y_correction=    zef_data.d3_y_correction  ;
        zef.d3_x_correction=    zef_data.d3_x_correction  ;  
             zef.d4_scaling=         zef_data.d4_scaling  ;
         zef.d4_zx_rotation=     zef_data.d4_zx_rotation  ;
         zef.d4_yz_rotation=     zef_data.d4_yz_rotation  ;
         zef.d4_xy_rotation=     zef_data.d4_xy_rotation  ;
        zef.d4_z_correction=    zef_data.d4_z_correction  ;
        zef.d4_y_correction=    zef_data.d4_y_correction  ;
        zef.d4_x_correction=    zef_data.d4_x_correction  ;   
        zef.mesh_resolution=    zef_data.mesh_resolution  ;
      zef.attach_electrodes=  zef_data.attach_electrodes  ;
              zef.s_visible=          zef_data.s_visible  ;
           zef.s_directions=       zef_data.s_directions  ;
            zef.w_triangles=        zef_data.w_triangles  ;
               zef.w_points=           zef_data.w_points  ;
            zef.d1_triangles=        zef_data.d1_triangles  ;
               zef.d1_points=           zef_data.d1_points  ;
            zef.d2_triangles=        zef_data.d2_triangles  ;
               zef.d2_points=           zef_data.d2_points  ;
            zef.d3_triangles=        zef_data.d3_triangles  ;
               zef.d3_points=           zef_data.d3_points  ;
            zef.d4_triangles=        zef_data.d4_triangles  ;
               zef.d4_points=           zef_data.d4_points  ;
  zef.source_direction_mode =  zef_data.source_direction_mode ;
             zef.sc_visible=         zef_data.sc_visible  ;
             zef.sk_visible=         zef_data.sk_visible  ;
              zef.c_visible=          zef_data.c_visible  ;
              zef.g_visible=          zef_data.g_visible  ;
              zef.w_visible=          zef_data.w_visible  ;
             zef.sc_scaling=         zef_data.sc_scaling  ;
         zef.sc_zx_rotation=     zef_data.sc_zx_rotation  ;
         zef.sc_yz_rotation=     zef_data.sc_yz_rotation  ;
         zef.sc_xy_rotation=     zef_data.sc_xy_rotation  ;
        zef.sc_z_correction=    zef_data.sc_z_correction  ;
        zef.sc_y_correction=    zef_data.sc_y_correction  ;
        zef.sc_x_correction=    zef_data.sc_x_correction  ;
             zef.sk_scaling=   zef_data.sk_scaling        ;
         zef.sk_zx_rotation=     zef_data.sk_zx_rotation  ;
         zef.sk_yz_rotation=     zef_data.sk_yz_rotation  ;
         zef.sk_xy_rotation=     zef_data.sk_xy_rotation  ;
        zef.sk_z_correction=    zef_data.sk_z_correction  ;
        zef.sk_y_correction=    zef_data.sk_y_correction  ;
        zef.sk_x_correction=    zef_data.sk_x_correction  ;
              zef.c_scaling=          zef_data.c_scaling  ;
          zef.c_zx_rotation=      zef_data.c_zx_rotation  ;
          zef.c_yz_rotation=      zef_data.c_yz_rotation  ;
          zef.c_xy_rotation=      zef_data.c_xy_rotation  ;
         zef.c_z_correction=     zef_data.c_z_correction  ;
         zef.c_y_correction=     zef_data.c_y_correction  ;
         zef.c_x_correction=     zef_data.c_x_correction  ;
              zef.g_scaling=          zef_data.g_scaling  ;
          zef.g_zx_rotation=      zef_data.g_zx_rotation  ;
          zef.g_yz_rotation=      zef_data.g_yz_rotation  ;
          zef.g_xy_rotation=      zef_data.g_xy_rotation  ;
         zef.g_z_correction=     zef_data.g_z_correction  ;
         zef.g_y_correction=     zef_data.g_y_correction  ;
         zef.g_x_correction=     zef_data.g_x_correction  ;
              zef.w_scaling=          zef_data.w_scaling  ;
          zef.w_zx_rotation=      zef_data.w_zx_rotation  ;
          zef.w_yz_rotation=      zef_data.w_yz_rotation  ;
          zef.w_xy_rotation=      zef_data.w_xy_rotation  ;
         zef.w_z_correction=     zef_data.w_z_correction  ;
         zef.w_y_correction=     zef_data.w_y_correction  ;
         zef.w_x_correction=     zef_data.w_x_correction  ;
              zef.s_scaling=          zef_data.s_scaling  ;
          zef.s_zx_rotation=      zef_data.s_zx_rotation  ;
          zef.s_yz_rotation=      zef_data.s_yz_rotation  ;
          zef.s_xy_rotation=      zef_data.s_xy_rotation  ;
         zef.s_z_correction=     zef_data.s_z_correction  ;
         zef.s_y_correction=     zef_data.s_y_correction  ;
         zef.s_x_correction=     zef_data.s_x_correction  ;
         zef.imaging_method=     zef_data.imaging_method  ;
                  zef.sc_on=              zef_data.sc_on  ;
                  zef.sk_on=              zef_data.sk_on  ;
                   zef.c_on=               zef_data.c_on  ;
                   zef.g_on=               zef_data.g_on  ;
           zef.sc_triangles=       zef_data.sc_triangles  ;
              zef.sc_points=          zef_data.sc_points  ;
           zef.sk_triangles=       zef_data.sk_triangles  ;
              zef.sk_points=          zef_data.sk_points  ;
            zef.c_triangles=        zef_data.c_triangles  ;
               zef.c_points=           zef_data.c_points  ;
            zef.g_triangles=        zef_data.g_triangles  ;
               zef.g_points=           zef_data.g_points  ;
                   zef.w_on=               zef_data.w_on  ;
               zef.s_points=           zef_data.s_points  ;
            zef.w_priority = zef_data.w_priority;
            zef.g_priority = zef_data.g_priority ;
            zef.c_priority = zef_data.c_priority ;
           zef.sk_priority = zef_data.sk_priority;
           zef.sc_priority = zef_data.sc_priority;
           zef.d1_priority = zef_data.d1_priority;
           zef.d2_priority = zef_data.d2_priority;
           zef.d3_priority = zef_data.d3_priority;
           zef.d4_priority = zef_data.d4_priority;
           zef.cp_on       = zef_data.cp_on;
           zef.cp_a        = zef_data.cp_a;
           zef.cp_b        = zef_data.cp_b;
           zef.cp_c        = zef_data.cp_c;
           zef.cp_d        = zef_data.cp_d;
      zef.meshing_accuracy = zef_data.meshing_accuracy;
      zef.on_screen        = 0;
if isfield(zef_data,'reuna_p')
            zef.reuna_p = zef_data.reuna_p;
end
if isfield(zef_data,'reuna_t')
zef.reuna_t = zef_data.reuna_t;
end
if isfield(zef_data,'sensors')
zef.sensors = zef_data.sensors;
end
if isfield(zef_data,'nodes')
zef.nodes = zef_data.nodes;
end
if isfield(zef_data,'tetra')
zef.tetra = zef_data.tetra;
end
if isfield(zef_data,'brain_ind')
zef.brain_ind = zef_data.brain_ind;
end
if isfield(zef_data,'source_ind')
zef.source_ind = zef_data.source_ind;
end
if isfield(zef_data,'sigma')
zef.sigma = zef_data.sigma;
end
if (isfield(zef_data,'solver_tolerance')) 
zef.solver_tolerance = zef_data.solver_tolerance; 
end; 
if (isfield(zef_data,'sensors_attached_volume')) 
zef.sensors_attached_volume = zef_data.sensors_attached_volume;
end; 
if (isfield(zef_data,'preconditioner'))
zef.preconditioner = zef_data.preconditioner; 
end; 
if (isfield(zef_data,'sigma_ind'))
zef.sigma_ind = zef_data.sigma_ind; 
end; 
if (isfield(zef_data,'sigma_vec'))
zef.sigma_vec = zef_data.sigma_vec; 
end; 
if (isfield(zef_data,'sigma_mod'))
zef.sigma_mod = zef_data.sigma_mod; 
end;
if (isfield(zef_data,'surface_triangles'))
zef.surface_triangles = zef_data.surface_triangles; 
end;
if (isfield(zef_data,'preconditioner_tolerance'));
zef.preconditioner_tolerance = zef_data.preconditioner_tolerance; 
end;
if (isfield(zef_data,'L'));
zef.L = zef_data.L; 
end;
if (isfield(zef_data,'n_sources_mod'));
zef.n_sources_mod = zef_data.n_sources_mod; 
end;
if (isfield(zef_data,'n_sources_old'));
zef.n_sources_old = zef_data.n_sources_old; 
end;
if (isfield(zef_data,'location_unit_current'));
zef.location_unit_current = zef_data.location_unit_current; 
end;
if (isfield(zef_data,'L'));
zef.L = zef_data.L; 
end;
if (isfield(zef_data,'source_positions'));
zef.source_positions = zef_data.source_positions; 
end;
if (isfield(zef_data,'source_directions'));
zef.source_directions = zef_data.source_directions; 
end;
if (isfield(zef_data,'nodes_b'));
zef.nodes_b = zef_data.nodes_b; 
end;
if (isfield(zef_data,'location_unit_current'));
zef.location_unit_current = zef_data.location_unit_current; 
end;
if (isfield(zef_data,'import_mode'));
zef.import_mode = zef_data.import_mode; 
end;
if (isfield(zef_data,'mesh_smoothing_on'));
zef.mesh_smoothing_on = zef_data.mesh_smoothing_on; 
end;
if (isfield(zef_data,'wm_sources'));
zef.wm_sources = zef_data.wm_sources; 
end;
if (isfield(zef_data,'tetra_aux'));
zef.tetra_aux = zef_data.tetra_aux; 
end;
if (isfield(zef_data,'prism_layers'));
zef.prism_layers = zef_data.prism_layers; 
end;
if (isfield(zef_data,'n_prism_layers'));
zef.n_prism_layers = zef_data.n_prism_layers; 
end;
if (isfield(zef_data,'prism_size'));
zef.prism_size = zef_data.prism_size; 
end;
if (isfield(zef_data,'prisms'));
zef.prisms = zef_data.prisms; 
end;
if (isfield(zef_data,'sigma_prisms'));
zef.sigma_prisms = zef_data.sigma_prisms; 
end;
if (isfield(zef_data,'refinement_on'));
zef.refinement_on = zef_data.refinement_on; 
end;
if (isfield(zef_data,'smoothing_strength'));
zef.smoothing_strength = zef_data.smoothing_strength; 
end;
if (isfield(zef_data,'smoothing_steps_surf'));
zef.smoothing_steps_surf = zef_data.smoothing_steps_surf; 
end;
if (isfield(zef_data,'smoothing_steps_vol'));
zef.smoothing_steps_vol = zef_data.smoothing_steps_vol; 
end;
if (isfield(zef_data,'refinement_type'));
zef.refinement_type = zef_data.refinement_type; 
end;
if (isfield(zef_data,'surface_sources'));
zef.surface_sources = zef_data.surface_sources; 
end;
if (isfield(zef_data,'lead_field_time'));
zef.lead_field_time = zef_data.lead_field_time; 
end;
if (isfield(zef_data,'visualization_type'));
zef.visualization_type = zef_data.visualization_type; 
end;

if (isfield(zef_data,'source_interpolation_on')); 
    zef.source_interpolation_on = zef_data.source_interpolation_on; 
end; 
if (isfield(zef_data,'measurements')); 
    zef.measurements = zef_data.measurements; 
end;
if (isfield(zef_data,'reconstruction')); 
    zef.reconstruction = zef_data.reconstruction; 
end;

if (isfield(zef_data,'source_interpolation_ind')); 
    zef.source_interpolation_ind = zef_data.source_interpolation_ind; 
end;

if (isfield(zef_data,'inv_hyperprior')); 
    zef.inv_hyperprior = zef_data.inv_hyperprior; 
end; 
if (isfield(zef_data,'inv_beta')); 
    zef.inv_beta = zef_data.inv_beta; 
end;
if (isfield(zef_data,'inv_theta0')); 
    zef.inv_theta0 = zef_data.inv_theta0; 
end;
if (isfield(zef_data,'inv_likelihood_std')); 
    zef.inv_likelihood_std = zef_data.inv_likelihood_std; 
end;
if (isfield(zef_data,'inv_n_map_iterations')); 
    zef.inv_n_map_iterations = zef_data.inv_n_map_iterations; 
end;
if (isfield(zef_data,'inv_pcg_tol')); 
    zef.inv_pcg_tol = zef_data.inv_pcg_tol; 
end;
if (isfield(zef_data,'inv_sampling_frequency')); 
    zef.inv_sampling_frequency = zef_data.inv_sampling_frequency; 
end;
if (isfield(zef_data,'inv_low_cut_frequency')); 
    zef.inv_low_cut_frequency = zef_data.inv_low_cut_frequency; 
end;
if (isfield(zef_data,'inv_high_cut_frequency')); 
    zef.inv_high_cut_frequency = zef_data.inv_high_cut_frequency; 
end;
if(isfield(zef_data,'inv_data_segment')); 
    zef.inv_data_segment = zef_data.inv_data_segment; 
end;

if (isfield(zef_data,'cp2_on')); 
    zef.cp2_on = zef_data.cp2_on; 
end;
if (isfield(zef_data,'cp2_a')); 
    zef.cp2_a = zef_data.cp2_a; 
end;
if (isfield(zef_data,'cp2_b')); 
    zef.cp2_b = zef_data.cp2_b; 
end;
if (isfield(zef_data,'cp2_c')); 
    zef.cp2_c = zef_data.cp2_c;
end;
if (isfield(zef_data,'cp2_d')); 
    zef.cp2_d = zef_data.cp2_d; 
end;

if (isfield(zef_data,'cp3_on')); 
    zef.cp3_on = zef_data.cp3_on; 
end;
if (isfield(zef_data,'cp3_a')); 
    zef.cp3_a = zef_data.cp3_a; 
end;
if (isfield(zef_data,'cp3_b')); 
    zef.cp3_b = zef_data.cp3_b; 
end;
if (isfield(zef_data,'cp3_c')); 
    zef.cp3_c = zef_data.cp3_c;
end;
if (isfield(zef_data,'cp3_d')); 
    zef.cp3_d = zef_data.cp3_d; 
end;

if (isfield(zef_data,'inv_dynamic_range')); 
    zef.inv_dynamic_range = zef_data.inv_dynamic_range; 
end;

if (isfield(zef_data,'inv_scale')); 
    zef.inv_scale = zef_data.inv_scale; 
end;

if (isfield(zef_data,'inv_colormap')); 
    zef.inv_colormap = zef_data.inv_colormap; 
end;

if (isfield(zef_data,'project_file')); 
    zef.project_file= zef_data.project_file; 
end;

if (isfield(zef_data,'project_file_path')); 
    zef.project_file_path = zef_data.project_file_path; 
end;

if (isfield(zef_data,'wm_sources_old')); 
    zef.wm_sources_old = zef_data.wm_sources_old; 
end;

if (isfield(zef_data,'layer_transparency')); 
    zef.layer_transparency = zef_data.layer_transparency; 
end;

if (isfield(zef_data,'meshing_threshold')); 
    zef.meshing_threshold = zef_data.meshing_threshold; 
end;

if (isfield(zef_data,'normalize_data')); 
    zef.normalize_data = zef_data.normalize_data; 
end;

if (isfield(zef_data,'cp_mode')); 
    zef.cp_mode = zef_data.cp_mode; 
end;

if (isfield(zef_data,'inv_time_1')); 
    zef.inv_time_1 = zef_data.inv_time_1; 
end;

if (isfield(zef_data,'inv_time_1')); 
    zef.inv_time_2 = zef_data.inv_time_2; 
end;

if (isfield(zef_data,'inv_time_3')); 
    zef.inv_time_3 = zef_data.inv_time_3; 
end;
if (isfield(zef_data,'number_of_frames')); 
    zef.number_of_frames = zef_data.number_of_frames; 
end;

if (isfield(zef_data,'frame_start')); 
    zef.frame_start = zef_data.frame_start; 
end;

if (isfield(zef_data,'frame_stop')); 
    zef.frame_stop = zef_data.frame_stop; 
end;

if (isfield(zef_data,'frame_step')); 
    zef.frame_step = zef_data.frame_step; 
end;

if (isfield(zef_data,'orbit_1')); 
    zef.orbit_1 = zef_data.orbit_1; 
end;

if (isfield(zef_data,'orbit_2')); 
    zef.orbit_2 = zef_data.orbit_2; 
end;

if (isfield(zef_data,'non_source_ind')); 
    zef.non_source_ind = zef_data.non_source_ind; 
end;

          if (isfield(zef_data,'inv_multires_dec'));
          zef.inv_multires_dec = zef_data.inv_multires_dec; 
          else
          zef.inv_multires_dec = [];
          end
          if (isfield(zef_data,'inv_multires_ind'));
          zef.inv_multires_ind = zef_data.inv_multires_ind; 
          else
          zef.inv_multires_ind = [];
          end
           if (isfield(zef_data,'inv_multires_count'));
          zef.inv_multires_count = zef_data.inv_multires_count; 
          else
          zef.inv_multires_count = [];
          end
          if (isfield(zef_data,'inv_multires_n_levels'));
          zef.inv_multires_n_levels = zef_data.inv_multires_n_levels; 
          else
          zef.inv_multires_n_levels = [3];
          end
          if (isfield(zef_data,'inv_multires_sparsity'));
          zef.inv_multires_sparsity = zef_data.inv_multires_sparsity; 
          else
          zef.inv_multires_sparsity = [4];
          end
          if (isfield(zef_data,'inv_multires_n_iter'));
          zef.inv_multires_n_iter = zef_data.inv_multires_n_iter; 
          else
          zef.inv_multires_n_iter = [10 3 3];
          end   
          if (isfield(zef_data,'inv_bg_data'));
          zef.inv_bg_data = zef_data.inv_bg_data;
          else
           zef.inv_bg_data = [];
          end
          if (isfield(zef_data,'inv_roi_perturbation'));
          zef.inv_roi_perturbation = zef_data.inv_roi_perturbation;
          else
          zef.inv_roi_perturbation = 0.1;
          end
          if (isfield(zef_data,'current_pattern'));
          zef.current_pattern = zef_data.current_pattern;
          else
          zef.current_pattern = [];
          end 
          if (isfield(zef_data,'inv_eit_noise'));
          zef.inv_eit_noise = zef_data.inv_eit_noise;
          else
          zef.inv_eit_noise = 0;
          end 
          
clear zef_data;
zef_update;
end;






%color_label('checkbox1','checkbox7','text196');
%color_label('checkbox101','checkbox107','text1196');
%color_label('checkbox201','checkbox207','text2196');
%color_label('checkbox301','checkbox307','text3196');
%color_label('checkbox2','checkbox8','text197');
%color_label('checkbox3','checkbox9','text198');
%color_label('checkbox4','checkbox10','text199');
%color_label('checkbox5','checkbox11','text200');
%switch_color('checkbox16','pushbutton16','s_points');
%if zef.imaging_method==2
%switch_color('checkbox17','pushbutton17','s_directions');
%end
%switch_color('checkbox1','pushbutton1','w_points');
%switch_color('checkbox101','pushbutton101','d1_points');
%switch_color('checkbox201','pushbutton201','d2_points');
%switch_color('checkbox301','pushbutton301','d3_points');
%switch_color('checkbox2','pushbutton3','g_points');
%switch_color('checkbox2','pushbutton4','g_triangles');
%switch_color('checkbox3','pushbutton5','c_points');
%switch_color('checkbox3','pushbutton6','c_triangles');
%switch_color('checkbox4','pushbutton7','sk_points');
%switch_color('checkbox4','pushbutton8','sk_triangles');
%switch_color('checkbox5','pushbutton9','sc_points');
%switch_color('checkbox5','pushbutton10','sc_triangles');
%
%switch_onoff;
%end





