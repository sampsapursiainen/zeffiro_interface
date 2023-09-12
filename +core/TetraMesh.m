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
    end % properties

    methods

        function self = TetraMesh ( kwargs )
        %
        % TetraMesh (
        %   kwargs.nodes,
        %   kwargs.tetra
        % )
        %
        % A constructor for this class.
        %

            arguments

                kwargs.nodes = []

                kwargs.tetra = []

            end

            field_names = string ( fieldnames ( kwargs ) ) ;

            for ii = 1 : numel ( field_names )

                self.( field_names ( ii ) ) = kwargs.( field_names ( ii ) ) ;

            end % for

            % Check that there are at least 4 nodes in the mesh.

            n_of_nodes = size ( self.nodes, 2 ) ;

            if not ( isempty ( self.nodes ) ) && n_of_nodes < 4

                error ( "A tetrahedral mesh needs to contain at least 4 nodes." ) ;

            end

            % Check that the tetrahedra do not reference nodes outside of the mesh.

            maxind = max ( self.tetra ( : ) ) ;

            if n_of_nodes > maxind

                error ( "The tetrahedra in the mesh are referencing a maximum node index of " + maxind + ", but the number of nodes is" + n_of_nodes + ".")

            end

            % Check that tetrahedra consist of 4 separate nodes.

            n_of_tetra = size ( self.tetra, 2 ) ;

            for ii = 1 : n_of_tetra

                tetra = self.tetra ( ii : ii + 3 )

                unique_inds = unique ( tetra )

                if numel ( unique_inds ) ~= 4

                    error ( "The tetrahedron " + ii + " does not contain 4 separate node indices." ) ;

                end

            end

            % Check that all nodes in the mesh are referenced by at least one tetrahedron.

            node_inds = 1 : n_of_nodes ;

            all_are_found = all ( ismember ( node_inds, self.tetra ( : ) ) ) ;

            if not ( all_are_found )

                error ( "There are node indices that are not referenced by the given tetrahedra." )

            end

        end % function

    end % methods

end % classdef
