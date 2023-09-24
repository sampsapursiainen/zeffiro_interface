classdef TetraMesh
%
% TetraMesh -- A tetrahedral finite element mesh.
%

    properties
        %
        % nodes
        %
        % Triples of coordinates making up the the 3D nodes of a finite element mesh.
        %
        nodes (3,:) double { mustBeNonNan, mustBeFinite } = []
        %
        % tetra
        %
        % Quadruples of node indices of a finite element mesh, defining which nodes belong to which
        % element.
        %
        tetra (4,:) uint64 { mustBePositive } = []
        %
        % The labels that indicate which compartment each tetrahedron belongs into.
        %
        labels (:,1) uint64 = []
        %
    end % properties

    methods

        function self = TetraMesh ( kwargs )
        %
        % TetraMesh (
        %   kwargs.nodes,
        %   kwargs.tetra,
        %   kwargs.labels
        % )
        %
        % A constructor for this class.
        %

            arguments

                kwargs.nodes = []

                kwargs.tetra = []

                kwargs.labels = []

            end

            field_names = string ( fieldnames ( kwargs ) ) ;

            for ii = 1 : numel ( field_names )

                self.( field_names ( ii ) ) = kwargs.( field_names ( ii ) ) ;

            end % for

            % self = self.validate () ;

        end % function

    end % methods

    methods ( Static )

       volumes = static_element_volumes ( nodes, tetra )

    end % methods ( Static )

end % classdef
