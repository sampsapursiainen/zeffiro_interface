function lf_tag = lf_tag_from_lf_type( lf_type )
%
% lf_tag_from_lf_type
%
% Converts a given lead field type integer into a human-readable lead field
% tag. This is used by the plugins in the plugins/ folder, which is why this is
% located here.
%
% Inputs:
%
% - lf_type (1,1) double { mustBemember ( [1,2,3,4,5] ) }
%
%   The type of the lead field. Here 1 maps to EEG, 2 maps to MEG, 3 maps to
%   gMEG, 4 maps to EIT and 5 maps to tES. No other inputs are accepted.
%
% Outputs:
%
% - lf_tag
%
%   The textual tag.
%

arguments

    lf_type (1,1) double { mustBeMember( lf_type, [1, 2, 3, 4, 5] ) }

end

if lf_type == 1

    lf_tag = 'EEG' ;

elseif lf_type == 2

    lf_tag = 'MEG' ;

elseif lf_type == 3

    lf_tag = 'gMEG' ;

elseif lf_type == 4

    lf_tag = 'EIT' ;

elseif lf_type == 5

    lf_tag = 'tES' ;

else

    error ( "Unknown lead field type " + lf_type + ". Must be one of 1, 2, 3, 4 or 5." ) ;

end

end % function
