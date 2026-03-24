function interferenceField = interferenceFieldFn(field1, field2)
%
% interferenceField = interferenceFieldFn(field1, field2)
%
% Computes the interference field
%
%   abs(abs(field1 + field2) - abs(field1 - field2))
%
% for two given fields.
%

    arguments
        field1 (:,1) double { mustBeFinite }
        field2 (:,1) double { mustBeFinite }
    end

    fSum = field1 + field2 ;

    fDif = field1 - field2 ;

    interferenceField = abs(abs(fSum) - abs(fDif)) ;

end % function
