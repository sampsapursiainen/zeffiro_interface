%Copyright © 2018- Sampsa Pursiainen & ZI Development Team
%See: https://github.com/sampsapursiainen/zeffiro_interface
tic;

if zef.source_direction_mode == 1
zef.lf_param.direction_mode = 'cartesian';
end
if zef.source_direction_mode == 2
zef.lf_param.direction_mode = 'normal';
end
if zef.source_direction_mode == 3
zef.lf_param.direction_mode = 'face_based';
end
if isfield(zef,'preconditioner')
if zef.preconditioner == 1
zef.lf_param.precond = 'cholinc';
elseif zef.preconditioner == 2
zef.lf_param.precond = 'ssor';
end
end
if isfield(zef,'preconditioner_tolerance')
zef.lf_param.cholinc_tol = zef.preconditioner_tolerance;
else
zef.lf_param.cholinc_tol = 0.001;
end
if isfield(zef,'solver_tolerance')
zef.lf_param.pcg_tol = zef.solver_tolerance;
else
zef.lf_param.pcg_tol = 1e-8;
end
zef.aux_vec = [];
if isempty(zef.source_ind) || not(zef.n_sources == zef.n_sources_old) || not(zef.w_sources == zef.w_sources_old) || not(zef.d1_sources == zef.d1_sources_old)  || not(zef.d2_sources == zef.d2_sources_old)  || not(zef.d3_sources == zef.d3_sources_old) || not(zef.d4_sources == zef.d4_sources_old) || not(zef.g_sources == zef.g_sources_old)  || not(zef.c_sources == zef.c_sources_old)  || not(zef.sk_sources == zef.sk_sources_old) || not(zef.sc_sources == zef.sc_sources_old) || not(zef.d5_sources == zef.d5_sources_old)  || not(zef.d6_sources == zef.d6_sources_old)  || not(zef.d7_sources == zef.d7_sources_old) || not(zef.d8_sources == zef.d8_sources_old) || not(zef.d9_sources == zef.d9_sources_old)  || not(zef.d10_sources == zef.d10_sources_old)  || not(zef.d11_sources == zef.d11_sources_old) || not(zef.d12_sources == zef.d12_sources_old) || not(zef.d13_sources == zef.d13_sources_old) || not(zef.d14_sources == zef.d14_sources_old)  || not(zef.d15_sources == zef.d15_sources_old)  || not(zef.d16_sources == zef.d16_sources_old) || not(zef.d17_sources == zef.d17_sources_old) || not(zef.d18_sources == zef.d18_sources_old)  || not(zef.d19_sources == zef.d19_sources_old)  || not(zef.d20_sources == zef.d20_sources_old) || not(zef.d21_sources == zef.d21_sources_old) || not(zef.d22_sources == zef.d22_sources_old)
if isempty(zef.non_source_ind)
zef.aux_vec = zef.brain_ind;
else
zef.aux_vec = setdiff(zef.brain_ind,zef.non_source_ind);
end
zef.aux_vec = zef.aux_vec(randperm(length(zef.aux_vec)));
zef.n_sources_old = zef.n_sources;
for zef_i = 1 : length(zef.compartment_tags)
evalin('base',['zef.' zef.compartment_tags{zef_i} '_sources_old = zef.' zef.compartment_tags{zef_i} '_sources;']);
end

zef.source_ind = zef.aux_vec(1:min(zef.n_sources,length(zef.aux_vec)));
zef.n_sources_mod = 0;
end
zef.sensors_aux = zef.sensors;
zef.nodes_aux = zef.nodes/1000;
if ismember(zef.imaging_method, [1 3 4]) & size(zef.sensors,2) == 3
zef.sensors_aux = zef.sensors_attached_volume(:,1:3)/1000;
elseif zef.imaging_method == 2
zef.sensors_aux(:,1:3) = zef.sensors_aux(:,1:3)/1000;
else
zef.sensors_aux = zef.sensors_attached_volume;
end

zef.lf_param.dipole_mode = 1;

if zef.imaging_method == 4
if size(zef.sensors,2) == 6
zef.lf_param.impedances = zef.sensors(:,6);
end
[zef.measurements] = compute_eit_data(zef.nodes_aux,zef.tetra,zef.sigma(:,1),zef.sensors_aux,zef.brain_ind,zef.source_ind,zef.lf_param);
end

zef = rmfield(zef,{'nodes_aux','sensors_aux','aux_vec'});

