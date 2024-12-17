function [filteredField, filteredSourcePos] = quantileFilteredFieldFn (field, sourcePos, quantileVal)
%
% [filteredField, filteredSourcePos] = quantileFilteredFieldFn (field, sourcePos, quantileVal)
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
% - quantileVal
%
%   The quantile used for filtering.
%

    arguments
        field (:,:) double { mustBeFinite }
        sourcePos (3,:) double { mustBeFinite }
        quantileVal (1,1) double { mustBeInRange(quantileVal,0,1) }
    end

    fieldX = field(1:3:end);

    fieldY = field(2:3:end);

    fieldZ = field(3:3:end);

    filterXI = fieldX <= quantile(fieldX, quantileVal) ;

    filterYI = fieldY <= quantile(fieldY, quantileVal) ;

    filterZI = fieldZ <= quantile(fieldZ, quantileVal) ;

    sourceFilterI = filterXI & filterYI & filterZI ;

    filteredSourcePos = sourcePos(:,sourceFilterI) ;

    fieldFilterI = repelem(sourceFilterI,1,3);

    filteredField = field(:,fieldFilterI) ;

end % function
