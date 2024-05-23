function x = backwardSubstitute (U,b)
%
% x = backwardSubstitute (U,b)
%
% Solves and upper-triangular system of equations Ux = b via backward
% substitution.
%

    arguments
        U (:,:) { mustBeFinite }
        b (:,1) { mustBeFinite }
    end

    [Nrows,Ncols] = size (U) ;

    assert (Nrows == Ncols, "The first argument needs to be a square matrix.")

    assert ( istriu (U), "The first argument U needs to be an upper-triangular matrix.")

    assert ( numel (b) == Nrows, "The size of the first argument U needs to match that of the second argument b." )

    x = zeros (Nrows,1)

    for row = Nrows : -1 : 1

        if row == Nrows

            x (row) = b (row) ;

        else

            x (row) = b (row) - sum ( U (row,row+1:end) .* x (row+1:end) ) ;

        end % if

    end % for row

end % function
