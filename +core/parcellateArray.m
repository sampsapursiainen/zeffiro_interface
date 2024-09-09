function outA = parcellateArray ( A, elementI, axis )
%
% outA = parcellateArray ( A, elementI, axis )
%
% This function reduces the size of a given array A by summing the
% contributions from all rows or columns or age or ... of A into a subset of
% the same axis, representing a set of active elements, determined by elementI.
% The results are then normalized based on how many sources were placed into
% each of those active elements.
%
% Inputs:
%
% - A
%
%   The array computed for all possible source positions.
%
% - elementI
%
%   An index mapping rowI ↦ eleI, where rowI is a row or columns index of A
%   (see kwargs.axis) and eleI is the index of the active element that the
%   contribution from that row should map to.
%
% - axis
%
%   The axis along which the parcellation will be performed.
%

    arguments
        A double { mustBeFinite }
        elementI (:,1) double { mustBeInteger, mustBePositive }
        axis (1,1) double { mustBeInteger, mustBePositive }
    end

    % Determine a few sizes.

    sizeA = size (A) ;

    dimN = numel (sizeA) ;

    [ uEleI, ~, uOutI ] = unique (elementI) ;

    uEleN = numel (uEleI) ;

    % Construct information on how many times each target element occurs within the output array.

    sourcesPerElement = zeros (1,uEleN) ;

    for ii = 1 : uEleN

        I = uEleI (ii) == elementI ;

        N = sum ( I ) ;

        sourcesPerElement ( ii ) = N ;

    end % for ii

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

    axisN = sizeA (axis) ;

    for ii = 1 : axisN

        readICells {axis} = ii ;

        writeICells {axis} = uOutI (ii) ;

        sourceN = sourcesPerElement ( uOutI (ii) ) ;

        outA (writeICells {:}) = outA (writeICells {:}) + A (readICells {:}) / sourceN ;

    end % for ii

end % function
