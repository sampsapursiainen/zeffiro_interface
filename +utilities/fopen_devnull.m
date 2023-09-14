function devnull = fopen_devnull
%
% fopen_devnull
%
% Opens a null device, so that function output might be discarded if necessary.
% Throws an error if the platform is not supported.
%

    arguments end % We take no prison... I mean arguments.

    if ispc

        % On Windows, every folder contains a hidden folder "nul", which may not be modifier by a
        % user. This corresponds to a null device on Unix.

        devnull = fopen ( "nul" ) ;

    elseif isunix || ismac

        devnull = fopen ( fullfile ( "/","dev","null" ) ) ;

    else

        error ( "fopen_devnull: Unsupported plaform. Must be one of Linux, macOS or Windows." ) ;

    end

    if devnull == -1

        error ( "fopen_devnull: could not open the null device." ) ;

    end

end % function
