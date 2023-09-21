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

        [ nodeI, tetraI, aabb ] = AABBFn ( surf_nodes, self, tetra_vertex_coords ) ;

        nodes_in_comp = self.nodes ( nodeI, : ) ;

        n_of_nodes_in_comp = size ( nodes_in_comp, 1 ) ;

        node_in_compartment = false ( n_of_nodes_in_comp, 1 ) ;

        % Compute surface normals for the triangles in this compartment.

        surface_normals = segmentation.surface_normals ( triI ) ;

        normal_positions = segmentation.triangle_barycenters ( triI ) ;

        n_of_normal_positions = size ( normal_positions, 1 ) ;

        triangle_areas = segmentation.triangle_areas ( triI ) ;

        % Compute solid angle integral for each FEM node in this compartment.

        for jj = 1 : n_of_nodes_in_comp

            femnode = nodes_in_comp ( jj, : ) ;

            diffs = normal_positions - femnode ;

            dotprods = dot ( diffs, surface_normals, 2 ) ;

            solid_angle_integral = ( 1 / 4 / pi ) * sum ( dotprods .* triangle_areas ) ;

            if solid_angle_integral >= settings.meshing_threshold

                node_in_compartment ( jj ) = true ;

            end

        end % for

        % Then check the tetrahedra inside of the AABB. If so, the tetrahedron
        % gets labeled into this compartment.

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

    tetraI = find ( ...
          tvc (:,1) >= aabb (1,1) ...
        & tvc (:,1) <= aabb (1,2) ...
        & tvc (:,2) >= aabb (2,1) ...
        & tvc (:,2) <= aabb (2,2) ...
        & tvc (:,3) >= aabb (3,1) ...
        & tvc (:,3) <= aabb (3,2) ...
    ) ;

end
