function lint_mfiles(folder, UNACCEPTABLE_MESSAGES)
%
% lint_mfiles
%
% Runs checkcode on all .m files in the given folder and its subfolders.
% Throws and error at the end, if unacceptable linter messages were discovered
% in the process.
%
% Inputs:
%
% - folder (1,1) string { mustBeFolder }
%
%   The folder whose .m files will be linted.
%
% - UNACCEPTABLE_MESSAGES (1,1) string = [ "NODEF" ; "EVLDOT" ]
%
%   This optional second argument can be used to adjust which linter message
%   IDs are undesirable. To see a full list of possible values, check out the
%   [linter message index].
%
% Outputs:
%
% - None.
%
%   The function throws an error at the end, if undesirable messages were
%   found.
%
% Links:
%
% [linter message index]: https://se.mathworks.com/help/matlab/matlab_env/index-of-code-analyzer-checks.html
%

arguments

    folder (1,1) string { mustBeFolder }

    UNACCEPTABLE_MESSAGES (:,1) string = [ "NODEF" ; "EVLDOT" ]

end

    disp( newline + "Linting m-files in " + folder + "..." ) ;

    mfile_paths = utilities.get_mfile_paths ( folder ) ;

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
