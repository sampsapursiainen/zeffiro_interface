function zef = zeffiro_interface(varargin)
%This fuction starts Zeffiro Interface. It can be run with a variable
%number of arguments, which can be called as a list of name-value pairs as
%follows:
%
%zeffiro_interface('property name 1','property value 1','property name 2','property value 2');
%
%This will enable running Zeffiro with or without a display and performing
%different operations. The list of properties (and their values) is the
%following:
%
%Property: 'restart'                     Value: none
%Property: 'start_mode'                  Value: 'display' or 'nodisplay' 
%Propertu: 'open_project'                Value: <project file name>,
%Property: 'import_to_new_project'       Value: <file name>, 
%Property: 'import_to_existing_project'  Value: <file name>, 
%Property: 'save_project'                Value: <file name>,
%Property: 'export_fem_mesh'             Value: <file name>, 
%Property: 'open_figure'                 Value: <file name>, 
%Property: 'open_figure_folder'          Value: <file name>, 
%Property: 'run_script'                  Value: <file name>, 
%Property: 'exit_zeffiro'                Value: none
%Property: 'quit_matlab'                 Vaule: none
%Property: 'use_github'                  Value: 1 (yes) or 0 (no)
%Property: 'use_gpu'                     Value: 1 (yes) or 0 (no)
%Property: 'parallel_processes'          Value: <parallel pool size>

warning off;
option_counter = 1;
zeffiro_restart = 0;
if not(isempty(varargin))
    if isequal(varargin{1},'restart')
zeffiro_restart = 1;
option_counter = option_counter + 1;
    end
end

if nargout == 0
if isequal(zeffiro_restart,0)
    if evalin('base','exist(''zef'',''var'');')
        error('It looks like that another instance of Zeffiro interface is already open. To enable this script, close Zeffiro Interface by command ''zef_close_all'' or clear zef by command ''clear zef''.')
    end
end
end

    program_path_aux = mfilename('fullpath');
    [program_path, ~] = fileparts(program_path_aux);
    run([program_path filesep 'm/zef_close_all.m']);
    zef = struct;
    
    zef.zeffiro_restart = zeffiro_restart;
    zef.program_path = program_path;
    zef.code_path = [zef.program_path filesep 'm'];    
    zef.cluster_path =  [zef.program_path filesep 'cluster'];
    
    if isequal(zeffiro_restart,0)
    addpath(zef.program_path); 
    addpath(zef.code_path); 
    addpath(zef.program_path); 
    addpath(genpath([zef.code_path]));
    addpath(genpath([zef.cluster_path]));
    addpath(genpath([zef.program_path filesep 'mlapp']));
    addpath(genpath([zef.program_path filesep 'fig']));
    addpath(genpath([zef.program_path filesep 'plugins']));
    addpath(genpath([zef.program_path filesep 'profile']));
    addpath(genpath([zef.program_path filesep 'scripts']));
    addpath([zef.program_path filesep 'external']);
    
    end
    
    zef.start_mode = 'default';
   
    if exist('zef_start_config.m','file')
      eval('zef_start_config');
    end
    
    if not(isempty(varargin))

        start_mode = 'display';

     while option_counter <= length(varargin)
            if ischar(varargin{option_counter})
            if ismember(lower(varargin{option_counter}),{lower('display'),lower('nodisplay')})
                start_mode = lower(varargin{option_counter});
                option_counter = option_counter + 1;
            elseif  ismember(lower(varargin{option_counter}),{'start_mode'})
                start_mode = lower(varargin{option_counter+1});
                option_counter = option_counter + 2;
            elseif ismember(varargin{option_counter},lower('profile_name'))
                zef.ini_cell_mod = {'Profile name',varargin{option_counter+1},'profile_name','string'};
                option_counter = option_counter + 2;

            elseif isequal(varargin{option_counter},lower('use_github'))
                
                use_github = varargin{option_counter+1};
               
                option_counter = option_counter + 2;

                elseif isequal(varargin{option_counter},lower('use_gpu'))
                
                use_gpu = varargin{option_counter+1};    
   
               
                option_counter = option_counter + 2;  
                
               elseif isequal(varargin{option_counter},lower('parallel_processes'))
                
               parallel_processes = varargin{option_counter+1};    
          
                option_counter = option_counter + 2; 
                else
                option_counter = option_counter + 1; 
            end
            else
               option_counter = option_counter + 1; 
            end
     end

        zef.start_mode = 'nodisplay';
        zef = zef_start(zef);
            if isequal(zef.zeffiro_restart,0) && isequal(exist([zef.program_path filesep 'data' filesep 'default_project.mat']),2)
        zef = zef_load(zef,'default_project.mat',[zef.program_path filesep 'data' filesep]);
            end
    
        option_counter = 1;

        while option_counter <= length(varargin)
            
            if ischar(varargin{option_counter})
                
            if isequal(varargin{option_counter},lower('open_project'))

                open_project_file = varargin{option_counter+1};
                [file_path, file_1, file_2] = fileparts(open_project_file);
                file_path = [file_path filesep];

                if isempty(file_path)
                    file_path = './data/';
                end

                if isempty(file_2)
                    file_2 = '.mat';
                end

                zef.file_path = [file_path];
                zef.file = [file_1 file_2];
                zef = zef_load(zef,zef.file,zef.file_path);
                option_counter = option_counter + 2;

            elseif isequal(varargin{option_counter},lower('import_to_new_project'))

                import_segmentation_file = varargin{option_counter+1};
                [file_path, file_1, file_2] = fileparts(import_segmentation_file);
                file_path = [file_path filesep];

                if isempty(file_path)
                    file_path = './data/';
                end

                if isempty(file_2)
                    file_2 = '.mat';
                end

                zef.new_empty_project = 1;
                zef_start_new_project;
                zef.file_path = [file_path];
                zef.file = [file_1 file_2];
                zef = zef_import_segmentation(zef);
                zef = zef_build_compartment_table(zef);
                option_counter = option_counter + 2;

            elseif isequal(varargin{option_counter},lower('import_to_existing_project'))

                import_segmentation_file = varargin{option_counter+1};
                [file_path, file_1, file_2] = fileparts(import_segmentation_file);
                file_path = [file_path filesep];

                if isempty(file_path)
                    file_path = './data/';
                end

                if isempty(file_2)
                    file_2 = '.mat';
                end

                zef.file_path = [file_path];
                zef.file = [file_1 file_2];
                zef.new_empty_project = 0;
                zef = zef_import_segmentation(zef);
                zef = zef_build_compartment_table(zef);
                option_counter = option_counter + 2;
                
                
            elseif isequal(varargin{option_counter},lower('save_project'))

                save_project_file = varargin{option_counter+1};
                [file_path, file_1, file_2] = fileparts(save_project_file);
                file_path = [file_path filesep];

                if isempty(file_path)
                    file_path = './data/';
                end

                if isempty(file_2)
                    file_2 = '.mat';
                end

                zef.file_path = [file_path];
                zef.file = [file_1 file_2];
                zef.save_switch = 1;
                zef = zef_save(zef);
                option_counter = option_counter + 2;

            elseif isequal(varargin{option_counter},lower('export_fem_mesh'))

                export_fem_mesh_file = varargin{option_counter+1};
                [file_path, file_1, file_2] = fileparts(export_fem_mesh_file );
                file_path = [file_path filesep];

                if isempty(file_path)
                    file_path = './data/';
                end

                if isempty(file_2)
                    file_2 = '.mat';
                end

                zef.file_path = [file_path];
                zef.file = [file_1 file_2];
                zef.save_switch = 1;
                zef_export_fem_mesh_as(zef);
                option_counter = option_counter + 2;

            elseif ismember(varargin{option_counter},lower('open_figure'))

                open_figure_file = varargin{option_counter+1};

                if not(iscell(open_figure_file))
                    open_figure_file_aux = open_figure_file;
                    open_figure_file = cell(0);
                    open_figure_file{1} = open_figure_file_aux;
                end

                for i = 1 : length(open_figure_file)

                    [file_path, file_1, file_2] = fileparts(open_figure_file{i});
                    file_path = [file_path filesep];

                    if isempty(file_path)
                        file_path = './fig/';
                    end

                    if isempty(file_2)
                        file_2 = '.fig';
                    end

                    zef.file_path = [file_path];
                    zef.file = [file_1 file_2];
                    zef.save_switch = 1;
                    zef = zef_import_figure(zef);
                    option_counter = option_counter + 2;
                end

            elseif ismember(varargin{option_counter},lower('open_figure_folder'))

                file_path = varargin{option_counter+1};
                dir_aux = dir(fullfile(zef_data.program_path,file_path));

                for i = 3 : length(dir_aux)

                    [~,file_1,file_2] = fileparts(dir_aux(i).name);

                    if isequal(file_2,'.fig')
                        zef.file_path = [file_path];
                        zef.file = [file_1 file_2];
                        zef.save_switch = 1;
                        zef = zef_import_figure(zef);
                        option_counter = option_counter + 2;
                    end
                end

                option_counter = option_counter + 2;

            elseif ismember(varargin{option_counter},lower('run_script'))

                run_script_name = varargin{option_counter+1};

                if not(iscell(run_script_name))
                   run_script_name_aux = run_script_name;
                   run_script_name = cell(0);
                   run_script_name{1} = run_script_name_aux;
                end

                for i = 1 : length(run_script_name)
                    eval(run_script_name{i});
                end

                option_counter = option_counter + 2;

            elseif ismember(varargin{option_counter},lower('exit_zeffiro'))
                zef_close_all;
                option_counter = option_counter + 1;
            elseif ismember(varargin{option_counter},lower('quit_matlab'))
                quit force;
                option_counter = option_counter + 1;
            else
                option_counter = option_counter + 1;
            end
            else
                 option_counter = option_counter + 1;
            end
        end
       
       

        if exist('zef','var')
        if isfield(zef,'h_zeffiro_window_main')
            if isvalid(zef.h_zeffiro_window_main)
                if ismember(start_mode,'display')
                    zef.start_mode = start_mode;
                    zef.h_zeffiro.Visible = 1;
                    zef.h_zeffiro_window_main.Visible = 1;
                    zef.h_mesh_tool.Visible = 1;
                    zef.h_mesh_visualization_tool.Visible = 1;
                    zef.h_zeffiro_menu.Visible = 1;
                    zef.use_display = 1;
                    if exist('use_gpu','var')
                        zef.use_gpu = use_gpu;
                    end
                    if exist('parallel_processes','var')
                        zef.parallel_processes = parallel_processes;
                    end
                end
            end
        end
        end

    else
        zef = zef_start(zef);
    if isequal(zef.zeffiro_restart,0) && exist([zef.program_path filesep 'data' filesep 'default_project.mat'],'file')
        zef = zef_load(zef,'default_project.mat',[zef.program_path filesep 'data' filesep]);
    end
    end
    
    if nargout == 0
    if    exist('zef','var')
        assignin('base','zef',zef);
    end
    end
    
    if exist('zef','var')
    zef.zeffiro_restart = 0;
    end
warning on;
end
