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

    mfile_paths = utilities.get_mfile_paths ( folder ) ;

    unacceptable_message_found = false ;

    UNACCEPTABLE_MESSAGES = [ "NODEF" ; "EVLDOT" ] ;

    for fpi = 1 : numel ( mfile_paths )

        fpath = mfile_paths ( fpi ) ;

        linter_message_structs = checkcode ( fpath, "-id" ) ;

        for lmi = 1 : numel ( linter_message_structs )

            message = linter_message_structs ( lmi ) ;

            if ismember ( message.id, UNACCEPTABLE_MESSAGES )

                unacceptable_message_found = true ;

                disp ( "Found unacceptable linter message in " + fpath + ":" ) ;

                disp ( newline ) ;

                disp ( message ) ;

            end % if

        end % for

    end % for

    if unacceptable_message_found

        error( newline + "During linting, unacceptable code style violations were found. See the above messages for details." ) ;

    end

end % function
