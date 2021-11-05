%Copyright © 2018- Sampsa Pursiainen & ZI Development Team
%See: https://github.com/sampsapursiainen/zeffiro_interface



if not(isfield(zef,'smoothing_steps_ele')); 
zef.smoothing_steps_ele = 100;
end


if not(isfield(zef,'source_space_creation_iterations')); 
zef.source_space_creation_iterations = 2;
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

if not(isfield(zef,'use_gpu')); 
    zef.use_gpu = 1; 
end;

if not(isfield(zef,'gpu_num')); 
    zef.gpu_num = 1; 
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
