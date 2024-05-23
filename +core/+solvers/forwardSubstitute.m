function x = forwardSubstitute (L,b)
%
% x = forwardSubstitute (L,b)
%
% Solves a lower-triangular system of equations Lx = b via forward
% substitution.
%

    arguments
        L (:,:) { mustBeFinite }
        b (:,1) { mustBeFinite }
    end

    [Nrows,Ncols] = size (L) ;

    assert (Nrows == Ncols, "The first argument needs to be a square matrix.")

    assert ( istril (L), "The first argument L needs to be an lower-triangular matrix.")

    assert ( numel (b) == Nrows, "The size of the first argument L needs to match that of the second argument b." )

    x = zeros (Nrows,1) ;

    for row = 1 : Nrows

        if row == 1
            x (row) = b (row)
        else
            x (row) = b (row) - sum ( L (row,1:row-1) .* x (1:row-1) ) ;
        end

    end % for row

end % function
