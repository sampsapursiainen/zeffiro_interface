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

            if nargin < 2; return; end

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

            % Element validity check.

            zef_as_class.FEMesh.elements_are_valid(self, tetra);

            % Set elements.

            self.elements = tetra;

        end % function

    end

end % classdef
