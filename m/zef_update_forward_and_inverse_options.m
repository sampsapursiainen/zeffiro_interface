%Copyright © 2018- Sampsa Pursiainen & ZI Development Team
%See: https://github.com/sampsapursiainen/zeffiro_interface
   zef.preconditioner = get(zef.h_as_opt_1,'Value');
    zef.preconditioner_tolerance = str2num(get(zef.h_as_opt_2,'Value'));
    zef.smoothing_steps_surf = str2num(get(zef.h_as_opt_3,'Value'));
    zef.smoothing_steps_vol = str2num(get(zef.h_as_opt_4,'Value'));
    zef.meshing_threshold = str2num(get(zef.h_meshing_threshold,'Value'));
    zef.refinement_type = get(zef.h_as_opt_5,'Value');
    zef.surface_sources = get(zef.h_as_opt_6,'Value');
    zef.use_depth_electrodes = get(zef.h_use_depth_electrodes,'Value');
    zef.source_model = get(zef.h_source_model,'Value');
    zef.use_gpu         = get(zef.h_use_gpu,'Value');
    zef.gpu_num = str2num(get(zef.h_gpu_num,'Value'));
    zef.smoothing_steps_ele = str2num(get(zef.h_smoothing_steps_ele,'Value')); 
    zef.mesh_smoothing_repetitions = str2num(zef.h_mesh_smoothing_repetitions.Value);
    zef.mesh_optimization_repetitions = str2num(zef.h_mesh_optimization_repetitions.Value);
    zef.mesh_optimization_parameter = str2num(zef.h_mesh_optimization_parameter.Value);
    zef.mesh_labeling_approach =  zef.h_mesh_labeling_approach.Value;
    zef.source_space_creation_iterations = str2num(zef.h_source_space_creation_iterations.Value);
    zef.normalize_lead_field = str2num(zef.h_normalize_lead_field.Value);
    
if gpuDeviceCount > 0 & zef.use_gpu == 1
    gpuDevice(zef.gpu_num);
end