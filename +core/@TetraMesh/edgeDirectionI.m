function I = edgeDirectionI ( self )
%
% I = edgeDirectionI ( self )
%
% Returns a 2-by-M matrix of indices, giving the directions of the edges in an
% element of this mesh.
%

    arguments
        self (1,1) core.TetraMesh
    end

    I = [ 1, 2, 1, 3, 1, 4, 2, 3, 2, 4, 3, 4 ] ;

    I = reshape ( I , 2 , 6 ) ;

end % function
