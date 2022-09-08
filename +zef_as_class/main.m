function zef_or_zi = main(project_file_path, use_gui)

    % app.main
    %
    % The main function of Zeffiro Interface.
    %
    % Input:
    %
    % - project_file_path
    %
    %   A Zeffiro Interface project file, which is loaded into the back-end
    %   before a GUI is loaded, if it is loaded. If this is empty, "none" or
    %   "no project", the back-end is loaded with null fields, but still
    %   usable.
    %
    % - use_gui
    %
    %   A boolean, which determines whether to start the program with or
    %   without a GUI. If no GUI is used, an object of type Zef is returned,
    %   which should be captured on the command line if one wishes to use the
    %   back-end of the program and its methods as-is.
    %
    %   default: false
    %
    % Output:
    %
    % - zef_or_zi
    %
    %   Either an instance of the back-end object Zef, or a handle to a main
    %   GUI object ZeffiroInterface, depending on whether use_gui was set to
    %   true.

    arguments

        project_file_path (1,1) string { mustBeText }

        use_gui (1,1) logical = false

    end

    % Remove possible typos in project path.

    fixed_project_file_path = strtrim(project_file_path);

    fixed_project_file_path = regexprep(fixed_project_file_path,' +', ' ');

    % Load an instance of Zef.

    if strcmp(fixed_project_file_path, "") ...
    || strcmp(fixed_project_file_path, "none") ...
    || strcmp(fixed_project_file_path, "no project") ...

        zef = app.Zef(struct);

    else

        zef = app.Zef.load_from_file(project_file_path);

    end

    % Then start gui, if use_gui was set.

    if use_gui

        zef_or_zi = app.ZeffiroInterface(zef);

    else

        zef_or_zi = zef;

    end

    % If caller did not order an application handle, do not return anything.

    if nargout == 0

        if ~ use_gui

            warning("Zeffiro Interface initialized without a GUI, but no handle to the Zef object was ordered by the caller. The back-end will be unavailable.")

        end

        clear zef_or_zi;

    end

end
