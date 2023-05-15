function lint_mfiles(folder)
%
% lint_mfiles
%
% Runs checkcode on all .m files in the given folder and its subfolders.
% Throws and error at the end, if unacceptable linter messages were discovered
% in the process.
%

arguments

    folder (1,1) string { mustBeFolder }

end

    disp( newline + "Linting m-files in " + folder + "..." ) ;

    mfile_paths = utilities.get_mfile_paths ( folder ) ;

    UNACCEPTABLE_MESSAGES = [ "NODEF" ; "EVLDOT" ] ;

    unacceptable_message_count = uint64( 0 ) ;

    for fpi = 1 : numel ( mfile_paths )

        fpath = mfile_paths ( fpi ) ;

        linter_message_structs = checkcode ( fpath, "-id" ) ;

        for lmi = 1 : numel ( linter_message_structs )

            message = linter_message_structs ( lmi ) ;

            if ismember ( message.id, UNACCEPTABLE_MESSAGES )

                unacceptable_message_count = unacceptable_message_count + 1 ;

                disp ( "Found unacceptable linter message in " + fpath + ":" ) ;

                disp ( " " ) ; % This is needed for exactly one newline between the previous display and the next.

                disp ( message ) ;

            end % if

        end % for

    end % for

    if unacceptable_message_count > 0

        error( newline + "During linting, unacceptable code style violations were found. See the above " + unacceptable_message_count + " messages for details." ) ;

    end

end % function
