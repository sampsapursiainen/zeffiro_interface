function lint_mfiles(folder, kwargs)
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
% - linter_fn_name (1,1) string { mustBeMember(linter_fn, [ "mlint", "checkcode", "codeIssues" ]) } = "codeIssues"
%
%   The linter that is used for linting. One of "mlint", "checkcode" or
%   "codeIssues", where the last option should be preferred when using Matlab
%   >= R2022b.
%
% Outputs:
%
% - None
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

    kwargs.UNACCEPTABLE_MESSAGES (:,1) string = [ "NODEF" ; "EVLDOT" ]

    kwargs.linter_fn_name (1,1) string { mustBeMember(kwargs.linter_fn_name, ["mlint","checkcode","codeIssues"]) } = "codeIssues"

end

    disp( newline + "Linting m-files in " + folder + "..." ) ;

    matlab_release = version("-release");

    release_year = double ( string ( matlab_release(1:4) ) ) ;

    release_letter = matlab_release(5) ;

    mfile_paths = utilities.get_mfile_paths ( folder ) ;

    n_of_issues = uint64( 0 ) ;

    for fpi = 1 : numel ( mfile_paths )

        fpath = mfile_paths ( fpi ) ;

        if ismember ( kwargs.linter_fn_name, [ "mlint" ; "checkcode" ] )

            n_of_issues = n_of_issues + lint_with_legacy_linter( fpath, kwargs.UNACCEPTABLE_MESSAGES ) ;

        elseif kwargs.linter_fn_name == "codeIssues" ...
        && release_year >= 2023 ...
        || ( release_year >= 2022 && release_letter == 'b' )

            n_of_issues = n_of_issues + lint_with_codeIssues( fpath, kwargs.UNACCEPTABLE_MESSAGES ) ;

        else

            error ( "Unknown linter function, or codeIssues was called with Matlab older than R2022b. Aborting..." ) ;

        end % if

    end % for

    if n_of_issues > 0

        error( newline + "During linting, unacceptable code style violations were found. See the above " + n_of_issues + " messages for details." ) ;

    end

end % function

%% Helper functions.

function n_of_issues = lint_with_legacy_linter(fpath, UNACCEPTABLE_MESSAGES)
%
% lint_with_legacy_linter
%
% Runs mlint or checkcode on a given file path, and counts the number of
% issues found by these functions. Also displays them. Does not detect error
% severity, so only the given unacceptable message IDs are checked for.
% Therefore one should prefer the codeIssues linter, introduced in R2022b.
%

    linter_message_structs = checkcode ( fpath, "-id" ) ;

    n_of_issues = uint64 ( 0 ) ;

    for lmi = 1 : numel ( linter_message_structs )

        message = linter_message_structs ( lmi ) ;

        if ismember ( message.id, UNACCEPTABLE_MESSAGES, "rows" )

            n_of_issues = n_of_issues + 1 ;

            disp ( " " ) ; % This is needed for exactly one newline between the previous display and the next.

            disp ( "Found unacceptable linter message in " + fpath + ":" ) ;

            disp ( " " ) ; % This is needed for exactly one newline between the previous display and the next.

            disp ( message ) ;

        end % if

    end % for

end % function

function n_of_issues = lint_with_codeIssues(fpath, UNACCEPTABLE_MESSAGES)
%
% lint_with_codeIssues
%
% Runs the codeIssues linter on a given file path. This also allows one to
% check for possible severity of each message, meaning downright errors are
% easier to detect.
%

    linter_message_struct = codeIssues ( fpath ) ;

    linter_issue_table = linter_message_struct.Issues;

    n_of_table_rows = size(linter_issue_table, 1);

    n_of_issues = uint64 ( 0 ) ;

    for ri = 1 : n_of_table_rows

        issue_table_row = linter_issue_table ( ri, : ) ;

        issue_id = string ( issue_table_row.CheckID );

        issue_severity = string ( issue_table_row.Severity ) ;

        issue_line = issue_table_row.LineStart ;

        issue_description = issue_table_row.Description ;

        if ismember ( issue_id, UNACCEPTABLE_MESSAGES, "rows" ) ...
        || issue_severity == "error"

            n_of_issues = n_of_issues + 1 ;

            disp( " " ) ;

            disp ("Found unacceptable linter message in " + fpath + ":" ) ;

            disp ( " " ) ; % This is needed for exactly one newline between the previous display and the next.

            disp ( "  ID: " + issue_id ) ;

            disp ( "  Severity: " + issue_severity ) ;

            disp ( "  On line: " + issue_line ) ;

            disp ( "  Description: " + issue_description ) ;

        end % if

    end % for

end % function
