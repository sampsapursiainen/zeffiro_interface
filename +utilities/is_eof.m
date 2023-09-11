function out = is_eof ( in )
%
% is_eof
%
% Provides a human-readable one-liner for checking whether one of Matlab's
% older file reading functions encountered an end of file marker, when reading
% a file.
%
% Input:
%
% - in
%
%   Either plain text, if not an EOF character, or an integer -1.
%
% Output:
%
% - out
%
%   A boolean describing whether an eof character was found.
%

    arguments

        in (1,1) string

    end

    out = in == "-1" ;

end % function
