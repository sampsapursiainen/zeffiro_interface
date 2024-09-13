function [G, interpolation_positions] = zef_st_venant_interpolation( ...
    p_nodes, ...
    p_tetrahedra, ...
    p_brain_inds, ...
    p_intended_source_inds, ...
    p_nearest_neighbour_inds, ...
    p_regparam ...
    )

% Documentation
%
% Produces an interpolation matrix G in a tetrahedral finite element mesh
% with the St. Venant method. Also produces the related interpolation
% positions.
%
% Input:
%
% - p_nodes
%
%   The nodes that form the tetrahedral mesh.
%
% - p_tetrahedra
%
%   The tetrahedra (4-tuples of node indices) that are formed from
%   p_nodes.
%
% - p_brain_inds
%
%   The indices of the tetrahedra where sources can be placed in the first
%   place. In other words, these tetra form the gray matter.
%
% - p_intended_source_inds
%
%   These are the subset of the tetrahedral indices which indicate where
%   dipolar sources are to be placed in, not just where they can be
%   placed.
%
% - p_nearest_neighbour_inds
%
%   Used by the continuous source models to determine which neighbours of
%   neighbours of each central source tetrahedron are to be included in
%   the interpolation. If this is empty, the source model is interpreted
%   as being discrete.
%
% - p_regparam
%
%   A regularization parameter used to scale a certain weight matrix in
%   the formulation of the interpolation coeficient matrix.
%
% Output:
%
% - G
%
%   Interpolation matrix that is to be multiplied by the transpose of the
%   transfer matrix in the lead field routines.
%
% - interpolation_positions
%
%   The positions at which sources are the be placed after interpolation.

arguments
    p_nodes (:,3) double {mustBeNonNan}
    p_tetrahedra (:,4) double {mustBeInteger, mustBePositive}
    p_brain_inds (:,1) double {mustBeInteger, mustBePositive}
    p_intended_source_inds (:,1) double {mustBeInteger, mustBePositive}
    p_nearest_neighbour_inds (:,1) double {mustBeInteger, mustBePositive}
    p_regparam (1,1) double
end

G = [];

interpolation_positions = [];

% Open up a zef_waitbar

wbtitle = 'Lead field interpolation (St. Venant)';
wb = zef_waitbar(0,1, wbtitle);

% Define cleanup operations, in case of an interruption.

cleanupfn = @(handle) close(handle);

cleanupobj = onCleanup(@() cleanupfn(wb));

% Define adjacency matrix for tetrahedra

adjacency_mat = zef_adjacency_matrix(p_nodes, p_tetrahedra(p_brain_inds,:));

%% First find nodes closest to the given positions.

% Nearest nodes for each interpolation position with KDTree search

MdlKDT = KDTreeSearcher(p_nodes);

interpolation_positions = zef_tetra_barycentra(p_nodes, p_tetrahedra(p_intended_source_inds, :));

center_node_inds = knnsearch(MdlKDT, interpolation_positions);

% Storage for the interpolation results.

n_of_iters = numel(center_node_inds);

print_interval = ceil(n_of_iters / 100);

% Initialize interpolation weight matrix G

Grows = size(p_nodes, 1);

Gcols = 3 * size(interpolation_positions, 1);

G = sparse(Grows, Gcols, 0);

%% Interpolation for each position

wbtitleloop = [wbtitle, ': interpolation '];

% Cartesian directions for interpolation

basis = eye(3);

% Iterate over neighbours of each center node and form the monopolar
% loads.

for ind = 1 : n_of_iters

    % Update zef_waitbar.

    if mod(ind, print_interval) == 0

        zef_waitbar(ind , n_of_iters, wb, [wbtitleloop, num2str(ind), ' / ', num2str(n_of_iters)]);

    end

    % Fetch reference node coordinates

    refnode_ind = center_node_inds(ind);

    refnode = p_nodes(refnode_ind, :);

    % Calculate the distances from refnode with Matlab's broadcasting
    % mechanism and save them to the preallocated distance matrix.

    neighbour_inds = find(adjacency_mat(:, refnode_ind));

    % Also gather additional tetra into the neighbour inds, if a
    % continuous model (indicated by non-empty nearest neighbours) is
    % used.

    if ~ isempty(p_nearest_neighbour_inds)
        % TODO
    end

    % Some nodes apparently have no neighbours. Go figure...

    if isempty(neighbour_inds)
        continue
    end

    neighbour_inds = setdiff(neighbour_inds, refnode_ind);

    n_of_neighbours = numel(neighbour_inds); % + 1;

    neighbours = p_nodes(neighbour_inds, :);

    neighbour_diffs = neighbours - refnode;

    % Calculate the distances and longest edge.

    dists = zef_L2_norm(neighbour_diffs, 2);

    longest_edge_len = max(dists, [], 'all');

    %% Construct restriction matrices P, b and regularization matrix D.

    P = zeros(9, n_of_neighbours);

    % Conservation of charge (rows of ones)

    P(1:3:end,:) = repmat(ones(1, size(P, 2)), 3, 1);

    % Dipole moment approximations

    moments = (1/longest_edge_len) * neighbour_diffs;

    moment_x = moments * basis(:,1);
    moment_y = moments * basis(:,2);
    moment_z = moments * basis(:,3);

    try
        P(2,:) = moment_x';
        P(5,:) = moment_y';
        P(8,:) = moment_z';
    catch
        keyboard;
    end

    % Suppression of higher order moments

    P(3,:) = moment_x'.^2;
    P(6,:) = moment_y'.^2;
    P(9,:) = moment_z'.^2;

    % Vector b

    b = zeros(9,3);

    b(2:3:end, :) = basis / longest_edge_len;

    % Regularization matrix D

    D = diag(sum(dists.^2, 2));

    % Form the monopolar loads m via least squares approximation
    % m = inv(P'P + aD)P'b.

    m = inv(P' * P + p_regparam * D) * P' * b;

    col_inds = (3 * (ind-1) + 1 : 3 * ind);

    G(neighbour_inds, col_inds) = m(:,1:3);

end

% TODO
%
% Find out why this sign flip is needed! We already know that
% zef_transfer_matrix produces a wrongly oriented (negative) Schur
% complement because the B and C matrices are not the same for EEG and
% tES, but is this related to that, or was a minus sign forgotten from the
% above equations?

G = -G;

end
