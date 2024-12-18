function difference = differencePerMean (left, right)
%
% difference = differencePerMean (left, right)
%
%
%

    arguments
        left (:,:) double { mustBeFinite }
        right (:,:) double { mustBeFinite }
    end

    difference = (left - right) ./ mean ( right ) ;

end % function
