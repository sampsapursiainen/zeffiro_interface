% Copyright © 2018- Sampsa Pursiainen & ZI Development Team
% See: https://github.com/sampsapursiainen/zeffiro_interface
%
% TODO Documentation
%
% This function decomposes a given set of nodes and tetrahedra (degrees of
% freedom or DOF) into
%
% Input:
%
% - nodes
%
%   The nodes that make up a finite element mesh.
%
% - tetrahedra
%
%   Quadruples of node indices that indicate which nodes participate in which
%   tetrahedra.
%
% - brain_ind
%
%   Linear indices of tetrahedra that are in the brain and can contain brain
%   activity.
%
% - varargin{1}
%
%   Source indices. If not set, these are assumed to be the same as brain_ind.
%
% - varargin{2}
%
%   Wanted number of sources. If not set, these are fetched from the global
%   zef instance with evalin.
%
% - varargin{3}
%
%   DOF decomposition type. TODO. If not set, this is again fetched from the
%   global zef instance with evalin.
%
% Output:
%
% - nearest_neighbour_inds
%
%   Can be used to index into below decomposition_source_inds to find out
%   which tetra in the global mesh is closest to the tetrahedron corresponding
%   to it. For example
%
%       decomposition_source_inds(nearest_neighbour_inds(1))
%
%   would produce the nearest neighbour of the tetrahedron indicated by
%   brain_ind(1).
%
% - decomposition_count
%
%   The number of incidences of each (sorted) index in nearest_neighbour_inds,
%   meaning how many times each nearest neghbour is the nearest neighbour of
%   some tetrahedron. The main use of this is for normalizing results when the
%   index sets are used.
%
% - dof_positions
%
%   An array of decomposition node positions in a Cartesian coordinate system.
%   Depending on the current zef.dof_decomposition_type integer value, this
%   might be just (1 or 3) the set of barycentra of the tetrahedra in the FE
%   mesh, (2) a rectangular grid whose resolution is determined by the minimum
%   and maximum values of the mesh coordinates + a lattice constant computed
%   from these.
%
% - decomposition_source_inds
%
%   These can be used to index into the input brain_ind to determine which of
%   them can be used as dipolar sources in a head model.

function [ ...
    nearest_neighbour_inds, ...
    decomposition_count, ...
    dof_positions, ...
    decomposition_source_inds ...
] = zef_decompose_dof_space(nodes,tetrahedra,brain_ind,varargin)


    if not(isempty(varargin))

        source_ind = varargin{1};

        if length(varargin) > 1
            n_sources = varargin{2};
        else
            n_sources = evalin('base','zef.n_sources');
        end

        if length(varargin) > 2
            dof_decomposition_type = varargin{3};
        else
            dof_decomposition_type = evalin('base','zef.dof_decomposition_type');
        end

    else

        source_ind = brain_ind;
        n_sources = evalin('base','zef.n_sources');
        dof_decomposition_type = evalin('base','zef.dof_decomposition_type');

    end

    if isempty(source_ind)
        source_ind = brain_ind;
    end

    center_points = zef_tetra_barycentra(nodes, tetrahedra);
    center_points = center_points(brain_ind,:);

    if dof_decomposition_type == 1

        dof_positions = zef_tetra_barycentra(nodes, tetrahedra(source_ind, :));

        MdlKDT = KDTreeSearcher(dof_positions);
        nearest_neighbour_inds  = knnsearch(MdlKDT,center_points);

        [~, i_a, i_c] = unique(nearest_neighbour_inds);

        decomposition_count = accumarray(i_c,1);

        decomposition_source_inds = i_a;

    elseif dof_decomposition_type == 2

        min_x = min(center_points(:,1));
        max_x = max(center_points(:,1));
        min_y = min(center_points(:,2));
        max_y = max(center_points(:,2));
        min_z = min(center_points(:,3));
        max_z = max(center_points(:,3));

        lattice_constant = n_sources.^(1/3)/((max_x - min_x)*(max_y - min_y)*(max_z - min_z))^(1/3);
        lattice_res_x = floor(lattice_constant*(max_x - min_x));
        lattice_res_y = floor(lattice_constant*(max_y - min_y));
        lattice_res_z = floor(lattice_constant*(max_z - min_z));

        l_d_x = (max_x - min_x)/(lattice_res_x + 1);
        l_d_y = (max_y - min_y)/(lattice_res_y + 1);
        l_d_z = (max_z - min_z)/(lattice_res_z + 1);

        min_x = min_x + l_d_x;
        max_x = max_x - l_d_x;
        min_y = min_y + l_d_y;
        max_y = max_y - l_d_y;
        min_z = min_z + l_d_z;
        max_z = max_z - l_d_z;

        x_space = linspace(min_x,max_x,lattice_res_x);
        y_space = linspace(min_y,max_y,lattice_res_y);
        z_space = linspace(min_z,max_z,lattice_res_z);

        [X_lattice, Y_lattice, Z_lattice] = meshgrid(x_space, y_space, z_space);

        dof_positions = [X_lattice(:) Y_lattice(:) Z_lattice(:)];

        nearest_neighbour_inds = lattice_index_fn( ...
            center_points, ...
            lattice_res_x, ...
            lattice_res_y, ...
            lattice_res_z ...
        );

        [unique_nearest_neighbour_ind, i_a, i_c] = unique(nearest_neighbour_inds);

        nearest_neighbour_ind_to_be = zeros(size(dof_positions,1),1);

        nearest_neighbour_ind_to_be(unique_nearest_neighbour_ind) = 1 : length(unique_nearest_neighbour_ind);

        nearest_neighbour_inds = nearest_neighbour_ind_to_be(nearest_neighbour_inds);

        dof_positions = dof_positions(unique_nearest_neighbour_ind,:);

        decomposition_count = accumarray(i_c,1);

        decomposition_source_inds = i_a;

    elseif dof_decomposition_type == 3

         nearest_neighbour_inds = (1 : length(brain_ind))';

         decomposition_count = ones(size(nearest_neighbour_inds));

         dof_positions = center_points;

         decomposition_source_inds = (1 : length(brain_ind))';

    else

        error('Unknown dof_decomposition_type');

    end % if

end % zef_decompose_dof_space

%% Helper functions.

function out_indices = lattice_index_fn( ...
    in_center_points, ...
    in_lattice_res_x, ...
    in_lattice_res_y, ...
    in_lattice_res_z ...
)

    % Documentation
    %
    % A helper function for generating lattice indices based on the barycentra
    % of the tetrahedra that form the lattice, and the x-, y- and z-resultions
    % of the lattice.
    %
    % Input:
    %
    % - in_center_points: the barycenters of the tetrahedral lattice we are
    %   observing.
    %
    % - in_lattice_res_x: the resolution of the lattice in the x-direction.
    %
    % - in_lattice_res_y: the resolution of the lattice in the y-direction.
    %
    % - in_lattice_res_z: the resolution of the lattice in the z-direction.
    %
    % Output:
    %
    % - out_indices
    %
    %   Linear index locations of the tetrehedral barycenters in the lattice
    %   we are interested in.

    arguments
        in_center_points (:,3) double
        in_lattice_res_x (1,1) double
        in_lattice_res_y (1,1) double
        in_lattice_res_z (1,1) double
    end

    % Aliases for shorter expressions.

    cp1 = in_center_points(:,1);
    cp2 = in_center_points(:,2);
    cp3 = in_center_points(:,3);

    lrx = in_lattice_res_x;
    lry = in_lattice_res_y;
    lrz = in_lattice_res_z;

    % Absolute coordinates (relative coordinates times resolution) in the
    % rectangular lattice.

    acx = max(1, round( lrx * (cp1 - min(cp1)) ./ (max(cp1) - min(cp1))));
    acy = max(1, round( lry * (cp2 - min(cp2)) ./ (max(cp2) - min(cp2))));
    acz = max(1, round( lrz * (cp3 - min(cp3)) ./ (max(cp3) - min(cp3))));

    % Linear indices from absolute coordinates.

    out_indices = (acz-1) * lrx * lry + (acx-1) * lry + acy;

end
