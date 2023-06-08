if isequal(zef.zeffiro_restart, 0), addpath ( fullfile ( zef.program_path, 'external', 'SDPT3/' ) ) ; end
if isequal(zef.zeffiro_restart, 0), addpath ( fullfile ( zef.program_path, 'external', 'SeDuMi/' ) ) ; end
if isequal(zef.zeffiro_restart, 0), addpath ( fullfile ( zef.program_path, 'external', 'CVX/' ) ) ; end

if isequal(zef.zeffiro_restart, 0)

    try

        evalc('cvx_startup');

    catch err

        warning_title = "External CVX Plugin" ;

        warning_message = warning_message_fn ( "CVX", "cvx_startup" ) ;

        if zef.start_mode == "display"

            warning_fig = warndlg ( warning_message, warning_title ) ;

            uiwait ( warning_fig ) ;

        else

            warning ( warning_title + ": " + warning_message ) ;

        end % if

    end % try

end % if

if isequal(zef.zeffiro_restart, 0), addpath ( fullfile( zef.program_path, 'external', 'fieldtrip/') ) ; end
if isequal(zef.zeffiro_restart, 0)

    try

        evalc('ft_defaults');

    catch err

        warning_title = "External FieldTrip Plugin" ;

        warning_message = warning_message_fn ( "FieldTrip", "ft_defaults" ) ;

        if zef.start_mode == "display"

            warning_fig = warndlg ( warning_message, warning_title ) ;

            uiwait ( warning_fig ) ;

        else

            warning ( warning_title + ": " + warning_message ) ;

        end % if

    end % try

end % if

if isequal(zef.zeffiro_restart, 0), addpath ( fullfile ( zef.program_path, 'external', 'spm12/' ) ) ; end

%% Helper functions.

function warning_message = warning_message_fn(plugin_name, plugin_function_name)

    arguments

        plugin_name (1,1) string

        plugin_function_name (1,1) string

    end

        warning_message = "The external " ...
            + plugin_name ...
            + " plugin function " ...
            + plugin_function_name ...
            + " could not be found. To use the ES Workbench plugin, please install " ...
            + plugin_name ...
            + " along with Zeffiro Interface by running" ...
            + newline ...
            + newline ...
            + "  git submodule update --init --recursive" ...
            + newline ...
            + newline ...
            + "if you downloaded the project with git clone, or install the project again with zeffiro_downloader." ;

end % function
