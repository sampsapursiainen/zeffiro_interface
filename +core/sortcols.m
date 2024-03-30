function [sortedArray, sortedP] = sortcols (array,rowI)
%
% [sortedArray, sortedP] = sortcols (array,rowI)
%
% Performs a stable ordering of the columns of a given array in the row order
% specified by rowI.
%
% Inputs:
%
% - array
%
%   The array that is to be sorted.
%
% - rowI
%
%   The row indices according to which the array will be sorted.
%
% Outputs:
%
% - sortedArray
%
%   The sorted array.
%
% - sortedP
%
%   A permutation, which allows the input array (or some other array with the
%   same number of columns) to be sorted again without running this funtion.
%

    arguments
        array (:,:) double { mustBeFinite }
        rowI  (:,1) uint32 { mustBePositive } = 1 : size (array,1)
    end

    % Size of the array and how many times it will be sorted.

    [~, Nc] = size (array) ;

    Ns = numel (rowI) ;

    % Preallocate outputs.

    sortedArray = array ;

    % Perform sort based on rowI, assuming initially that there is just one category.

    categories = ones (1,Nc) ;

    P = 1 : Nc ;

    sortedP = P ;

    for ii = 1 : Ns

        % Go over unique categories and accumulate permutation for rearranging
        % columns of whole array at once.

        minc = min (categories) ;

        maxc = max (categories) ;

        rI = rowI (ii) ;

        row = sortedArray (rI,:) ;

        for category = minc : maxc

            % Extract column values.

            catI = find (categories == category) ;

            catcols = row (catI) ;

            % Sort the part of the row with current category.

            [~,catP] = sort (catcols) ;

            % Save the permutation to global permutations.

            P (catI) = catI (catP) ;

        end % for

        % Rearrange whole array according to permutation P.

        sortedArray = sortedArray (:,P) ;

        sortedP = sortedP (P) ;

        sortedrow = sortedArray (rI,:) ;

        % Assign new categories to sorted row elements for next round.

        prevElem = sortedrow (1) ;

        category = 1 ;

        for jj = 1 : Nc

            currElem = sortedrow (jj) ;

            if currElem ~= prevElem
                category = category + 1 ;
            end

            categories (jj) = category ;

            prevElem = currElem ;

        end % for

    end % for

end % function
