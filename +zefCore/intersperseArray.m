function outA = intersperseArray (A, dim, groupsOf)
%
% outA = intersperseArray (A, dim, groupsOf)
%
% Intersperses the given array A along the given dimension in groups of groupsOf.
%
% Inputs:
%
% - A
%
%   The array that is to be interspersed.
%
% - dim
%
%   The dimension the interspersion is to take place over.
%
% - groupsOf
%
%   How many elements a single interspersed groups should contain.
%

    arguments
        A
        dim
        groupsOf
    end

    % Check that the given dimension of A is divisible by the give group size.

    sizeA = size (A) ;

    dimN = length (sizeA) ;

    dimASize = sizeA (dim) ;

    dimDiv = dimASize / groupsOf ;

    dimRem = mod ( dimASize, groupsOf) ;

    assert ( dimRem == 0, "The given dimension " + dim + " of first argument with size [ " + strjoin ( string (sizeA), ", " ) + " ] was not divisible by the group amount " + groupsOf ) ;

    % Generate cell arrays for indexing into A during interpersion with a comma-separated list of indices.

    writeICells = cell (1, dimN) ;

    readICells = cell (1, dimN) ;

    for ii = 1 : dimN

        if ii == dim

            readICells {ii} = [] ;

        else

            readICells {ii} = 1 : sizeA (ii) ;

        end

        writeICells {ii} = readICells {ii} ;

    end % for ii

    % Start interspersion with MATLAB's black magic comma-separated lists.

    outA = A ;

    for ii = 1 : groupsOf

        readI = (ii-1) * dimDiv + 1 : ii * dimDiv ;

        writeI = ii : groupsOf : dimASize ;

        readICells {dim} = readI ;

        writeICells {dim} = writeI ;

        outA ( writeICells {:}) = A (readICells {:}) ;

    end % for ii

end % function
