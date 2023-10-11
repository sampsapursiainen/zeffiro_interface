function indent_mfiles ( filename )
%
% indent_mfile
%
% Programmatically indents a given Matlab source file. Requires that Java is
% available, meaning Matlab cannot be started with -nodesktop.
%
% NOTE 1: this function requires that Matlab was opened with the Java
% components enabled.
%
% Inputs:
%
% - filename
%
%   The name of the file tha is to be indented.
%
% Outputs:
%
% None.
%

    arguments

        filename (1,1) string { mustBeFile }

    end

    fullpath = which ( filename ) ;

    fh = matlab.desktop.editor.openDocument ( fullpath ) ;

    cleanup_object = onCleanup( @() cleanup_fn ( fh ) );

    fh.smartIndentContents()

    fh.save()

end % function

%% Helper functions.

function cleanup_fn(document)

    document.close();

end % function
