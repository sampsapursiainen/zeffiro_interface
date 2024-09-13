%Copyright © 2018- Sampsa Pursiainen & ZI Development Team
%See: https://github.com/sampsapursiainen/zeffiro_interface
%
%zef_lead_field_matrix is a function for creating a lead field matrix.
function zef = zef_lead_field_matrix(zef)

if nargin == 0
    zef = evalin('base','zef');
end

zef.brain_ind = zef_find_active_compartment_ind(zef);
zef.active_compartment_ind = zef.brain_ind;

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

zef.brain_activity_inds = [];
zef.aux_vec_sources = zeros(length(zef.compartment_tags),1);

for zef_i = 1 : length(zef.compartment_tags)
    zef.aux_vec_sources(zef_i) = eval(['isequal(zef.' zef.compartment_tags{zef_i} '_sources_old, zef.' zef.compartment_tags{zef_i} '_sources);']);
end

% if not(zef.source_space_lock_on) && ( isempty(zef.source_ind) || not(zef.n_sources == zef.n_sources_old) || ismember(false,zef.aux_vec_sources) )

if isempty(zef.non_source_ind)
    zef.brain_activity_inds = zef.brain_ind;
else
    zef.brain_activity_inds = setdiff(zef.brain_ind,zef.non_source_ind);
end

%% Determine which tetra are to be used as sources
%
% Start by limiting ourselves to tetra deep enough in the gray matter. The
% depth of 0 mm is used by default, but the below requirement for having at
% least 4 neighbours makes sure that we are not directly on the surface.

if ~ isfield(zef, 'acceptable_source_depth')
    warning(['Using default acceptable depth of ' num2str(0) ' mm for source tetra.'])
    zef.acceptable_source_depth = 0; % mm
end

[T_fi, G_fi, ~, ~, ~, ~] = zef_fi_dipoles( ...
    zef.nodes, ...
    zef.tetra, ...
    zef.brain_ind ...
    );

% Also restrict to tetra which have 4 neighbours to make sure we are not on
% the surface, but in the brain.

valid_source_inds_builder = full(find(sum(T_fi,1) == 4))';

clear T_fi;

[~, ~, ~, zef.brain_activity_inds] = zef_deep_nodes_and_tetra( ...
    zef.nodes, ...
    zef.tetra, ...
    zef.brain_activity_inds, ...
    zef.acceptable_source_depth ...
    );

zef.brain_activity_inds = intersect(zef.brain_activity_inds, valid_source_inds_builder);

clear valid_source_inds_builder;

zef.n_sources_old = zef.n_sources;

for zef_i = 1 : length(zef.compartment_tags)
    eval(['zef.' zef.compartment_tags{zef_i} '_sources_old = zef.' zef.compartment_tags{zef_i} '_sources;']);
end

clear zef_i;

% Decompose source space into a rectangular lattice and extract the indices of
% the source tetra in this frame of reference. Nearest source neighbour inds
% will be empty when discrete source models are used.

[zef.nearest_source_neighbour_inds, zef.source_ind] = decomposition_and_source_index_fn( ...
    zef.nodes, ...
    zef.tetra, ...
    zef.brain_activity_inds, ...
    zef.source_model, ...
    zef.n_sources, ...
    zef.source_space_creation_iterations ...
    );

% Determine which tetra are to be used as sources in their own frame of
% reference.

zef.source_ind = zef.brain_activity_inds(zef.source_ind);
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

% Set wanted optimization system type. Default value is 'pbo'.

if isfield(zef, 'optimization_system_type')
    % Do nothing
else
    zef.optimization_system_type = 'pbo';
end

%% Call one of the lead field routines.

if zef.lead_field_type == 1

    if size(zef.sensors,2) == 6
        zef.lf_param.impedances = zef.sensors(:,6);
    end

    [zef.L, zef.source_positions, zef.source_directions] = zef_lead_field_eeg_fem( ...
        zef, ...
        zef.nodes_aux, ...
        {zef.tetra,zef.prisms}, ...
        {zef.sigma(:,1), zef.sigma_prisms}, ...
        zef.sensors_aux, ...
        zef.nearest_source_neighbour_inds, ...
        zef.optimization_system_type, ...
        zef.brain_ind, ...
        zef.source_ind, ...
        zef.lf_param ...
        );
end

if zef.lead_field_type == 2

    [zef.L, zef.source_positions, zef.source_directions] = zef_lead_field_meg_fem( ...
        zef, ...
        zef.nodes_aux, ...
        {zef.tetra,zef.prisms}, ...
        {zef.sigma(:,1),zef.sigma_prisms}, ...
        zef.sensors_aux, ...
        zef.nearest_source_neighbour_inds, ...
        zef.brain_ind, ...
        zef.source_ind, ...
        zef.lf_param ...
        );

end

if zef.lead_field_type == 3

    [zef.L, zef.source_positions, zef.source_directions] = zef_lead_field_meg_grad_fem( ...
        zef, ...
        zef.nodes_aux, ...
        {zef.tetra,zef.prisms}, ...
        {zef.sigma(:,1),zef.sigma_prisms}, ...
        zef.sensors_aux, ...
        zef.nearest_source_neighbour_inds, ...
        zef.brain_ind, ...
        zef.source_ind, ...
        zef.lf_param ...
        );

end

if zef.lead_field_type == 4

    if size(zef.sensors,2) == 6
        zef.lf_param.impedances = zef.sensors(:,6);
    end

    [zef.L, zef.inv_bg_data, zef.source_positions, zef.source_directions, zef.eit_ind, zef.eit_count] = zef_lead_field_eit_fem( ...
        zef, ...
        zef.nodes_aux, ...
        {zef.tetra,zef.prisms}, ...
        {zef.sigma(:,1),zef.sigma_prisms}, ...
        zef.sensors_aux, ...
        zef.nearest_source_neighbour_inds, ...
        zef.brain_ind, ...
        zef.source_ind, ...
        zef.lf_param ...
        );

end

if zef.lead_field_type == 5

    if size(zef.sensors,2) == 6
        zef.lf_param.impedances = zef.sensors(:,6);
    end


    [zef.L, zef.S, zef.source_positions, zef.source_directions, zef.eit_ind, zef.eit_count] = zef_lead_field_tes_fem( ...
        zef, ...
        zef.nodes_aux, ...
        {zef.tetra,zef.prisms}, ...
        {zef.sigma(:,1),zef.sigma_prisms}, ...
        zef.sensors_aux, ...
        zef.nearest_source_neighbour_inds, ...
        zef.brain_ind, ...
        zef.source_ind, ...
        zef.lf_param ...
        );

end

zef = rmfield(zef,{'nodes_aux','sensors_aux','aux_vec_sources'});

clear optimization_system_type;

zef.lead_field_time = toc;

%% Perform final unit conversions and source interpolation.

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
    zef = zef_source_interpolation(zef);
end

if nargout == 0
    assignin('base','zef',zef);
end

end

%% Local helper functions

function [nearest_source_neighbour_inds, source_inds] = decomposition_and_source_index_fn( ...
    nodes, ...
    tetra, ...
    restricted_brain_inds, ...
    source_model, ...
    wanted_n_of_sources, ...
    source_space_creation_iterations ...
    )

% Documentation
%
% Generates (extrapolated) node (degree of freedom) and source indices for
% a node space.
%
% Input:
%
% - nodes
%
%   The finite element node cloud of the model under observation.
%
% - tetra
%
%   The tetrahedra (4-tuples of node indices) that are formed from the
%   above nodes.
%
% - restricted_brain_inds
%
%   The subset of tetra that dipolar sources can be placed into.
%
% - wanted_n_of_sources
%
%   The number of sources one wishes to generate.
%
% - source_space_creation_iterations
%
%   The number of extrapolation iterations performed to make sure that we
%   get as close to the wanted number of sources as was wanted.
%
% Output:
%
% - nearest_source_neighbour_inds
%
%   The indices that denote the node decomposition positions in the FEM
%   mesh.
%
% - source_inds
%
%   The tetrahedra that will be used as sources, based on the generated
%   decomposition.

arguments
    nodes (:,3) double
    tetra (:,4) double { mustBeInteger, mustBePositive }
    restricted_brain_inds (:,1) double { mustBeInteger, mustBePositive }
    source_model
    wanted_n_of_sources (1,1) double { mustBeInteger, mustBePositive }
    source_space_creation_iterations (1,1) double { mustBeInteger, mustBePositive }
end

% Create initial decomposition of node (degree of freedom, DOF) space.

[nearest_source_neighbour_inds, ~, ~, source_inds] = zef_decompose_dof_space( ...
    nodes, ...
    tetra, ...
    restricted_brain_inds, ...
    [], ...
    wanted_n_of_sources, ...
    2 ...
    );

% Extrapolate, if we have less sources than we wanted.

n_of_sources = wanted_n_of_sources;

for ind = 1 : source_space_creation_iterations

    n_of_sources = round(wanted_n_of_sources * n_of_sources / length(source_inds));

    [nearest_source_neighbour_inds, ~, ~, source_inds] = zef_decompose_dof_space( ...
        nodes, ...
        tetra, ...
        restricted_brain_inds, ...
        [], ...
        n_of_sources, ...
        2 ...
        );

end

% Set empty decomposition indices, if source model is not continuous.

switch zefCore.ZefSourceModel.from(source_model)

    case zefCore.ZefSourceModel.Error

        error('Received and erraneous source model.')

    case { ...
            zefCore.ZefSourceModel.ContinuousWhitney, ...
            zefCore.ZefSourceModel.ContinuousHdiv, ...
            zefCore.ZefSourceModel.ContinuousStVenant ...
            }

        % Do nothing

    otherwise

        nearest_source_neighbour_inds = [];

end % switch

end % function
