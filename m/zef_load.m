%Copyright © 2018, Sampsa Pursiainen
      
if not(isempty(zef.save_file_path)) & not(zef.save_file_path==0)  
[zef.file zef.file_path] = uigetfile('*.mat','Open project',zef.save_file_path);
else
[zef.file zef.file_path] = uigetfile('*.mat','Open project');
end
if not(isequal(zef.file,0));
zef.save_file = zef.file; 
zef.save_file_path = zef.file_path; 
zef_close_tools;
zef_close_figs;
zef_mesh_tool;
zef_init;
load([zef.file_path zef.file]);
          if (isfield(zef_data,'parcellation_tolerance'));
          zef.parcellation_tolerance = zef_data.parcellation_tolerance; 
          end
          if (isfield(zef_data,'parcellation_selected'));
          zef.parcellation_selected = zef_data.parcellation_selected; 
          end
 if (isfield(zef_data,'parcellation_colormap'));
          zef.inv_parcellation_colormap = zef_data.parcellation_colormap; 
 end
           if (isfield(zef_data,'parcellation_interp_ind'));
          zef.inv_parcellation_interp_ind = zef_data.parcellation_interp_ind; 
          end
if (isfield(zef_data,'inv_rec_source'));
          zef.inv_rec_source = zef_data.inv_rec_source; 
          end
 if (isfield(zef_data,'inv_synth_source'));
          zef.inv_synth_source = zef_data.inv_synth_source; 
          end
          if (isfield(zef_data,'inv_roi_sphere'));
          zef.inv_roi_sphere = zef_data.inv_roi_sphere; 
          end
          if (isfield(zef_data,'inv_roi_threshold'));
          zef.inv_roi_threshold = zef_data.inv_roi_threshold; 
          end
          if (isfield(zef_data,'inv_roi_mode'));
          zef.inv_roi_mode = zef_data.inv_roi_mode; 
          end
          if (isfield(zef_data,'inv_n_sampler'));
          zef.inv_n_sampler = zef_data.inv_n_sampler; 
          end
          if (isfield(zef_data,'inv_n_burn_in'));
          zef.inv_n_burn_in = zef_data.inv_n_burn_in; 
          end
          if (isfield(zef_data,'use_depth_electrodes'));
          zef.use_depth_electrodes = zef_data.use_depth_electrodes; 
          end;
          if (isfield(zef_data,'source_model'));
          zef.source_model = zef_data.source_model; 
          end;
          if isfield(zef_data,'reconstruction_type')
          zef.reconstruction_type      =      zef_data.reconstruction_type;
          end
          if isfield(zef_data,'use_gpu')
          zef.use_gpu      =      zef_data.use_gpu;
          end
          if isfield(zef_data,'gpu_num') 
          zef.gpu_num      =      zef_data.gpu_num;
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
         zef.d2_scaling=         zef_data.d2_scaling  ;
             zef.d3_scaling=         zef_data.d3_scaling  ; 
             zef.d4_scaling=         zef_data.d4_scaling  ;  
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
             zef.sk_scaling=   zef_data.sk_scaling        ;
              zef.c_scaling=          zef_data.c_scaling  ;
              zef.g_scaling=          zef_data.g_scaling  ;
              zef.w_scaling=          zef_data.w_scaling  ;
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
if (isfield(zef_data,'d1_sources'));
zef.d1_sources = zef_data.d1_sources; 
end;
if (isfield(zef_data,'d2_sources'));
zef.d2_sources = zef_data.d2_sources; 
end;
if (isfield(zef_data,'d3_sources'));
zef.d3_sources = zef_data.d3_sources; 
end;
if (isfield(zef_data,'d4_sources'));
zef.d4_sources = zef_data.d4_sources; 
end;
if (isfield(zef_data,'g_sources'));
zef.g_sources = zef_data.g_sources; 
end;
if (isfield(zef_data,'c_sources'));
zef.c_sources = zef_data.c_sources; 
end;
if (isfield(zef_data,'sk_sources'));
zef.sk_sources = zef_data.sk_sources; 
end;
if (isfield(zef_data,'sc_sources'));
zef.sc_sources = zef_data.sc_sources; 
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

if (isfield(zef_data,'d1_sources_old')); 
    zef.d1_sources_old = zef_data.d1_sources_old; 
end;

if (isfield(zef_data,'d2_sources_old')); 
    zef.d2_sources_old = zef_data.d2_sources_old; 
end;

if (isfield(zef_data,'d3_sources_old')); 
    zef.d3_sources_old = zef_data.d3_sources_old; 
end;

if (isfield(zef_data,'d4_sources_old')); 
    zef.d4_sources_old = zef_data.d4_sources_old; 
end;


if (isfield(zef_data,'g_sources_old')); 
    zef.g_sources_old = zef_data.g_sources_old; 
end;

if (isfield(zef_data,'c_sources_old')); 
    zef.c_sources_old = zef_data.c_sources_old; 
end;

if (isfield(zef_data,'sk_sources_old')); 
    zef.sk_sources_old = zef_data.sk_sources_old; 
end;

if (isfield(zef_data,'sc_sources_old')); 
    zef.sc_sources_old = zef_data.sc_sources_old; 
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
          end
          if (isfield(zef_data,'inv_multires_ind'));
          zef.inv_multires_ind = zef_data.inv_multires_ind; 
          end
           if (isfield(zef_data,'inv_multires_count'));
          zef.inv_multires_count = zef_data.inv_multires_count; 
          end
          if (isfield(zef_data,'inv_multires_n_levels'));
          zef.inv_multires_n_levels = zef_data.inv_multires_n_levels; 
          end
          if (isfield(zef_data,'inv_multires_n_decompositions'));
          zef.inv_multires_n_decompositions = zef_data.inv_multires_n_decompositions; 
          end
          if (isfield(zef_data,'inv_multires_sparsity'));
          zef.inv_multires_sparsity = zef_data.inv_multires_sparsity; 
          end
          if (isfield(zef_data,'inv_multires_n_iter'));
          zef.inv_multires_n_iter = zef_data.inv_multires_n_iter; 
          end   
          if (isfield(zef_data,'inv_bg_data'));
          zef.inv_bg_data = zef_data.inv_bg_data;
          end
          if (isfield(zef_data,'inv_roi_perturbation'));
          zef.inv_roi_perturbation = zef_data.inv_roi_perturbation;
          end
          if (isfield(zef_data,'current_pattern'));
          zef.current_pattern = zef_data.current_pattern;
          end 
          if (isfield(zef_data,'inv_eit_noise'));
          zef.inv_eit_noise = zef_data.inv_eit_noise;
          end 
          if (isfield(zef_data,'inv_init_guess_mode'));
          zef.inv_init_guess_mode = zef_data.inv_init_guess_mode;
          end
          if (isfield(zef_data,'loop_movie'));
          zef.loop_movie = zef_data.loop_movie;
          end
          if (isfield(zef_data,'stop_movie'));
          zef.stop_movie = zef_data.stop_movie;
          end
          if (isfield(zef_data,'brain_transparency'));
          zef.brain_transparency = zef_data.brain_transparency; 
          end
          if (isfield(zef_data,'parcellation_interp_ind'));
          zef.parcellation_interp_ind = zef_data.parcellation_interp_ind; 
          end
          if (isfield(zef_data,'parcellation_colormap'));
          zef.parcellation_colormap = zef_data.parcellation_colormap; 
          end
          if (isfield(zef_data,'parcellation_name'));
          zef.parcellation_name = zef_data.parcellation_name; 
          end
          if (isfield(zef_data,'parcellation_colortable'));
          zef.parcellation_colortable = zef_data.parcellation_colortable; 
          end
          if (isfield(zef_data,'use_parcellation'));
          zef.use_parcellation = zef_data.use_parcellation; 
          end
          if (isfield(zef_data,'parcellation_points'));
          zef.parcellation_points = zef_data.parcellation_points; 
          end
          if (isfield(zef_data,'parcellation_segment'));
          zef.parcellation_segment = zef_data.parcellation_segment; 
          end
          if (isfield(zef_data,'parcellation_merge'));
          zef.parcellation_merge = zef_data.parcellation_merge; 
          end
          
          
          
          if isfield(zef_data,'s_name')
            zef.s_name = zef_data.s_name;
          zef.w_name =  zef_data.w_name;
          zef.g_name =  zef_data.g_name;
          zef.c_name =  zef_data.c_name;
          zef.sk_name =  zef_data.sk_name;
          zef.sc_name =  zef_data.sc_name;
          zef.d1_name =  zef_data.d1_name;
          zef.d2_name =  zef_data.d2_name;
          zef.d3_name =  zef_data.d3_name;
          zef.d4_name =  zef_data.d4_name;
          zef.d5_name =  zef_data.d5_name;
          zef.d6_name =  zef_data.d6_name;
          zef.d7_name =  zef_data.d7_name;
          zef.d8_name =  zef_data.d8_name;
          zef.d9_name =  zef_data.d9_name;
          zef.d10_name =  zef_data.d10_name;
          zef.d11_name =  zef_data.d11_name;
          zef.d12_name =  zef_data.d12_name;
          zef.d13_name =  zef_data.d13_name;
          
          zef.s_merge = zef_data.s_merge;
          zef.w_merge = zef_data.w_merge;
          zef.g_merge = zef_data.g_merge;
          zef.c_merge = zef_data.c_merge;
          zef.sk_merge = zef_data.sk_merge;
          zef.sc_merge = zef_data.sc_merge;
          zef.d1_merge = zef_data.d1_merge;
          zef.d2_merge = zef_data.d2_merge;
          zef.d3_merge = zef_data.d3_merge;
          zef.d4_merge = zef_data.d4_merge;
          zef.d5_merge = zef_data.d5_merge;
          zef.d6_merge = zef_data.d6_merge;
          zef.d7_merge = zef_data.d7_merge;
          zef.d8_merge = zef_data.d8_merge;
          zef.d9_merge = zef_data.d9_merge;
          zef.d10_merge = zef_data.d10_merge;
          zef.d11_merge = zef_data.d11_merge;
          zef.d12_merge = zef_data.d12_merge;
          zef.d13_merge = zef_data.d13_merge;
          
          zef.s_invert = zef_data.s_invert;
          zef.w_invert = zef_data.w_invert;
          zef.g_invert = zef_data.g_invert;
          zef.c_invert = zef_data.c_invert;
          zef.sk_invert = zef_data.sk_invert;
          zef.sc_invert = zef_data.sc_invert;
          zef.d1_invert = zef_data.d1_invert;
          zef.d2_invert = zef_data.d2_invert;
          zef.d3_invert = zef_data.d3_invert;
          zef.d4_invert = zef_data.d4_invert;
          zef.d5_invert = zef_data.d5_invert;
          zef.d6_invert = zef_data.d6_invert;
          zef.d7_invert = zef_data.d7_invert;
          zef.d8_invert = zef_data.d8_invert;
          zef.d9_invert = zef_data.d9_invert;
          zef.d10_invert = zef_data.d10_invert;
          zef.d11_invert = zef_data.d11_invert;
          zef.d12_invert = zef_data.d12_invert;
          zef.d13_invert = zef_data.d13_invert;
          
          zef.d5_sigma=            zef_data.d5_sigma ;
          zef.d6_sigma=           zef_data.d6_sigma ;
          zef.d7_sigma=           zef_data.d7_sigma ;
          zef.d8_sigma=           zef_data.d8_sigma ;
           zef.d9_sigma=            zef_data.d9_sigma ;
          zef.d10_sigma=           zef_data.d10_sigma ;
          zef.d11_sigma=           zef_data.d11_sigma ;
          zef.d12_sigma=           zef_data.d12_sigma ; 
          zef.d13_sigma=           zef_data.d13_sigma ; 
          
          zef.d5_visible=          zef_data.d5_visible  ;
             zef.d6_visible=          zef_data.d6_visible  ; 
             zef.d7_visible=          zef_data.d7_visible  ;
             zef.d8_visible=          zef_data.d8_visible  ; 
             zef.d9_visible=          zef_data.d9_visible  ;
             zef.d10_visible=          zef_data.d10_visible  ; 
             zef.d11_visible=          zef_data.d11_visible  ;
             zef.d12_visible=          zef_data.d12_visible  ; 
             zef.d13_visible=          zef_data.d13_visible  ;

             zef.d5_on     =          zef_data.d5_on;    
             zef.d6_on     =          zef_data.d6_on;    
             zef.d7_on     =          zef_data.d7_on;
             zef.d8_on     =          zef_data.d8_on;    
             zef.d9_on     =          zef_data.d9_on;    
             zef.d10_on     =          zef_data.d10_on;    
             zef.d11_on     =          zef_data.d11_on;
             zef.d12_on     =          zef_data.d12_on;
             zef.d13_on     =          zef_data.d13_on;
             
             zef.d5_scaling=         zef_data.d5_scaling  ;
             zef.d6_scaling=         zef_data.d6_scaling  ;
             zef.d7_scaling=         zef_data.d7_scaling  ; 
             zef.d8_scaling=         zef_data.d8_scaling  ;  
             zef.d9_scaling=         zef_data.d9_scaling  ;
             zef.d10_scaling=         zef_data.d10_scaling  ;
             zef.d11_scaling=         zef_data.d11_scaling  ; 
             zef.d12_scaling=         zef_data.d12_scaling  ;  
             zef.d13_scaling=         zef_data.d13_scaling  ; 
             
            zef.d5_triangles=        zef_data.d5_triangles  ;
               zef.d5_points=           zef_data.d5_points  ;
            zef.d6_triangles=        zef_data.d6_triangles  ;
               zef.d6_points=           zef_data.d6_points  ;
            zef.d7_triangles=        zef_data.d7_triangles  ;
               zef.d7_points=           zef_data.d7_points  ;
            zef.d8_triangles=        zef_data.d8_triangles  ;
               zef.d8_points=           zef_data.d8_points  ;
            zef.d9_triangles=        zef_data.d9_triangles  ;
          zef.d9_points=           zef_data.d9_points  ;
           zef.d10_triangles=        zef_data.d10_triangles  ;
               zef.d10_points=           zef_data.d10_points  ;
            zef.d11_triangles=        zef_data.d11_triangles  ;
               zef.d11_points=           zef_data.d11_points  ;
            zef.d12_triangles=        zef_data.d12_triangles  ;
               zef.d12_points=           zef_data.d12_points  ;
            zef.d13_triangles=        zef_data.d13_triangles  ;
          zef.d13_points=           zef_data.d13_points  ;  
          
           zef.d5_priority = zef_data.d5_priority;
           zef.d6_priority = zef_data.d6_priority;
           zef.d7_priority = zef_data.d7_priority;
           zef.d8_priority = zef_data.d8_priority;
           zef.d9_priority = zef_data.d9_priority;
           zef.d10_priority = zef_data.d10_priority;
           zef.d11_priority = zef_data.d11_priority;
           zef.d12_priority = zef_data.d12_priority;
           zef.d13_priority = zef_data.d13_priority;
           
end
                    
clear zef_data;
zef_update;
zef_figure_tool;
end;








