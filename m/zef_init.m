%Copyright © 2018- Sampsa Pursiainen & ZI Development Team
%See: https://github.com/sampsapursiainen/zeffiro_interface

zef_delete_original_surface_meshes;
zef_delete_original_field;

zef_data.imaging_method_cell = {'EEG', 'MEG magnetometers', 'MEG gradiometers', 'EIT', 'tES'}; 
zef_data.imaging_method= 1;

zef_init_compartments;
zef_init_sensors;

zef_data.cone_draw = 0;
zef_data.cone_lattice_resolution = 10;
zef_data.cone_scale = 0.5;
zef_data.lead_field_id = 0; 
zef_data.lead_field_id_max = 0;
zef_data.inv_amplitude_db = 20;
zef_data.sigma_bypass = 0;
zef_data.source_space_lock_on = 0;
zef_data.lock_on = 0;
zef_data.lock_sensor_names_on = 0;
zef_data.lock_transforms_on = 0;
zef_data.lock_sensor_sets_on = 0;
zef_data.lock_sensors_on = 0;
zef_data.lock_transform_on = 0;
zef_data.sensors_visual_size = 3.5;
zef_data.project_notes = '';
zef_data.current_version = 3.0;
zef_data.font_size = zef.font_size;
zef_data.matlab_release = version('-release');
zef_data.matlab_release = str2num(zef_data.matlab_release(1:4)) + double(zef_data.matlab_release(5))/128;
zef_data.code_path = zef.code_path;
zef_data.program_path = zef.program_path;
zef_data.save_file_path = zef.save_file_path;
zef_data.save_file = zef.save_file;
zef_data.video_codec = zef.video_codec;
zef_data.use_gpu = zef.use_gpu;
zef_data.gpu_num = zef.gpu_num;
zef_data.parallel_vectors = zef.parallel_vectors;
zef_data.snapshot_vertical_resolution = zef.snapshot_vertical_resolution;
zef_data.snapshot_horizontal_resolution = zef.snapshot_horizontal_resolution;
zef_data.movie_fps = zef.movie_fps;
zef_data.mlapp = zef.mlapp;

zef_data.noise_data = [];
zef_data.top_reconstruction = [];
          zef_data.multi_lead_field = 0;
          zef_data.imaging_method_cell = {'EEG'; 'MEG magnetometers'; 'MEG gradiometers'; 'EIT'; 'tES';}; 
          zef_data.colortune_param = 1;
          zef_data.submesh_num = 0;
          zef_data.parcellation_plot_type = 1;
          zef_data.parcellation_time_series = [];
          zef_data.parcellation_colormap = [];
          zef_data.parcellation_interp_ind = cell(0);
          zef_data.parcellation_name = '';
          zef_data.parcellation_colortable = cell(0);
          zef_data.use_parcellation = 0;
          zef_data.parcellation_merge = 1;
          zef_data.parcellation_points = cell(0);
          zef_data.parcellation_segment = 'LH';
          zef_data.parcellation_tolerance = 5;
          zef_data.parcellation_selected = [];
          zef_data.parcellation_type = [1];
          zef_data.parcellation_quantile = [0.98];

          
          zef_data.loop_movie = [0];
          zef_data.loop_movie_count = [5];
          zef_data.stop_movie = [0];
          zef_data.inv_init_guess_mode = [1];
          zef_data.inv_eit_noise = 0;
          zef_data.inv_bg_data = [];
          zef_data.inv_roi_perturbation = 0.1;
          zef_data.current_pattern = [];
          zef_data.background_data = [];
          zef_data.inv_multires_n_decompositions = [20];
          zef_data.inv_multires_dec = []; 
          zef_data.inv_multires_ind = []; 
          zef_data.inv_multires_count = [];
          zef_data.inv_multires_n_levels = [3];
          zef_data.inv_multires_sparsity = 8;
          zef_data.inv_multires_n_iter = [10 10 10];
          zef_data.h_rec_source = [];
          zef_data.h_synth_source = [];
          zef_data.h_roi_sphere = [];
          zef_data.inv_rec_source = [0 0 0 1 0 0 0 3 1];
          zef_data.inv_synth_source = [0 0 0 1 0 0 10 0 3 1];
          zef_data.inv_roi_mode = 3;
          zef_data.inv_roi_threshold = 0.5;
          zef_data.inv_roi_sphere = [0 0 0 15];
          zef_data.inv_n_sampler = 100; 
          zef_data.inv_n_burn_in = 10; 
          zef_data.reconstruction_type = 7;
          zef_data.h_colorbar   = [];
          zef_data.location_unit= 1;
              zef_data.elevation= 0;
                zef_data.azimuth= 0;
           zef_data.axes_visible= 0;
              zef_data.n_sources= 10000;
        zef_data.mesh_resolution= 2;
      zef_data.attach_electrodes= 1;

 zef_data.source_direction_mode = 2;
             
         
                 
               zef_data.sensors = [];
               zef_data.reuna_p = cell(0);
               zef_data.reuna_t = cell(0);
               zef_data.nodes   = [];
                zef_data.tetra  = [];
                zef_data.save_file_path = './data/';
                zef_data.save_file = 'default_project.mat';
                zef_data.tetra_aux = [];
                zef_data.nodes_b = [];

                 zef_data.cam_va = 10;
         zef_data.preconditioner = 2;
      zef_data.solver_tolerance = 1e-6;
zef_data.preconditioner_tolerance= 0.001;
               zef_data.sigma_ind=[];
               zef_data.sigma=[];
               zef_data.sigma_vec=[];
               zef_data.sigma_mod=0;
zef_data.sensors_attached_volume = [];
      zef_data.surface_triangles = [];
      zef_data.n_sources_mod     = 0; 
      zef_data.n_sources_old     = 10000;
 zef_data.location_unit_current = 1;
                      zef_data.L = [];
       zef_data.source_positions = [];
       zef_data.source_directions = [];
              zef_data.brain_ind = [];
             zef_data.source_ind = [];

            
            zef_data.cp_on       = 0;
            zef_data.cp_a        = 1;
            zef_data.cp_b        = 0;
            zef_data.cp_c        = 0;
            zef_data.cp_d        = 0;
       zef_data.meshing_accuracy = 5000;
       zef_data.on_screen        = 0;
       zef_data.import_mode      = 0;

       zef_data.mesh_smoothing_on = 0;

       zef_data.prism_layers = 0;
       zef_data.n_prism_layers = 2;
       zef_data.prism_size = 0.01;
       zef_data.prisms = [];
       zef_data.sigma_prisms = [];
       zef_data.refinement_on = 0;
       zef_data.smoothing_strength = 0.25;
       zef_data.smoothing_steps_surf = 15;
       zef_data.smoothing_steps_vol = 5;
       zef_data.refinement_type = 1;
       zef_data.surface_sources = 0; 
       zef_data.visualization_type = 1;
       zef_data.source_interpolation_on = 0;
       zef_data.measurements = [];
       zef_data.reconstruction = [];
       zef_data.inv_hyperprior = [1]; 
       zef_data.inv_hyperprior_weight = [1]; 
       zef_data.inv_beta = [1.5];
       zef_data.inv_theta0 = [1e-12];
       zef_data.inv_likelihood_std = 0.03;
       zef_data.inv_n_map_iterations = [1];
       zef_data.inv_pcg_tol = [1e-6];
       zef_data.inv_sampling_frequency = [20000];
       zef_data.inv_low_cut_frequency = [20];
       zef_data.inv_high_cut_frequency = [250];
       zef_data.inv_data_segment = [1];
       zef_data.source_interpolation_ind = [];
       zef_data.cp2_on = 0;
       zef_data.cp2_a = 1;
       zef_data.cp2_b = 0;
       zef_data.cp2_c = 0;
       zef_data.cp2_d = 0;
       zef_data.cp3_on = 0;
       zef_data.cp3_a = 1;
       zef_data.cp3_b = 0;
       zef_data.cp3_c = 0;
       zef_data.cp3_d = 0;
       zef_data.inv_dynamic_range = 1e2; 
       zef_data.inv_scale = 2;
       zef_data.inv_colormap = 5;
       zef_data.brain_transparency = 1;
       zef_data.layer_transparency = 1;
       zef_data.meshing_threshold = 0.5;
       zef_data.clear_axes1 = 1;
       zef_data.normalize_data = 1;
       zef_data.cp_mode = 1;
       zef_data.inv_time_1 = 0;
       zef_data.inv_time_2 = 0.002;
       zef_data.inv_time_3 = 0.001;
       zef_data.number_of_frames = 1;
       zef_data.frame_start = 0;
       zef_data.frame_stop = 0;
       zef_data.frame_step = 1;
       zef_data.orbit_1 = 0;
       zef_data.orbit_2 = 0;
       zef_data.non_source_ind = [];
       zef_data.source_model = 2;
       zef_data.use_depth_electrodes = 0;
       zef_data.inv_hyperprior_tail_length_db = 10;
       zef_data.inv_prior_over_measurement_db = 20;
       zef_data.inv_snr = 30;
       zef_data.downsample_surfaces = 1;
       zef_data.max_surface_face_count = 5000;
       zef_data.inflate_n_iterations = 500;
       zef_data.inflate_strength = 0.8;
       zef_data.use_inflated_surfaces = 0;
       zef_data.explode_everything = 1;
       zef_data.colormap_cell = {'zef_monterosso_colormap','zef_intensity_1_colormap','zef_intensity_2_colormap','zef_intensity_3_colormap','zef_contrast_1_colormap','zef_contrast_2_colormap','zef_contrast_3_colormap','zef_contrast_4_colormap','zef_contrast_5_colormap','zef_blue_brain_1_colormap','zef_blue_brain_2_colormap','zef_blue_brain_3_colormap','zef_parcellation_colormap'};
       zef_data.parcellation_compartment = {'g'};
       
       zef.fieldnames = fieldnames(zef);

for zef_i = 1 : length(zef.fieldnames)
    if isobject(evalin('base',['zef.' zef.fieldnames{zef_i}]))
    zef_data.(zef.fieldnames{zef_i}) = zef.(zef.fieldnames{zef_i});
    end
end
       
 zef = zef_data;
 
 if isfield(zef,'h_zeffiro_window_main')
     if isvalid(zef.h_zeffiro_window_main)
 zef.zeffiro_window_main_current_size = get(zef.h_zeffiro_window_main,'Position');
  zef.zeffiro_window_main_relative_size = zef_get_relative_size(zef.h_zeffiro_window_main);
     end
 end
 clear zef_i zef_data;
 
