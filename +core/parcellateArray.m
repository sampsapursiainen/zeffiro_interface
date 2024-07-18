function outA = parcellateArray ( A, elementI, sourcesPerElement, kwargs )
%
% A = parcellateArray ( A, elementI, sourcesPerElement )
%
% This function reduces the size of a given array A by summing the
% contributions from all rows of A into a subset of the rows representing a set
% of active elements, determined by elementI. The  results are then normalized
% based on how many sources were placed into each of those active elements.
%
% Inputs:
%
% - A
%
%   The array computed for all possible source positions.
%
% - elementI
%
%   An index mapping rowI ↦ eleI, where rowI is a row index of A and eleI is
%   the index of the active element that the contribution from that row should
%   map to.
%
% - sourcePerElement
%
%   Amounts by which each entry in elementI is divided or normalized by after
%   the aggregation.
%
% - kwargs.axis = 1
%
%   The axis along which the parcellation will be performed. Must be one of 1
%   (rows) or 2 (columns).
%

    arguments
        A (:,:) double { mustBeFinite }
        elementI (:,1) int32 { mustBePositive }
        sourcesPerElement (:,1) double { mustBePositive, mustBeInteger }
        kwargs.axis (1,1) double { mustBeMember(kwargs.axis, [1,2]) } = 1
    end

    % Compute a few sizes.

    eleN = numel ( unique (elementI) ) ;

    [rowN, colN] = size (A) ;

    % Choose parcellation direction.

    if kwargs.axis == 1

        % Perform the integration along rows.

        outA = zeros (eleN,colN) ;

        for ii = 1 : rowN

            eleI = elementI (ii) ;

            outA (eleI,:) = outA (eleI,:) + A (ii,:) ;

        end % for ii

    else

        % Perform the integration along cols.

        outA = zeros (rowN,eleN) ;

        for ii = 1 : colN

            eleI = elementI (ii) ;

            outA (:,eleI) = outA (:,eleI) + A (:,ii) ;

        end % for ii

        sourcesPerElement = transpose (sourcesPerElement) ;

    end % if

    % Perform integral normalization.

    outA = outA ./ sourcesPerElement ;

end % function
