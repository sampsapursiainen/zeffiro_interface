function dispProgress (currentI, maxI, kwargs)
%
% dispProgress (maxI, currentI, kwargs)
%
% Can be used to display the progress of a loop.
%

    arguments
        currentI (1,1) double { mustBeInteger, mustBePositive }
        maxI (1,1) double { mustBeInteger, mustBePositive, mustBeGreaterThanOrEqual(maxI, currentI) }
        kwargs.printInterval (1,1) double { mustBeInteger, mustBePositive } = ceil (maxI / 100)
        kwargs.indent (1,1) double { mustBeInteger, mustBeNonnegative } = 2
        kwargs.fileDescriptor (1,1) double { mustBeInteger, mustBeFinite } = 1
    end

    if currentI == 1

        fprintf ( kwargs.fileDescriptor, newline ) ;

    end % if

    if currentI == 1 || currentI == maxI || mod ( currentI, kwargs.printInterval ) == 0

        indent = strjoin ( repmat ( " ", 1, kwargs.indent ), "" ) ;

        maxLog10Str = string ( ceil ( log10 (maxI) ) ) ;

        formatStr = "%s%" + maxLog10Str + "d / %" + maxLog10Str + "d" ;

        outStr = sprintf ( formatStr, indent, currentI, maxI ) ;

        outLen = strlength (outStr) ;

        backspaces = repmat ('\b', 1, outLen) ;

        fprintf ( kwargs.fileDescriptor, backspaces + outStr ) ;

    end % if

    if currentI == maxI

        fprintf ( kwargs.fileDescriptor, newline ) ;

    end % if

end % function
