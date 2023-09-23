function count = element_count ( self )
%
% count = element_count ( self )
%
% Computes the number of elements in this finite element mesh.
%

    arguments
        self (1,1) core.TetraMesh
    end

    count = size ( self.tetra, 1 ) ;

end % function
