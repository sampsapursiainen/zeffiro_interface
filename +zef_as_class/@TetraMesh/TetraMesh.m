classdef TetraMesh < zef_as_class.FEMesh

    %
    % TetraMesh < FEMesh
    %
    % Describes a finite element mesh, whose elements are tetrahedral.
    %

    properties

        nodes = []

        elements = []

    end

    properties (Constant)

        element_size = 4;

    end

    methods

        function self = TetraMesh(nodes, tetra)

            %
            % TetraMesh
            %
            % The constructor of this class.
            %
            % Input
            %
            % - nodes
            %
            %   Nodes with 3D Cartesian coordinates.
            %
            % - tetra
            %
            %   An M × 4 array of node indices.
            %
            % Output
            %
            % - self
            %
            %   An instance of this class.
            %

            self.nodes = nodes;

            self.elements = tetra;

        end

        function self = set.elements(self, tetra)

            %
            % set.elements(self, tetra)
            %
            % A setter method to enforce that the elements of this class are
            % indeed tetrahedral, that is their rows contain exactly 4 node
            % indices, and that each node is referenced by the tetra at least
            % once.
            %

            % Make sure elements are tetrahedral.

            element_size = size(tetra, 2);

            if element_size ~= 4

                error("Tetrahedra have " + zef_as_class.TetraMesh.element_size + " node indices. Got " + element_size + " instead.")

            end

            % Check that there are no extra nodes referenced.

            node_range = 1 : size(self.nodes, 1);

            extra_nodes_in_shapes = not(all(ismember(tetra, node_range)));

            if extra_nodes_in_shapes

                error("The given tetra contain references to non-existent nodes. Will not set the value of self.tetra.")

            end

            % Check that all nodes are referenced at least once.

            all_nodes_not_referenced = any(not(ismember(node_range, tetra)));

            if all_nodes_not_referenced

                error("Some nodes are not referenced by the given tetra. Not setting the value of self.tetra.")

            end

            self.elements = tetra;

        end % function

    end

end % classdef
