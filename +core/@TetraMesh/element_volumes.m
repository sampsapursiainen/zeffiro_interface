function volumes = element_volumes ( self, inds )
%
% volumes = element_volumes ( self, inds )
%
% Computes the signed volumes of the elements in this finite element mesh.
%

    arguments

        self (1,1) core.TetraMesh

        inds (:,1) uint64 { mustBePositive } = 1 : self.element_count

    end

    volumes = core.TetraMesh.static_element_volumes ( self.nodes, self.tetra ( :, inds ) ) ;

end % function
