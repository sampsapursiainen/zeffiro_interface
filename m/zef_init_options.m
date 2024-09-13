%Copyright © 2018- Sampsa Pursiainen & ZI Development Team
%See: https://github.com/sampsapursiainen/zeffiro_interface

if not(isfield(zef,'streamline_draw'))
    zef.streamline_draw = 0;
end

if not(isfield(zef,'streamline_linestyle'));
    zef.streamline_linestyle = '-';
end

if not(isfield(zef,'smoothing_steps_ele'));
    zef.smoothing_steps_ele = 100;
end

if not(isfield(zef,'streamline_linewidth'));
    zef.streamline_linewidth = 1;
end

if not(isfield(zef,'streamline_color'));
    zef.streamline_color = 'blue';
end

if not(isfield(zef,'n_streamline'));
    zef.n_streamline = 100;
end

if not(isfield(zef,'submesh_num'));
    zef.submesh_num = 0;
end;

if not(isfield(zef,'cone_alpha'));
    zef.cone_alpha = 1;
end;

if not(isfield(zef,'reconstruction_type'));
    zef.reconstruction_type = 1;
end;
if not(isfield(zef,'cone_lattice_resolution'));
    zef.cone_field_lattice_resolution = 10;
end;
if not(isfield(zef,'cone_scale'));
    zef.cone_scale = 0.5;
end;
if not(isfield(zef,'parcellation_type'));
    zef.parcellation_type = 1;
end;
if not(isfield(zef,'inv_hyperprior_tail_length_db'));
    zef.inv_hyperprior_tail_length_db = 10;
end;
if not(isfield(zef,'inv_prior_over_measurement_db'));
    zef.inv_prior_over_measurement_db = 0;
end;
if not(isfield(zef,'parcellation_quantile'));
    zef.parcellation_quantile = 0.98;
end;
if not(isfield(zef,'use_depth_electrodes'));
    zef.use_depth_electrodes = 0;
end;
if not(isfield(zef,'source_model'));
    zef.source_model = zefCore.ZefSourceModel.Whitney;
end;
if not(isfield(zef,'preconditioner'));
    zef.preconditioner = 1;
end;
if not(isfield(zef,'downsample_surfaces'));
    zef.downsample_surfaces = 1;
end;
if not(isfield(zef,'max_surface_face_count'));
    zef.max_surface_face_count = 5000;
end;
if not(isfield(zef,'preconditioner_tolerance'));
    zef.preconditioner_tolerance = 0.001;
end;
if not(isfield(zef,'smoothing_steps_surf'));
    zef.smoothing_steps_surf = 1000;
end;
if not(isfield(zef,'smoothing_steps_vol'));
    zef.smoothing_steps_vol = 2;
end;
if not(isfield(zef,'refinement_type'));
    zef.refinement_type = 1;
end;
if not(isfield(zef,'surface_sources'));
    zef.surface_sources = 0;
end;
if not(isfield(zef,'colortune_param'));
    zef.colortune_param = 1;
end;

if not(isfield(zef,'use_gpu'));
    zef.use_gpu = 1;
end;

if not(isfield(zef,'use_gpu_graphic'));
    zef.use_gpu_graphic = 1;
end;

if not(isfield(zef,'gpu_num'));
    zef.gpu_num = 1;
end;

if not(isfield(zef,'inv_snr'));
    zef.inv_snr = 30;
end;

if not(isfield(zef,'cp2_on'));
    zef.cp2_on = 0;
end;
if not(isfield(zef,'cp2_a'));
    zef.cp2_a = 1;
end;
if not(isfield(zef,'cp2_b'));
    zef.cp2_b = 0;
end;
if not(isfield(zef,'cp2_c'));
    zef.cp2_c = 0;
end;
if not(isfield(zef,'cp2_d'));
    zef.cp2_d = 0;
end;

if not(isfield(zef,'cp3_on'));
    zef.cp3_on = 0;
end;
if not(isfield(zef,'cp3_a'));
    zef.cp3_a = 1;
end;
if not(isfield(zef,'cp3_b'));
    zef.cp3_b = 0;
end;
if not(isfield(zef,'cp3_c'));
    zef.cp3_c = 0;
end;
if not(isfield(zef,'cp3_d'));
    zef.cp3_d = 0;
end;

if not(isfield(zef,'inv_dynamic_range'));
    zef.inv_dynamic_range = 1e6;
end;

if not(isfield(zef,'inv_scale'));
    zef.inv_scale = 2;
end;

if not(isfield(zef,'inv_colormap'));
    zef.inv_colormap = 1;
end;

if not(isfield(zef,'brain_transparency'));
    zef.brain_transparency = 1;
end;

if not(isfield(zef,'layer_transparency'));
    zef.layer_transparency = 1;
end;

if not(isfield(zef,'meshing_threshold'));
    zef.meshing_threshold = 0.5;
end;

if not(isfield(zef,'cp_mode'));
    zef.cp_mode = 1;
end;

if not(isfield(zef,'frame_start'));
    zef.frame_start = 0;
end;

if not(isfield(zef,'frame_stop'));
    zef.frame_stop = 0;
end;

if not(isfield(zef,'frame_step'));
    zef.frame_step = 1;
end;

if not(isfield(zef,'orbit_1'));
    zef.orbit_1 = 0;
end;

if not(isfield(zef,'orbit_2'));
    zef.orbit_2 = 0;
end;

if not(isfield(zef,'inv_hyperprior'));
    zef.inv_hyperprior = 1;
end;

if not(isfield(zef,'inv_hyperprior_weight'));
    zef.inv_hyperprior_weight = 1;
end;

if not(isfield(zef,'mesh_smoothing_repetitions'));
    zef.mesh_smoothing_repetitions = 1;
end;

if not(isfield(zef,'mesh_optimization_repetitions'));
    zef.mesh_optimization_repetitions = 10;
end;

if not(isfield(zef,'mesh_optimization_parameter'));
    zef.mesh_optimization_parameter = 1E-5;
end;

if not(isfield(zef,'mesh_labeling_approach'));
    zef.mesh_labeling_approach = 1;
end;
