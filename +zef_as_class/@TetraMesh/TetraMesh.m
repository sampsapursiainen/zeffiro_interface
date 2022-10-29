classdef TetraMesh < zef_as_class.FEMesh

    %
    % TetraMesh
    %
    % Descibes a finite element mesh, whose elements are tetrahedral.

    properties

        nodes = []

        elements = []

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

    end

end % classdef
