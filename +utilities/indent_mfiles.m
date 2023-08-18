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

    mfile_paths = utilities.get_mfile_paths( folder )

    for fi = 1 : numel ( mfile_paths )

        fp = mfile_paths ( fi ) ;

        utilities.indent_mfile ( fp ) ;

    end % for

end % function
