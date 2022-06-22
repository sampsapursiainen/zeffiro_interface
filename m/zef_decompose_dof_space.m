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
% - nodes: the nodes that make up a finite element mesh.
%
% - tetrahedra: quadruples of node indices that indicate which nodes
%   participate in which tetrahedra.
%
% - brain_ind: linear indices of tetrahedra that are in the brain.
%
% - varargin{1}: source indices. If not set, these are assumed to be the
%   same as brain_ind.
%
% - varargin{2}: number of sources. If not set, these are fetched from the
%   global zef instance with evalin.
%
% - varargin{3}: DOF decomposition type. TODO. If not set, this is again
%   fetched from the global zef instance with evalin.
%
% Output:
%
% - decomposition_ind: TODO
% - decomposition_count: TODO
% - dof_positions: TODO
% - decomposition_ind_first: TODO. Has something to do with generating source
%   indices before lead field construction.

function [ ...
    decomposition_ind, ...
    decomposition_count, ...
    dof_positions, ...
    decomposition_ind_first ...
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

        size_center_points = size(center_points,2);
        size_source_points = size(center_points,2);

        MdlKDT = KDTreeSearcher(dof_positions);
        decomposition_ind  = knnsearch(MdlKDT,center_points);

        [unique_decomposition_ind, i_a, i_c] = unique(decomposition_ind);
        decomposition_count = accumarray(i_c,1);
        decomposition_pointe = i_a;

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

        decomposition_ind = lattice_index_fn( ...
            center_points, ...
            lattice_res_x, ...
            lattice_res_y, ...
            lattice_res_z ...
        );

        [unique_decomposition_ind, i_a, i_c] = unique(decomposition_ind);

        decomposition_ind_to_be = zeros(size(dof_positions,1),1);

        decomposition_ind_to_be(unique_decomposition_ind) = [1 : length(unique_decomposition_ind)];

        decomposition_ind = decomposition_ind_to_be(decomposition_ind);

        dof_positions = dof_positions(unique_decomposition_ind,:);

        decomposition_count = accumarray(i_c,1);

        decomposition_ind_first = i_a;

    elseif dof_decomposition_type == 3

         decomposition_ind = [1:length(brain_ind)]';
         decomposition_count = ones(size(decomposition_ind));
         dof_positions = center_points;
         decomposition_ind_first = [1:length(brain_ind)]';

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
    % - out_indices: the indices of the lattice we are interested in.

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

    % Lattice index builder.

    lib = [
        max(1, round( lrx * (cp1 - min(cp1)) ./ (max(cp1) - min(cp1)))) ...
        max(1, round( lry * (cp2 - min(cp2)) ./ (max(cp2) - min(cp2)))) ...
        max(1, round( lrz * (cp3 - min(cp3)) ./ (max(cp3) - min(cp3))))
    ];

    % Indices from builder.

    out_indices = (lib(:,3)-1) * lrx * lry + (lib(:,1)-1) * lry + lib(:,2);

end
