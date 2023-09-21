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
        settings (1,1) core.MeshSettings = core.MeshSettings
    end

    compartment_count = segmentation.compartment_count ;

    labels = zeros ( self.tetra_count, 1 ) ;

    tetra_vertex_coords = self.vertex_coordinates ;

    % Compute the solid angle integrals for each FEM node in the vicinity of each compartment.

    for ii = 1 : compartment_count

        % Get surface nodes and triangles corresponding to this compartment.

        triI = find ( segmentation.labels == ii ) ;

        surf_triangles = segmentation.triangles ( triI, : ) ;

        surf_nodes = segmentation.nodes ( surf_triangles, : ) ;

        % Before computing the integral, form an Axis-Aligned Bounding Box, to
        % reduce the number of FEM nodes needed in the computation.

        [ nodeI, tetraI, ~ ] = AABBFn ( surf_nodes, self, tetra_vertex_coords ) ;

        nodes_in_aabb = self.nodes ( nodeI, : ) ;

        tetra_in_aabb = self.tetra ( tetraI, : ) ;

        n_of_nodes_in_aabb = size ( nodes_in_aabb, 1 ) ;

        node_inds_in_compartment = zeros ( n_of_nodes_in_aabb, 1 ) ;

        % Compute surface normals for the triangles in this compartment.

        normal_positions = segmentation.triangle_barycenters ( triI ) ;

        [ triangle_areas, surface_normals, ~, ~ ] = segmentation.triangle_areas ( triI ) ;

        % Compute solid angle integral for each FEM node in this compartment.
        % If a node is in compartment ii, add its global index to the set of
        % in-compartment node indices.

        for jj = 1 : n_of_nodes_in_aabb

            femnode = nodes_in_aabb ( jj, : ) ;

            diffs = normal_positions - femnode ;

            dotprods = dot ( diffs, surface_normals, 2 ) ;

            solid_angle_integral = ( 1 / 4 / pi ) * sum ( dotprods .* triangle_areas ) ;

            if solid_angle_integral >= settings.meshing_threshold

                node_inds_in_compartment ( jj ) = nodeI ( jj ) ;

            end % if

        end % for

        % If all nodes of a tetrahedron are in the compartment, the tetrahedron
        % itself gets labeled into this compartment.

        tetra_in_compartment_I = all ( ismember ( tetra_in_aabb, node_inds_in_compartment ) , 2 ) ;

        % Get global indices of the tetrahedron, and label those as being in
        % the current compartment.

        global_tetra_I = tetraI ( tetra_in_compartment_I ) ;

        labels ( global_tetra_I ) = ii ;

    end % for

    self.labels = labels ;

end % function

%% Local helper functions

function [ nodeI, tetraI, aabb ] = AABBFn ( snodes, mesh, tetra_vertex_coords )
%
% [ nodeI, tetraI, aabb ] = AABBFn ( snodes, mesh, tetra_vertex_coords )
%
% Computes an axis-aligned bounding box around a node cloud, and finds out
% which nodes and tetra in the FEM mesh are contained inside of this box.
%

    arguments
        snodes (:,3) double { mustBeFinite }
        mesh (1,1) core.TetraMesh
        tetra_vertex_coords (:,3) double { mustBeFinite }
    end

    minbs = min ( snodes ) ;

    maxbs = max ( snodes ) ;

    aabb = transpose ( [ minbs ; maxbs ] ) ;

    femx = mesh.nodes ( :, 1 ) ;
    femy = mesh.nodes ( :, 2 ) ;
    femz = mesh.nodes ( :, 3 ) ;

    nodeI = find ( ...
          femx >= aabb (1,1) ...
        & femx <= aabb (1,2) ...
        & femy >= aabb (2,1) ...
        & femy <= aabb (2,2) ...
        & femz >= aabb (3,1) ...
        & femz <= aabb (3,2) ...
    ) ;

    tvc = tetra_vertex_coords ; % Abbreviation.

    vertexI = ...
          tvc (:,1) >= aabb (1,1) ...
        & tvc (:,1) <= aabb (1,2) ...
        & tvc (:,2) >= aabb (2,1) ...
        & tvc (:,2) <= aabb (2,2) ...
        & tvc (:,3) >= aabb (3,1) ...
        & tvc (:,3) <= aabb (3,2) ...
    ;

    % Look for 4 consequtive ones in vertexI set. They indicate, that a
    % tetrahedron is covered by the tissue boundary.

    tetraI = zeros ( mesh.tetra_count, 1 ) ;

    for ii = 1 : mesh.tetra_count

        jj = (ii - 1) * 4 + 1 ;

        vrange = jj : jj + 3 ;

        if all ( vertexI ( vrange ) ~= 0 )

            tetraI ( ii ) = ii ;

        end

    end

    tetraI = tetraI ( tetraI ~= 0 ) ;

end
