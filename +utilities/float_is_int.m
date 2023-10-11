function is_int = float_is_int ( float )
%
% float_is_int
%
% Checks whether a floating point number is an integer up to machine epsilon accuracy.
%

    arguments

        float (:,:) double

    end

    is_int = true ;

    if any ( isnan ( float (:) ) )

        is_int = false ;

    end

    if not ( all ( isfinite ( float (:) ) ) )

        is_int = false ;

    end

    if any ( float (:) ~= floor ( float (:) ) )

        is_int = false ;

    end

end % function
