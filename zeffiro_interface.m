function zef = zeffiro_interface(args)

%
% zeffiro_interface
%
% This fuction starts Zeffiro Interface. It can be run with a variable number
% of key–value arguments, which can be called as a list of name-value pairs as
% follows:
%
%   zef = zeffiro_interface("name_1", value_1, "name_2", value_2, …);
%
% Matlab versions newer or equal to r2021a may also use the syntax
%
%   zef = zeffiro_interface(name_1=value_1, name_2=value_2, …)
%
% Either way, this enables running Zeffiro with or without a display and
% performing different operations. The list of names and their values is given
% below.
%
%   Name                            Value and explanation
%   ------------------------------- ------------------------------------------
%
%   'restart'                       true or false (default = false)
%
%                                   If this is set to true, the closing of
%                                   Zeffiro Interface is forced before any
%                                   other actions are attempted.
%
%   'start_mode'                    'display' or 'nodisplay' (default = "display")
%
%                                   This setting determines whether the GUI
%                                   elements of Zeffiro Interface will be
%                                   displayed during its operation. mainly
%                                   useful when running the program from a
%                                   terminal.
%
%                                   NOTE: this will not prevent them from
%                                   opening up in the background. They are
%                                   simply hidden from view.
%
%   'open_project'                  <project file name>, (default = "")
%
%                                   Loads a Zeffiro Interface project file
%                                   into memory during start-up.
%
%   'import_to_new_project'         <file name> (default = "")
%
%                                   This will import a project with specs
%                                   given in a .zef file to a new project.
%
%   'import_to_existing_project'    <file name> (default = "")
%
%                                   This will import a project with specs
%                                   given in a .zef file to the currently
%                                   active project.
%
%   'save_project'                  <file name> (default = "")
%
%                                   If this is given, the currently active
%                                   project will be saved to this file in its
%                                   entirety.
%
%   'export_fem_mesh'               <file name> (default = "")
%
%                                   A fem mesh contained in the active project
%                                   will be saved to this given file.
%
%   'open_figure'                   <file name> (default = "")
%
%                                   The figure in this given path is opened by
%                                   Zeffiro Interface.
%
%   'open_figure_folder'            <file name> (default = "")
%
%                                   The Matlab figures in this given path will
%                                   be openend by Zeffiro Interface.
%
%   'run_script'                    <the script as a string>
%
%                                   This string will be passed through the
%                                   Matlab function eval.
%
%                                   NOTE: this is a possible security hole.
%                                   Make sure the given string only contains
%                                   instructions from a trusted source.
%
%   'exit_zeffiro'                  true or false (default = false)
%
%                                   If this is set to true, Zeffiro Interface
%                                   is closed immediately when this function
%                                   returns.
%
%   'quit_matlab'                   true or false (default = false)
%
%                                   If this is set to true, Matlab itself will
%                                   be closed when this function returns.
%
%   'use_github'                    true or false (default = false)
%
%                                   Determines whether the automatic Git
%                                   integration of Zeffiro Interface is to be
%                                   used.
%
%                                   NOTE: this feature is not very mature and
%                                   should probably not be set to true under
%                                   any circumstances. Use Git manually, if at
%                                   all possible (which it is).
%
%   'use_gpu'                       true or false (default = false)
%
%                                   Determines whether Zeffiro Interface will
%                                   use a GPU in its computations.
%
%   'use_gpu_graphic'               true or false (default = false)
%
%                                   Determines whether Zeffiro Interface will
%                                   use GPU acceleration when drawing figures
%                                   and the like.
%
%   'gpu_num'                       <gpu device number>
%
%                                   Allows one to choose which GPU device to
%                                   use when `use_gpu` is set to true.
%
%   'use_display'                   true or false (default = false)
%
%                                   Determines whether dialogs like folder
%                                   browsers are displayed, when .mat files
%                                   are being saved.
%
%   'parallel_processes'            <parallel pool size>
%
%                                   How many workers Zeffiro Interface will
%                                   use when runnin parallel computations.
%
%   'verbose_mode'                  true or false (default = false)
%
%                                   Determines whether the logger is to print
%                                   terse or less terse output.
%
%   'use_waitbar'                   true or false (default = false)
%
%                                   Whether to display a waitbar during
%                                   computations.
%
%   'use_log'                       true or false (default = false)
%
%                                   Whether to print output to a log file.
%
%   'log_file_name'                 <log file name>
%
%                                   A path to a file where Zeffiro Interface
%                                   is to write its log messages.
%
%   NOTE: the value behind the name "run_script" is run using the Matlab
%   function eval, meaning one should be absolutely sure that the script
%   contents come from a trusted source.
%

    arguments

        args.restart (1,1) logical = false;

        args.start_mode (1,1) string { mustBeMember(args.start_mode, ["display", "nodisplay", "default"]) } = "default";

        args.open_project (1,1) string = "";

        args.import_to_new_project (1,1) string = "";

        args.import_to_existing_project (1,1) string = "";

        args.save_project (1,1) string = "";

        args.export_fem_mesh (1,1) string = "";

        args.open_figure (1,1) string = "";

        args.open_figure_folder (1,1) string = "";

        args.run_script (:,1) string = "";

        args.exit_zeffiro (1,1) logical = false;

        args.quit_matlab (1,1) logical = false;

        args.use_github (1,1) logical = false;

        args.use_gpu (1,1) logical = false;

        args.use_gpu_graphic (1,1) logical = false;

        args.gpu_num (1,1) double { mustBeInteger, mustBeNonnegative } = 0;

        args.use_display (1,1) logical = false;

        args.parallel_processes (1,1) double {mustBePositive, mustBeInteger} = 1;

        args.verbose_mode (1,1) logical = false;

        args.use_waitbar (1,1) logical = false;

        args.use_log (1,1) logical = false;

        args.log_file_name (1,1) string = "";

    end

    % Prevent starting of Zeffiro, if there is an existing value of zef.

    if not(args.restart) && evalin("base","exist('zef', 'var');")

        error( ...
            "It looks like another instance of Zeffiro Interface is already open." ...
            + " To start a new instance, close Zeffiro Interface with 'zef_close_all'," ...
            + " clear zef from the base workspace with the command 'clear zef' or" ...
            + " force a restart with" ...
            + newline + newline ...
            + "    zef = zeffiro_interface('restart', true, other_options…);" ...
        )

    end

    addpath(fullfile("m"))

    zef_close_all();

    %% Set zef fields based on name–value arguments.

    zef = struct;

    zef.zeffiro_restart = args.restart;

    zef.start_mode = args.start_mode;

    zef.use_github = args.use_github;

    zef.use_gpu = args.use_gpu;

    zef.use_gpu_graphic = args.use_gpu_graphic;

    zef.gpu_num = args.gpu_num;

    zef.use_display = args.use_display;

    zef.parallel_processes = args.parallel_processes;

    zef.verbose_mode = args.verbose_mode;

    zef.use_waitbar = args.use_waitbar;

    zef.use_log = args.use_log;

    zef.log_file_name = args.log_file_name;

    %% Then do initial preparations like path building and additions.

    program_path = string(mfilename("fullpath"));

    [program_path, ~] = fileparts(program_path);

    program_path = string(program_path);

    code_path = fullfile(program_path, "m");

    % TODO: should this be run here?
    %
    % run(code_path + filesep + "zef_close_all.m");

    zef.program_path = char(program_path);

    zef.code_path = code_path;

    zef.data_path = fullfile(zef.program_path, "data");

    zef.external_path = fullfile(zef.program_path, "external");

    zef.zeffiro_task_id = 0;

    zef.zeffiro_restart_time = now;

    zef.cluster_path =  fullfile(zef.program_path, "cluster");

    addpath(zef.program_path);
    addpath(zef.code_path);
    addpath(genpath(zef.code_path));
    addpath(genpath(zef.cluster_path));

    addpath(genpath(fullfile(zef.program_path, "mlapp")));
    addpath(genpath(fullfile(zef.program_path, "fig")));
    addpath(genpath(fullfile(zef.program_path, "plugins")));
    addpath(genpath(fullfile(zef.program_path, "profile")));
    addpath(genpath(fullfile(zef.program_path, "scripts")));

    addpath(zef.external_path);

    if not(zef.zeffiro_restart)

        addpath(fullfile(zef.external_path, "SDPT3"));
        addpath(fullfile(zef.external_path, "SeDuMi"));
        addpath(fullfile(zef.external_path, "CVX"));

        % TODO: does not work.
        %
        % evalc("cvx_startup");

    end

    zef = zef_start(zef);

    if not(zef.zeffiro_restart) && isfile(fullfile(zef.data_path, "default_project.mat"))

        zef = zef_load(zef, "default_project.mat", fullfile(zef.data_path));

    end

    zef = zef_start_log(zef);

    if isfield(zef, "h_zeffiro_window_main") ...
    && isvalid(zef.h_zeffiro_window_main) ...
    && zef.start_mode == "display"

        zef.start_mode = start_mode;
        zef.h_zeffiro.Visible = 1;
        zef.h_zeffiro_window_main.Visible = 1;
        zef.h_mesh_tool.Visible = 1;
        zef.h_mesh_visualization_tool.Visible = 1;
        zef.h_zeffiro_menu.Visible = 1;
        zef.use_display = 1;

    end

    %% Finally, do the things specified by the input arguments.

    % Choose GPU device, if available.

    zef.gpu_count = gpuDeviceCount;

    if zef.gpu_count > 0 && zef.use_gpu

        try

            gpuDevice(zef.gpu_num);

        catch

            warning("Tried using GPU with index " + zef.gpu_num + " but no such device was found. Starting without GPU...");

        end

    end % if

    % Open new project if given.

    if not(args.open_project == "")

        open_project_file = args.open_project;

        [file_path, fname, fsuffix] = fileparts(open_project_file);

        if file_path == ""
            file_path = fullfile(zef.program_path, "data");
        end

        if fsuffix == ""
            fsuffix = ".mat";
        end

        zef.file_path = char(file_path);

        zef.file = char(fname + fsuffix);

        zef = zef_load(zef, zef.file, zef.file_path);

    end % if

    % Import given file contents to a new project.

    if not(args.import_to_new_project == "")

        import_segmentation_file = args.import_to_new_project;

        [file_path, fname, fsuffix] = fileparts(import_segmentation_file);

        if file_path == ""

            file_path = fullfile(zef.program_path, "data");

        end

        if fsuffix == ""

            fsuffix = ".mat";

        end

        zef.new_empty_project = 1;

        zef_start_new_project;

        zef.file_path = char(file_path);

        zef.file = char(fname + fsuffix);

        zef = zef_import_segmentation(zef);

        zef = zef_build_compartment_table(zef);

    end % if

    % Import given file contents into an existing project.

    if not(args.import_to_existing_project == "")

        import_segmentation_file = args.import_to_existing_project;

        [file_path, fname, fsuffix] = fileparts(import_segmentation_file);

        if file_path == ""

            file_path = fullfile(zef.program_path, "data");

        end

        if fsuffix == ""

            fsuffix = ".mat";

        end

        zef.file_path = char(file_path);

        zef.file = char(fname + fsuffix);

        zef.new_empty_project = 0;

        zef = zef_import_segmentation(zef);

        zef = zef_build_compartment_table(zef);

    end % if

    % Open figure in a given path.

    if not(args.open_figure == "")

        open_figure_file = args.open_figure;

        if not(iscell(open_figure_file))

            open_figure_file_aux = open_figure_file;

            open_figure_file = cell(0);

            open_figure_file{1} = open_figure_file_aux;

        end

        for i = 1 : length(open_figure_file)

            [file_path, fname, fsuffix] = fileparts(open_figure_file{i});

            if file_path == ""
                file_path = fullfile(zef.program_path, "fig");
            end

            if fsuffix == ""
                fsuffix = ".fig";
            end

            zef.file_path = char(file_path);

            zef.file = char(fname + fsuffix);

            zef.save_switch = 1;

            zef = zef_import_figure(zef);

        end % for

    end % if

    % Open all figures in a given folder, if given.

    if not(args.open_figure_folder == "")

        file_path = args.open_figure_folder;

        dir_aux = dir(fullfile(zef.program_path,file_path));

        for i = 3 : length(dir_aux)

            [~, fname, fsuffix] = fileparts(string(dir_aux(i).name));

            if isequal(fsuffix, ".fig")

                zef.file_path = char(file_path);

                zef.file = char(fname + fsuffix);

                zef.save_switch = 1;

                zef = zef_import_figure(zef);

            end % if

        end % for

    end % if

    % Before possibly saving and quitting, run the script given as an
    % argument.
    %
    % NOTE: using eval here is very unsafe. Allows for arbitrary code
    % execution. Make sure given script is from a trusted source.

    if not(args.run_script == "")

        eval(args.run_script);

    end % if

    % Export FE mesh to a given path.

    if not(args.export_fem_mesh == "")

        export_fem_mesh_file = args.export_fem_mesh;

        [file_path, fname, fsuffix] = fileparts(export_fem_mesh_file );

        if file_path == ""

            file_path = fullfile(zef.program_path, "data");

        end

        if fsuffix == ""

            fsuffix = ".mat";

        end

        zef.file_path = char(file_path);

        zef.file = char(fname + fsuffix);

        zef.save_switch = 1;

        zef_export_fem_mesh_as(zef);

    end % if

    % Save entire open project to the given file, if not empty.

    if not(args.save_project == "")

        save_project_file = args.save_project;

        [file_path, fname, fsuffix] = fileparts(save_project_file);

        if file_path == ""

            file_path = fullfile(zef.program_path, "data");

        end

        if fsuffix == ""

            fsuffix = ".mat";

        end

        zef.file_path = char(file_path);

        zef.file = char(fname + fsuffix);

        zef.save_switch = 1;

        zef = zef_save(zef);

    end

    % Exit zeffiro, if told to.

    if args.exit_zeffiro
        zef_close_all;
    end

    % Close Matlab, if told to.

    if args.quit_matlab
        quit force;
    end

    % Make sure zef exists as a varible in the base workspace.

    if nargout == 0

        assignin("base", "zef", zef);

        % This prevents the returning of zef twice, with "ans" as the name of
        % the other instance.

        clear zef;

    end

end % function
