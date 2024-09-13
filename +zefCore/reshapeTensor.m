function tensor = reshapeTensor (tensor)
%
% tensor = reshapeTensor (tensor)
%
% Reshapes a given tensor into a 6×Ntetra matrix, if given as a vector
% representing constant isotropic values. Otherwise only checks that the tensor
% if of correct shape.
%

    arguments
        tensor (:,:) double { mustBeFinite }
    end

    if isvector (tensor)

        if ~ isrow (tensor)

            tensor = transpose (tensor) ;

        end

        Nten = numel (tensor) ;

        tensor = cat ( 1, repmat (tensor,3,1), zeros (3,Nten) ) ;

    elseif ismatrix (tensor)

        Ntenr = size (tensor,1) ;

        assert ( Ntenr == 6, "If given as a matrix, the input tensor needs to contain 6 rows, equal to the number of node combinations in a tetrahedron.")

    else

        error ("The input tensor needs to be a row vector or a matrix.") ;

    end % if

end % function
