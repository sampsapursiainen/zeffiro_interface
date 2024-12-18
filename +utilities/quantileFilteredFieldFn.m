function [filteredField, filteredSourcePos] = quantileFilteredFieldFn (field, sourcePos, lowerQ, upperQ)
%
% [filteredField, filteredSourcePos] = quantileFilteredFieldFn (field, sourcePos, upperQ)
%
% Restricts a given field below a certain quantile. Also selects the subset of
% source positions that correspond to the filtered columns of the field.
%
% Inputs:
%
% - field
%
%   The field being filtered.
%
% - sourcePos
%
%   The source positions corresponding to the groups of 3 columns in field.
%
% - lowerQ
%
%   The lower quantile used for filtering.
%
% - upperQ
%
%   The quantile used for filtering.
%

    arguments
        field (1,:) double { mustBeFinite }
        sourcePos (3,:) double { mustBeFinite }
        lowerQ (1,1) double { mustBeInRange(lowerQ,0,1) }
        upperQ (1,1) double { mustBeInRange(upperQ,lowerQ,1) }
    end

    fieldX = field(1:3:end);

    fieldY = field(2:3:end);

    fieldZ = field(3:3:end);

    filterXI = fieldX >= quantile(fieldX, lowerQ) & fieldX <= quantile(fieldX, upperQ) ;

    filterYI = fieldY >= quantile(fieldY, lowerQ) & fieldY <= quantile(fieldY, upperQ) ;

    filterZI = fieldZ >= quantile(fieldZ, lowerQ) & fieldZ <= quantile(fieldZ, upperQ) ;

    sourceFilterI = filterXI & filterYI & filterZI ;

    filteredSourcePos = sourcePos(:,sourceFilterI) ;

    fieldFilterI = repelem(sourceFilterI,1,3);

    filteredField = field(:,fieldFilterI) ;

end % function
