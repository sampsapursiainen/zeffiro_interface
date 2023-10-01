function [ sorted_array , permutation ] = sortcolumns ( array, rowI )
%
% [ sorted_array , permutation ] = sortcolumns ( array, rowI )
%
% Sorts a given array according to the set of rows provided, just like
% MathWorks' own sortrows does for rows.
%
% Inputs:
%
% - array
%
%   The array that is to be sorted columnwise.
%
% - rowI
%
%   The row numbers, according to which the array will be sorted.
%
% Outputs:
%
% - sorted_array
%
%   The sorted array.
%
% - permutation
%
%   The accumulated permutation needed to perform the sorting in a single step.
%   This is useful in, for example, sorting another array with the same number
%   of columns in a similar manner, as the input array was sorted.
%

    arguments
        array (:,:)
        rowI  (1,:) uint32 { mustBePositive }
    end

    permutation = 1 : size ( array, 2 ) ;

    sorted_array = array ;

    for ii = 1 : numel ( rowI )

        rowi = rowI ( ii ) ;

        [ ~ , sortI ] = sort ( sorted_array ( rowi, : ), 2 ) ;

        permutation = permutation ( sortI ) ;

        sorted_array = sorted_array ( : , sortI ) ;

    end

end % function
