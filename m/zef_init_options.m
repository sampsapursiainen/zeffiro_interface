%Copyright © 2018, Sampsa Pursiainen

if not(isfield(zef,'reconstruction_type')); 
    zef.reconstruction_type = 1; 
end; 
if not(isfield(zef,'use_depth_electrodes')); 
    zef.use_depth_electrodes = 0; 
end; 
if not(isfield(zef,'source_model')); 
    zef.source_model = 1; 
end; 
if not(isfield(zef,'preconditioner')); 
    zef.preconditioner = 1; 
end; 
if not(isfield(zef,'preconditioner_tolerance')); 
    zef.preconditioner_tolerance = 0.001; 
end;
if not(isfield(zef,'smoothing_steps_surf')); 
    zef.smoothing_steps_surf = 9; 
end;
if not(isfield(zef,'smoothing_steps_vol')); 
    zef.smoothing_steps_vol = 1; 
end;
if not(isfield(zef,'refinement_type')); 
    zef.refinement_type = 1; 
end;
if not(isfield(zef,'surface_sources')); 
    zef.surface_sources = 0; 
end;

if not(isfield(zef,'use_gpu')); 
    zef.use_gpu = 0; 
end;


if not(isfield(zef,'gpu_num')); 
    zef.gpu_num = 1; 
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

