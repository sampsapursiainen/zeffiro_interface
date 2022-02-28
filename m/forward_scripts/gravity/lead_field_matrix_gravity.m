%Copyright © 2018, Sampsa Pursiainen
%[zef.rho,zef.brain_ind] = zef_rho([]);
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
if isempty(zef.source_ind) || not(zef.n_sources == zef.n_sources_old) || not(zef.wm_sources == zef.wm_sources_old)
if isempty(zef.non_source_ind)
zef.aux_vec = zef.brain_ind;
else
zef.aux_vec = setdiff(zef.brain_ind,zef.non_source_ind);
end
zef.aux_vec = zef.aux_vec(randperm(length(zef.aux_vec)));
zef.n_sources_old = zef.n_sources;
zef.wm_sources_old = zef.wm_sources;
zef.source_ind = zef.aux_vec(1:min(zef.n_sources,length(zef.aux_vec)));
zef.n_sources_mod = 0;
end
zef.sensors_aux = zef.sensors;
zef.nodes_aux = zef.nodes;%/1000;
%if ismember(zef.imaging_method,[1,4,5]) & size(zef.sensors,2) == 3
%zef.sensors_aux = zef.sensors_attached_volume(:,1:3)/1000;
%elseif ismember(zef.imaging_method,[2,3])
zef.sensors_aux(:,1:3) = zef.sensors_aux(:,1:3);%/1000;
%else
%zef.sensors_aux = zef.sensors_attached_volume;
%end

zef.lf_param.dipole_mode = 1;

% if zef.imaging_method == 0
% if size(zef.sensors,2) == 6
% zef.lf_param.impedances = zef.sensors(:,6);
% end
% if evalin('base','zef.prism_layers') && not(isempty(zef.prisms))
% [zef.L, zef.source_positions, zef.source_directions] = lead_field_eeg_fem(zef.nodes_aux,{zef.tetra,zef.prisms},{zef.rho(:,1),zef.rho_prisms},zef.sensors_aux,zef.brain_ind,zef.source_ind,zef.lf_param);
% else
% [zef.L, zef.source_positions, zef.source_directions] = lead_field_eeg_fem(zef.nodes_aux,zef.tetra,zef.rho(:,1),zef.sensors_aux,zef.brain_ind,zef.source_ind,zef.lf_param);
% end
% end
%
 if ismember(zef.gravity_field_type,[1,2])
[zef.L, zef.inv_bg_data, zef.source_positions, zef.source_directions] = lead_field_gravity_grad(zef.nodes_aux,zef.tetra,zef.rho(:,1),zef.sensors_aux,zef.brain_ind,zef.source_ind,zef.lf_param);
 end

% if zef.imaging_method == 3;
% if evalin('base','zef.prism_layers') && not(isempty(zef.prisms))
% [zef.L, zef.source_positions, zef.source_directions] = lead_field_meg_grad_fem(zef.nodes_aux,{zef.tetra,zef.prisms},{zef.rho(:,1),zef.rho_prisms},zef.sensors_aux,zef.brain_ind,zef.source_ind,zef.lf_param);
% else
% [zef.L, zef.source_positions, zef.source_directions] = lead_field_meg_grad_fem(zef.nodes_aux,zef.tetra,zef.rho(:,1),zef.sensors_aux,zef.brain_ind,zef.source_ind,zef.lf_param);
% end
% end

if ismember(zef.gravity_field_type,[3,4])
% if size(zef.sensors,2) == 6
% zef.lf_param.impedances = zef.sensors(:,6);
% end
[zef.L, zef.inv_bg_data, zef.source_positions, zef.source_directions] = lead_field_gravity(zef.nodes_aux,zef.tetra,zef.rho(:,1),zef.sensors_aux,zef.brain_ind,zef.source_ind,zef.lf_param);
end

zef = rmfield(zef,{'nodes_aux','sensors_aux','aux_vec'});

zef.lead_field_time = toc;

if zef.location_unit == 1
%zef.source_positions = 1000*zef.source_positions;
zef.location_unit_current = 1;
end

if zef.location_unit == 2
zef.source_positions = 100*zef.source_positions;
zef.location_unit_current = 2;
end

if zef.location_unit == 3
zef.location_unit_current = 3;
end

if zef.source_interpolation_on
[zef.source_interpolation_ind] = source_interpolation([]);
end
