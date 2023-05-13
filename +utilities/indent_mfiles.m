function indent_mfiles(folder)
%
% indent_mfiles
%
% Programmatically indents matlab source files in a given folder and its
% subdirectories. Requires that Java is available, meaning Matlab cannot be
% started with -nodesktop.
%
% NOTE 1: this function requires that Matlab was opened with the Java
% components enabled.
%
% NOTE 2: be very careful about opening a project with the number of files in
% the thousands. Due to the way the function
%
%   matlab.desktop.editor.openDocument
%
% works, the files will all be opened before the indentation will be applied.
% This will end up overflowing the Java heap.
%
% Inputs:
%
% - folder
%
%   The root folder from which m-files are to be searched recursively. This
%   needs to exist, or an error will be thrown.
%
% Outputs:
%
% None.
%

    arguments

        folder (1,1) string { mustBeFolder }

    end

    mfile_paths = utilities.get_mfile_paths( folder ) ;

    for ff = mfile_paths

        fh = matlab.desktop.editor.openDocument(ff) ;

        cleanup_object = onCleanup( @() cleanup_fn ( fh ) );

        fh.smartIndentContents()

        fh.save()

    end % for

end % function

%% Helper functions.

function cleanup_fn(document)

    document.close();

end % function
