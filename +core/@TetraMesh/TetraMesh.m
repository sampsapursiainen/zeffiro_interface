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

            self = self.validate () ;

        end % function

        function [ coords ] = vertex_coordinates ( self, inds )
        %
        % vertex_coordinates ( self, inds )
        %
        % Returns the vertex coordinates of the tetrahedra indicated by the given indices.
        %
        % Inputs:
        %
        % - self
        %
        %   A tetrahedral mesh.
        %
        % - inds
        %
        %   The indices of the tetrahedra whose vertex coordinates one wishes to obtain.
        %
        % Output:
        %
        % - coords
        %
        %   A 3-by-(4 numel inds) matrix of node coordinates. In other words, the columns of the
        %   output value contain the node coordinates of the indicated tetrahedra in groups of 4.
        %

            arguments

                self (1,1) core.TetraMesh

                inds (:,1) uint64 { mustBePositive }

            end

            n_of_tetra = size ( self.tetra, 2 ) ;

            if any ( n_of_tetra < inds )

                error ( "The given index set contains tetrahedral indices that are too large. The mesh only contains " + n_of_tetra + " tetrahedra."  ) ;

            end

            coords = self.nodes ( :, self.tetra ( :, inds ) ) ;

        end % function

    end % methods

end % classdef
