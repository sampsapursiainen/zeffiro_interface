function to_out = copy_fields ( from, to, kwargs )
%
% copy_fields ( from, to )
%
% Copies the fields from one struct to another.
%
% Inputs:
%
% - from
%
%   The scruct fron which the fields will be copied.
%
% - to
%
%   The struct that the fields will be copied to.
%
% - kwargs.error_on_overwrite = false
%
%   If this is set to true, the function will return a struct with just one
%   field called "copy_fields_error__", with an error message describing what
%   happened.
%
% Outputs:
%
% - to_out
%
%   The struct that the fields were added to.
%

    arguments
        from                        (1,1)   struct
        to                          (1,1)   struct
        kwargs.error_on_overwrite   (1,1)   logical = false
    end

    fns = string ( fieldnames ( from ) ) ;

    for fi = 1 : numel ( fns )

        fn = fns ( fi ) ;

        if kwargs.error_on_overwrite && isfield ( to, fn )

            to_out.copy_fields_error__ = "The given struct already contains a field called '" + fn + "'." ;

            return

        end

        to.(fn) = from.(fn) ;

    end % for

    to_out = to ;

end % function
