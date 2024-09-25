function outA = parcellateArray ( A, aggregationI, aggregationN, axis )
%
% outA = parcellateArray ( A, aggregationI, aggregationN, axis )
%
% This function reduces the size of a given array A by summing the
% contributions from all rows or columns or age or ... of A into a subset of
% the same axis, representing a set of active elements, determined by aggregationI.
% The results are then normalized based on how many sources were placed into
% each of those active elements.
%
% Inputs:
%
% - A
%
%   The array computed for all possible source positions.
%
% - aggregationI
%
%   An index mapping rowI ↦ eleI, where rowI is a row or columns index of A
%   (see kwargs.axis) and eleI is the index of the active element that the
%   contribution from that row should map to.
%
% - aggregationN
%
%   The number of times each cluster center appears in aggregationI. Used in
%   normalizing the aggregated result.
%
% - axis
%
%   The axis along which the parcellation will be performed.
%

    arguments
        A double { mustBeFinite }
        aggregationI (:,1) double { mustBeInteger, mustBePositive }
        aggregationN (:,1) double { mustBeInteger, mustBePositive }
        axis (1,1) double { mustBeInteger, mustBePositive }
    end

    % Determine a few sizes.

    sizeA = size (A) ;

    dimN = numel (sizeA) ;

    [ uEleI, ~, uOutI ] = unique (aggregationI) ;

    uEleN = numel (uEleI) ;

    % Construct size of aggregated output array and the initialize output array.

    outSize = zeros (1, dimN) ;

    for ii = 1 : dimN

        if ii == axis

            outSize (ii) = uEleN ;

        else

            outSize (ii) = sizeA (ii) ;

        end % if

    end % for ii

    outA = zeros (outSize) ;

    % Construct cell arrays for reading from A and writing to outA.

    readICells = cell (1,dimN) ;

    writeICells = cell (1,dimN) ;

    for ii = 1 : dimN

        if ii == axis

            readICells {ii} = [] ;

        else

            readICells {ii} = 1 : sizeA (ii) ;

        end

        writeICells {ii} = readICells {ii} ;

    end % for ii

    % Go over the element indices and aggregate values from input A into output
    % A. Also normalize the result with respect to the number of "sources" per
    % the target element.

    disp ("Aggregating results into smaller array…") ;

    axisN = sizeA (axis) ;

    for ii = 1 : axisN

        zefCore.dispProgress (ii, axisN) ;

        readICells {axis} = ii ;

        writeICells {axis} = uOutI (ii) ;

        outA (writeICells {:}) = outA (writeICells {:}) + A (readICells {:}) ;

    end % for ii

    outAxisN = outSize (axis) ;

    disp ( newline + "Normalizing aggregated results by aggregation counts…")

    for ii = 1 : outAxisN

        zefCore.dispProgress (ii, outAxisN) ;

        outA (ii) = outA (ii) / aggregationN (ii) ;

    end % for ii

end % function
