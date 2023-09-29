function self = solid_angle_labeling ( self, segmentation, settings )
%
% self = solid_angle_labeling ( self, segmentation, settings )
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

    [ global_triangle_areas, global_surface_normals, global_normal_norms, ~ ] = segmentation.triangle_areas ;

    global_normal_positions = segmentation.triangle_barycenters ;

    % Compute the solid angle integrals for each FEM node in the vicinity of each compartment.

    for ii = 1 : compartment_count

        % Get surface nodes and triangles corresponding to this compartment.

        triI = find ( segmentation.labels == ii ) ;

        surf_triangles = segmentation.triangles ( :, triI ) ;

        surf_nodes = segmentation.nodes ( :, surf_triangles ) ;

        % Before computing the integral, form an Axis-Aligned Bounding Box, to
        % reduce the number of FEM nodes needed in the computation.

        [ nodeI, tetraI, ~ ] = AABBFn ( surf_nodes, self, tetra_vertex_coords ) ;

        nodes_in_aabb = self.nodes ( :, nodeI ) ;

        tetra_in_aabb = self.tetra ( :, tetraI ) ;

        n_of_nodes_in_aabb = size ( nodes_in_aabb, 2 ) ;

        % Fetch triangle information related to this bounding box.

        normal_positions = global_normal_positions ( :, triI ) ;

        triangle_areas = global_triangle_areas ( triI ) ;

        surface_normals = global_surface_normals ( :, triI ) ./ global_normal_norms ( triI ) ;

        n_of_surface_normals = size ( surface_normals, 2 ) ;

        % Compute solid angle integral for each FEM node in the axis-aligned
        % bounding box. If a node is in compartment ii, add its global index to
        % the set of in-compartment node indices.

        repeated_femnodes = repelem ( nodes_in_aabb, 1, n_of_surface_normals ) ;

        repeated_normals = repmat ( normal_positions, 1 , n_of_nodes_in_aabb ) ;

        repeated_normal_positions = repmat ( normal_positions, 1, n_of_nodes_in_aabb ) ;

        repeated_triangle_areas = repmat ( triangle_areas, 1, n_of_nodes_in_aabb ) ;

        diffs = repeated_normal_positions - repeated_femnodes ;

        normed_diffs = diffs ./ sqrt ( sum ( diffs .^ 2 ) ) .^ 3 ;

        dotprods = dot ( normed_diffs, repeated_normals, 1 ) ;

        integrands = dotprods .* repeated_triangle_areas ;

        % Reshape to allow vectorized integration along matrix columns.

        integrands = reshape ( integrands, n_of_surface_normals, n_of_nodes_in_aabb ) ;

        solid_angle_integrals = (1 / 4 / pi) * sum ( integrands ) ;

        intI = solid_angle_integrals >= settings.meshing_threshold ;

        global_intI = nodeI ( intI ) ;

        % If all nodes of a tetrahedron are in the compartment, the tetrahedron
        % itself gets labeled into this compartment.

        tetra_in_compartment_I = all ( ismember ( tetra_in_aabb, global_intI ) , 1 ) ;

        % Get global indices of the tetrahedra, and label those as being in
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
        snodes (3,:) double { mustBeFinite }
        mesh (1,1) core.TetraMesh
        tetra_vertex_coords (3,:) double { mustBeFinite }
    end

    minbs = min ( snodes, [], 2 ) ;

    maxbs = max ( snodes, [], 2 ) ;

    aabb = [ minbs , maxbs ] ;

    femx = mesh.nodes ( 1 , : ) ;
    femy = mesh.nodes ( 2 , : ) ;
    femz = mesh.nodes ( 3 , : ) ;

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
          tvc (1,:) >= aabb (1,1) ...
        & tvc (1,:) <= aabb (1,2) ...
        & tvc (2,:) >= aabb (2,1) ...
        & tvc (2,:) <= aabb (2,2) ...
        & tvc (3,:) >= aabb (3,1) ...
        & tvc (3,:) <= aabb (3,2) ...
    ;

    % Look for 4 consequtive ones in vertexI set. They indicate, that a
    % tetrahedron is covered by the tissue boundary.

    vertexI = reshape ( vertexI, 4, mesh.tetra_count ) ;

    tetraI = all ( sum ( vertexI ) == 4, 1 ) ;

    tetraI = tetraI ( tetraI ~= 0 ) ;

end % function
