%Copyright © 2018- Sampsa Pursiainen & ZI Development Team
%See: https://github.com/sampsapursiainen/zeffiro_interface
if zef.mlapp == 1

zef.submesh_num = str2num(get(zef.h_submesh_num,'Value'));
zef.reconstruction_type = get(zef.h_reconstruction_type,'Value');
zef.parcellation_type = get(zef.h_parcellation_type,'Value');
zef.parcellation_quantile = str2num(get(zef.h_parcellation_quantile,'Value'));
zef.use_depth_electrodes = get(zef.h_use_depth_electrodes,'Value');
zef.source_model = get(zef.h_source_model,'Value');
zef.use_gpu = get(zef.h_use_gpu,'Value');
zef.gpu_num = str2num(get(zef.h_gpu_num,'Value'));
zef.preconditioner = get(zef.h_as_opt_1,'Value'); 
zef.preconditioner_tolerance = str2num(get(zef.h_as_opt_2,'Value')); 
zef.smoothing_steps_surf = str2num(get(zef.h_as_opt_3,'Value')); 
zef.smoothing_steps_vol = str2num(get(zef.h_as_opt_4,'Value'));
zef.refinement_type = get(zef.h_as_opt_5,'Value');
zef.surface_sources = get(zef.h_as_opt_6,'Value');
zef.cp2_on = get(zef.h_cp2_on,'Value');
zef.cp_mode = get(zef.h_cp_mode,'Value');
zef.cp2_a = str2num(get(zef.h_cp2_a,'Value'));
zef.cp2_b = str2num(get(zef.h_cp2_b,'Value'));
zef.cp2_c = str2num(get(zef.h_cp2_c,'Value'));
zef.cp2_d = str2num(get(zef.h_cp2_d,'Value'));
zef.cp3_on = get(zef.h_cp3_on,'Value');
zef.cp3_a = str2num(get(zef.h_cp3_a,'Value'));
zef.cp3_b = str2num(get(zef.h_cp3_b,'Value'));
zef.cp3_c = str2num(get(zef.h_cp3_c,'Value'));
zef.cp3_d = str2num(get(zef.h_cp3_d,'Value'));
zef.inv_hyperprior_tail_length_db = str2num(get(zef.h_inv_hyperprior_tail_length_db,'Value'));
zef.inv_prior_over_measurement_db = str2num(get(zef.h_inv_prior_over_measurement_db,'Value'));
zef.colortune_param = str2num(get(zef.h_colortune_param,'Value'));
zef.surface_sources = get(zef.h_as_opt_6,'Value');
zef.inv_hyperprior = get(zef.h_inv_hyperprior,'Value');
zef.inv_hyperprior_weight = get(zef.h_inv_hyperprior_weight,'Value');
zef.inv_snr = str2num(get(zef.h_inv_snr,'Value'));

if str2num(get(zef.h_inv_dynamic_range,'Value'))== 0
    zef.inv_dynamic_range = Inf; 
else
    zef.inv_dynamic_range = 1/str2num(get(zef.h_inv_dynamic_range,'Value')); 
end
    zef.inv_scale = get(zef.h_inv_scale ,'Value');
    zef.inv_colormap = get(zef.h_inv_colormap ,'Value');
    zef.layer_transparency = 1 - str2num(get(zef.h_layer_transparency ,'Value'));
zef.brain_transparency = 1 - str2num(get(zef.h_brain_transparency ,'Value'));
    zef.meshing_threshold = str2num(get(zef.h_meshing_threshold,'Value'));
zef.frame_start = str2num(get(zef.h_frame_start,'Value'));
zef.frame_stop = str2num(get(zef.h_frame_stop,'Value'));
zef.frame_step = str2num(get(zef.h_frame_step,'Value'));
zef.orbit_1 = str2num(get(zef.h_orbit_1,'Value'));
zef.orbit_2 = str2num(get(zef.h_orbit_2,'Value'));
   
if zef.cp2_on
    zef.h_cp2_a.Enable = 'on';
    zef.h_cp2_b.Enable = 'on';
    zef.h_cp2_c.Enable = 'on';
    zef.h_cp2_d.Enable = 'on';
else
    zef.h_cp2_a.Enable = 'off';
    zef.h_cp2_b.Enable = 'off';
    zef.h_cp2_c.Enable = 'off';
    zef.h_cp2_d.Enable = 'off';
end

if zef.cp3_on
zef.h_cp3_a.Enable = 'on';
zef.h_cp3_b.Enable = 'on';
zef.h_cp3_c.Enable = 'on';
zef.h_cp3_d.Enable = 'on';
else
zef.h_cp3_a.Enable = 'off';
zef.h_cp3_b.Enable = 'off';
zef.h_cp3_c.Enable = 'off';
zef.h_cp3_d.Enable = 'off';
end

else
    
zef.submesh_num = str2num(get(zef.h_submesh_num,'string'));
zef.reconstruction_type = get(zef.h_reconstruction_type,'value');
zef.parcellation_type = get(zef.h_parcellation_type,'value');
zef.parcellation_quantile = str2num(get(zef.h_parcellation_quantile,'string'));
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
zef.inv_hyperprior_tail_length_db = str2num(get(zef.h_inv_hyperprior_tail_length_db,'string'));
zef.colortune_param = str2num(get(zef.h_colortune_param,'string'));
zef.surface_sources = get(zef.h_as_opt_6,'value');
zef.inv_hyperprior = get(zef.h_inv_hyperprior,'value');
zef.inv_hyperprior_weight = get(zef.h_inv_hyperprior_weight,'value');

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
end


if gpuDeviceCount > 0 & zef.use_gpu == 1
gpuDevice(zef.gpu_num);
end
