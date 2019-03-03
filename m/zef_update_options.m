%Copyright © 2018, Sampsa Pursiainen
zef.reconstruction_type = get(zef.h_reconstruction_type,'value');
zef.use_depth_electrodes = get(zef.h_use_depth_electrodes,'value');
zef.source_model = get(zef.h_source_model,'value');
zef.use_gpu = get(zef.h_use_gpu,'value');
zef.gpu_num = str2num(get(zef.h_gpu_num,'string'));
zef.preconditioner = get(zef.h_as_opt_1,'value'); 
zef.preconditioner_tolerance = str2num(get(zef.h_as_opt_2,'string')); 
zef.smoothing_steps_surf = str2num(get(zef.h_as_opt_3,'string')); 
zef.smoothing_steps_vol = str2num(get(zef.h_as_opt_4,'string'));
zef.refinement_type = get(zef.h_as_opt_5,'value');
zef.surface_sources = get(zef.h_as_opt_6,'value');
zef.cp2_on = get(zef.h_cp2_on,'value');
zef.cp_mode = get(zef.h_cp_mode,'value');
zef.cp2_a = str2num(get(zef.h_cp2_a,'string'));
zef.cp2_b = str2num(get(zef.h_cp2_b,'string'));
zef.cp2_c = str2num(get(zef.h_cp2_c,'string'));
zef.cp2_d = str2num(get(zef.h_cp2_d,'string'));
zef.cp3_on = get(zef.h_cp3_on,'value');
zef.cp3_a = str2num(get(zef.h_cp3_a,'string'));
zef.cp3_b = str2num(get(zef.h_cp3_b,'string'));
zef.cp3_c = str2num(get(zef.h_cp3_c,'string'));
zef.cp3_d = str2num(get(zef.h_cp3_d,'string'));
if str2num(get(zef.h_inv_dynamic_range,'string'))== 0
    zef.inv_dynamic_range = Inf; 
else
    zef.inv_dynamic_range = 1/str2num(get(zef.h_inv_dynamic_range,'string')); 
end
    zef.inv_scale = get(zef.h_inv_scale ,'value');
    zef.inv_colormap = get(zef.h_inv_colormap ,'value');
    zef.layer_transparency = 1 - str2num(get(zef.h_layer_transparency ,'string'));
zef.brain_transparency = 1 - str2num(get(zef.h_brain_transparency ,'string'));
    zef.meshing_threshold = str2num(get(zef.h_meshing_threshold,'string'));
zef.frame_start = str2num(get(zef.h_frame_start,'string'));
zef.frame_stop = str2num(get(zef.h_frame_stop,'string'));
zef.frame_step = str2num(get(zef.h_frame_step,'string'));
zef.orbit_1 = str2num(get(zef.h_orbit_1,'string'));
zef.orbit_2 = str2num(get(zef.h_orbit_2,'string'));

if gpuDeviceCount > 0 & zef.use_gpu == 1
gpuDevice(zef.gpu_num);
end
