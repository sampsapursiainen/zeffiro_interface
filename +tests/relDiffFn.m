function relDiff = relDiffFn(field1,field2, dbVal)
%
% relDiff = relDiffFn(field1,field2, dbVal)
%
% Computes the relative difference
%
%   relDiff = abs(field1 - field2) / max(delta,abs(field2))
%
% of two given fields, where
%
%   delta = db2mag(dbVal) * max(abs(field2))
%
% The dbVal argument is used as a threshold,
% below which the difference becomes insignificant.
%

    arguments
        field1 (:,1) double { mustBeFinite }
        field2 (:,1) double { mustBeFinite }
        dbVal (1,1) double { mustBeFinite, mustBeNonpositive }
    end

    delta = db2mag(dbVal) * max(abs(field2)) ;

    relDiff = abs(field1 - field2) ./ max(delta,abs(field2)) ;

end % function
