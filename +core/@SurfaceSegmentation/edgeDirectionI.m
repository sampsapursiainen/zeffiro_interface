function I = edgeDirectionI ( self )
%
% I = edgeDirectionI ( self )
%
% Returns a 2-by-N matrix of indices, where N is the number of edges, giving
% the directions of the edges in an element of this mesh.
%

    arguments
        self (1,1) core.SurfaceSegmentation
    end

    I = [ 1, 2, 2, 3, 3, 1 ] ;

    I = reshape ( I , 2 , 3 ) ;

end % function
