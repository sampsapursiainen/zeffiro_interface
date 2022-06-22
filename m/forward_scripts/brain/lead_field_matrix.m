%Copyright © 2018- Sampsa Pursiainen & ZI Development Team
%See: https://github.com/sampsapursiainen/zeffiro_interface

[zef.lead_field_id, zef.lead_field_id_max]  = zef_update_lead_field_id(zef.lead_field_id,zef.lead_field_id_max,'create');

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
zef.aux_vec_sources = zeros(length(zef.compartment_tags),1);

for zef_i = 1 : length(zef.compartment_tags)
    zef.aux_vec_sources(zef_i) = evalin('base',['isequal(zef.' zef.compartment_tags{zef_i} '_sources_old, zef.' zef.compartment_tags{zef_i} '_sources);']);
end

% if not(zef.source_space_lock_on) && ( isempty(zef.source_ind) || not(zef.n_sources == zef.n_sources_old) || ismember(false,zef.aux_vec_sources) )

if isempty(zef.non_source_ind)
    zef.aux_vec = zef.brain_ind;
else
    zef.aux_vec = setdiff(zef.brain_ind,zef.non_source_ind);
end

% Limit ourselves to tetra deep enough (default 1 mm) in the gray matter.

if ~ isfield(zef, 'acceptable_source_depth')
    zef.acceptable_source_depth = 1; % mm
end

[~, ~, ~, zef.aux_vec] = zef_deep_nodes_and_tetra( ...
    zef.nodes, ...
    zef.tetra, ...
    zef.aux_vec, ...
    zef.acceptable_source_depth ...
);

zef.n_sources_old = zef.n_sources;

for zef_i = 1 : length(zef.compartment_tags)
    evalin('base',['zef.' zef.compartment_tags{zef_i} '_sources_old = zef.' zef.compartment_tags{zef_i} '_sources;']);
end

clear zef_i;

zef.lf_tag = zef.forward_simulation_table{zef.forward_simulation_selected(1), 1};

[~,~,~,zef.source_ind] = zef_decompose_dof_space(zef.nodes,zef.tetra,zef.aux_vec,[],zef.n_sources,2);

zef.n_sources_aux = zef.n_sources;

for zef_i = 1 : zef.source_space_creation_iterations
    zef.n_sources_aux = round(zef.n_sources*zef.n_sources_aux/length(zef.source_ind));
    [~,~,~,zef.source_ind] = zef_decompose_dof_space(zef.nodes,zef.tetra,zef.aux_vec,[],zef.n_sources_aux,2);
end

zef = rmfield(zef,'n_sources_aux');
zef.source_ind = zef.aux_vec(zef.source_ind);
zef.n_sources_mod = 0;

%end % if

zef.sensors_aux = zef.sensors;
zef.nodes_aux = zef.nodes/1000;

if ismember(zef.lead_field_type,[1,4,5]) & size(zef.sensors,2) == 3
    zef.sensors_aux = zef.sensors_attached_volume(:,1:3)/1000;
elseif ismember(zef.lead_field_type,[2,3])
    zef.sensors_aux(:,1:3) = zef.sensors_aux(:,1:3)/1000;
else
    zef.sensors_aux = zef.sensors_attached_volume;
end

zef.lf_param.dipole_mode = 1;

if zef.lead_field_type == 1

    if size(zef.sensors,2) == 6
        zef.lf_param.impedances = zef.sensors(:,6);
    end

    if evalin('base','zef.prism_layers') && not(isempty(zef.prisms))
        [zef.L, zef.source_positions, zef.source_directions] = lead_field_eeg_fem(zef.nodes_aux,{zef.tetra,zef.prisms},{zef.sigma(:,1),zef.sigma_prisms},zef.sensors_aux,zef.brain_ind,zef.source_ind,zef.lf_param);
    else
        [zef.L, zef.source_positions, zef.source_directions] = lead_field_eeg_fem(zef.nodes_aux,zef.tetra,zef.sigma(:,1),zef.sensors_aux,zef.brain_ind,zef.source_ind,zef.lf_param);
    end

end

if zef.lead_field_type == 2;
    if evalin('base','zef.prism_layers') && not(isempty(zef.prisms))
        [zef.L, zef.source_positions, zef.source_directions] = lead_field_meg_fem(zef.nodes_aux,{zef.tetra,zef.prisms},{zef.sigma(:,1),zef.sigma_prisms},zef.sensors_aux,zef.brain_ind,zef.source_ind,zef.lf_param);
    else
        [zef.L, zef.source_positions, zef.source_directions] = lead_field_meg_fem(zef.nodes_aux,zef.tetra,zef.sigma(:,1),zef.sensors_aux,zef.brain_ind,zef.source_ind,zef.lf_param);
    end
end

if zef.lead_field_type == 3;
    if evalin('base','zef.prism_layers') && not(isempty(zef.prisms))
        [zef.L, zef.source_positions, zef.source_directions] = lead_field_meg_grad_fem(zef.nodes_aux,{zef.tetra,zef.prisms},{zef.sigma(:,1),zef.sigma_prisms},zef.sensors_aux,zef.brain_ind,zef.source_ind,zef.lf_param);
    else
        [zef.L, zef.source_positions, zef.source_directions] = lead_field_meg_grad_fem(zef.nodes_aux,zef.tetra,zef.sigma(:,1),zef.sensors_aux,zef.brain_ind,zef.source_ind,zef.lf_param);
    end
end

if zef.lead_field_type == 4

    if size(zef.sensors,2) == 6
        zef.lf_param.impedances = zef.sensors(:,6);
    end

    if evalin('base','zef.prism_layers') && not(isempty(zef.prisms))
        [zef.L, zef.inv_bg_data, zef.source_positions, zef.source_directions, zef.eit_ind, zef.eit_count] = lead_field_eit_fem(zef.nodes_aux,{zef.tetra,zef.prisms},{zef.sigma(:,1),zef.sigma_prisms},zef.sensors_aux,zef.brain_ind,zef.source_ind,zef.lf_param);
    else
        [zef.L, zef.inv_bg_data, zef.source_positions, zef.source_directions, zef.eit_ind, zef.eit_count] = lead_field_eit_fem(zef.nodes_aux,zef.tetra,zef.sigma(:,1),zef.sensors_aux,zef.brain_ind,zef.source_ind,zef.lf_param);
    end
end

if zef.lead_field_type == 5;

    if size(zef.sensors,2) == 6
        zef.lf_param.impedances = zef.sensors(:,6);
    end

    if evalin('base','zef.prism_layers') && not(isempty(zef.prisms))
        [zef.L, zef.S, zef.source_positions, zef.source_directions, zef.eit_ind, zef.eit_count] = lead_field_tes_fem(zef.nodes_aux,{zef.tetra,zef.prisms},{zef.sigma(:,1),zef.sigma_prisms},zef.sensors_aux,zef.brain_ind,zef.source_ind,zef.lf_param);
    else
        [zef.L, zef.S, zef.source_positions, zef.source_directions, zef.eit_ind, zef.eit_count] = lead_field_tes_fem(zef.nodes_aux, zef.tetra,zef.sigma(:,1),zef.sensors_aux,zef.brain_ind,zef.source_ind,zef.lf_param);
    end
end

zef = rmfield(zef,{'nodes_aux','sensors_aux','aux_vec','aux_vec_sources'});

zef.lead_field_time = toc;

if zef.location_unit == 1
    zef.source_positions = 1000*zef.source_positions;
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
