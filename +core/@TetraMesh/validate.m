function self = validate ( self )
%
% validate ( self )
%
% Checks that the mesh is valid.
%

    arguments

        self (1,1) core.TetraMesh

    end

    % Check that there are at least 4 nodes in the mesh.

    n_of_nodes = size ( self.nodes, 2 ) ;

    if not ( isempty ( self.nodes ) ) && n_of_nodes < 4

        error ( "A tetrahedral mesh needs to contain at least 4 nodes." ) ;

    end

    % Check that tetrahedra consist of 4 separate nodes.

    n_of_tetra = size ( self.tetra, 2 ) ;

    node_inds = 1 : n_of_nodes ;

    for ii = 1 : n_of_tetra

        ti = 4 * (ii - 1) + 1 ;

        hedron = self.tetra ( ti : ti + 3 ) ;

        unique_inds = unique ( hedron ) ;

        if numel ( unique_inds ) ~= 4

            error ( "The tetrahedron with index " + ii + " does not contain 4 separate node indices." ) ;

        end

        maxind = max ( hedron ) ;

        n_of_nodes ;

        if n_of_nodes < maxind

            error ( "Tetrahedron with index " + ii + " is referencing a node index of " + maxind + ", when the number of nodes in the mesh is only " + n_of_nodes + "." ) ;

        end

        if not ( all ( ismember ( hedron, node_inds ) ) )

            error ( "Tetrahedron with index " + ii + " is referencing a node that does not exist." ) ;

        end

    end % for

    % Check that all nodes in the mesh are referenced by at least one tetrahedron.

    node_inds = 1 : n_of_nodes ;

    all_are_found = all ( ismember ( node_inds, self.tetra ( : ) ) ) ;

    if not ( all_are_found )

        error ( "There are node indices that are not referenced by the given tetrahedra." )

    end

end % function