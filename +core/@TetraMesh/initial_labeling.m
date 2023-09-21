function self = initial_labeling ( self, segmentation, settings )
%
% self = initial_labeling ( self, segmentation, settings )
%
% Performs labeling of tetrahedra into their respective compartments, specified
% by the given surface segmentation, after a mesh that has not yet been
% deformed by refinement, inflation and/or smoothing, has been constructed
%
% Uses the solid angle method given in https://doi.org/10.48550/arXiv.2203.10000.
%

    arguments
        self (1,1) core.TetraMesh
        segmentation (1,1) core.SurfaceSegmentation
        settings (1,1) core.MeshSettings
    end

    compartment_count = segmentation.compartment_count ;

    labels = zeros ( self.tetra_count, 1 ) ;

    % Compute the solid angle integral for each compartment.

    for ii = 1 : compartment_count

        % Get surface nodes and triangles corresponding to this compartment.

        triI = find ( segmentation.labels == ii ) ;

        surf_triangles = segmentation.triangles ( triI, : ) ;

        surf_nodes = segmentation.nodes ( surf_triangles, : ) ;

        % Before computing the integral, form an Axis-Aligned Bounding Box, to
        % reduce the number of FEM nodes needed in the computation.

        [ inds, ~, ~, ~, ~, ~, ~ ] = AABBIndFn ( surf_nodes, self.nodes ) ;

        nodes_in_comp = self.nodes ( inds, : ) ;

        n_of_nodes_in_comp = size ( nodes_in_comp, 1 ) ;

        % Compute surface normals for the triangles in this compartment.

        surface_normals = segmentation.surface_normals ( triI ) ;

        normal_positions = segmentation.triangle_barycenters ( triI ) ;

        n_of_normal_positions = size ( normal_positions, 1 ) ;

        triangle_areas = segmentation.triangle_areas ( triI ) ;

        % Compute solid angle integral for each FEM node.

        for jj = 1 : n_of_nodes_in_comp

            femnode = nodes_in_comp ( jj, : ) ;

            replicated_femnode = repmat ( femnode, n_of_normal_positions, 1 ) ; % TODO: get rid of this repeated allocation via preallocation.

            diffs = normal_positions - replicated_femnode ;

            dotprods = dot ( diffs, surface_normals, 2 ) ;

            solid_angle_integral = sum ( dotprods .* triangle_areas ) ;

        end % for

    end % for

    self.labels = labels ;

end % function

%% Local helper functions

function [ inds, xmin, xmax, ymin, ymax, zmin, zmax ] = AABBIndFn ( snodes, femnodes )
%
% [ inds, xmin, xmax, ymin, ymax, zmin, zmax ] = AABBIndFn ( snodes, femnodes )
%
% Computes an axis-aligned bounding box around a node cloud, and finds out
% which nodes in the FEM mesh are contained inside of this box.
%

    arguments
        snodes (:,3) double { mustBeFinite }
        femnodes (:,3) double { mustBeFinite }
    end

    minbs = min ( snodes ) ;

    maxbs = max ( snodes ) ;

    xmin = minbs (1) ;
    ymin = minbs (2) ;
    zmin = minbs (3) ;

    xmax = maxbs (1) ;
    ymax = maxbs (2) ;
    zmax = maxbs (3) ;

    femx = femnodes ( :, 1 ) ;
    femy = femnodes ( :, 2 ) ;
    femz = femnodes ( :, 3 ) ;

    inds = find ( ...
          femx >= xmin ...
        & femx <= xmax ...
        & femy >= ymin ...
        & femy <= ymax ...
        & femz >= zmin ...
        & femz <= zmax ...
    ) ;

end
