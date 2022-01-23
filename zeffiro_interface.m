function zeffiro_interface(varargin)

if evalin('base','exist(''zef'');')
error('It looks like that another instance of Zeffiro interface already open. To enable this script, clear zef by command ''clear zef'' in the base workspace.')
end

program_path = pwd;
zef_data.program_path = program_path;
zef_data.code_path = '/m';

addpath(genpath([zef_data.program_path '/mlapp']));
addpath(genpath([zef_data.program_path '/fig']));  
addpath(genpath([zef_data.program_path zef_data.code_path])); 
addpath(genpath([zef_data.program_path '/plugins']));
addpath(genpath([zef_data.program_path '/profile']));

zef_data.start_mode = 'default';

assignin('base','zef_data',zef_data);
evalin('base','zef_assign_data;');
clear zef_data;

if not(isempty(varargin))

option_counter = 1;

if ismember(varargin{option_counter},{lower('display'),lower('nodisplay')})
start_mode = lower(varargin{option_counter});
option_counter = option_counter + 1;
else
start_mode = 'nodisplay';
end
zef_data.start_mode = 'nodisplay';
assignin('base','zef_data',zef_data);
evalin('base','zef_assign_data;');
clear zef_data;
evalin('base','zeffiro_interface_start');

while option_counter <= length(varargin)
    
if isequal(varargin{option_counter},lower('open_project'))
open_project_file = varargin{option_counter+1};
[file_path, file_1, file_2] = fileparts(open_project_file);
if isempty(file_path)
    file_path = './data/';
end
if isempty(file_2)
    file_2 = '.mat';
end
zef_data.file_path = [file_path];
zef_data.file = [file_1 file_2];
assignin('base','zef_data',zef_data);
evalin('base','zef_assign_data;');
clear zef_data;
evalin('base','zef_load');
option_counter = option_counter + 2;
elseif isequal(varargin{option_counter},lower('import_segmentation'))
import_segmentation_file = varargin{option_counter+1};
[file_path, file_1, file_2] = fileparts(import_segmentation_file);
if isempty(file_path)
    file_path = './data/';
end
if isempty(file_2)
    file_2 = '.mat';
end
zef_data.file_path = [file_path]
zef_data.file = [file_1 file_2]
assignin('base','zef_data',zef_data);
evalin('base','zef_assign_data;');
clear zef_data;
evalin('base','zef_import_segmentation');
option_counter = option_counter + 2;
elseif isequal(varargin{option_counter},lower('import_segmentation_legacy'))
import_segmentation_file = varargin{option_counter+1};
[file_path, file_1, file_2] = fileparts(import_segmentation_file);
if isempty(file_path)
    file_path = './data/';
end
if isempty(file_2)
    file_2 = '.mat';
end
zef_data.file_path = [file_path]
zef_data.file = [file_1 file_2]
assignin('base','zef_data',zef_data);
evalin('base','zef_assign_data;');
clear zef_data;
evalin('base','zef_import_segmentation_legacy');
option_counter = option_counter + 2;
elseif isequal(varargin{option_counter},lower('save_project'))
save_project_file = varargin{option_counter+1};
[file_path, file_1, file_2] = fileparts(save_project_file);
if isempty(file_path)
    file_path = './data/';
end
if isempty(file_2)
    file_2 = '.mat';
end
zef_data.file_path = [file_path];
zef_data.file = [file_1 file_2];
zef_data.save_switch = 1; 
assignin('base','zef_data',zef_data);
evalin('base','zef_assign_data;');
clear zef_data;
evalin('base','zef_save');
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
if isempty(file_path)
    file_path = './fig/';
end
if isempty(file_2)
    file_2 = '.fig';
end
zef_data.file_path = [file_path];
zef_data.file = [file_1 file_2];
zef_data.save_switch = 1; 
assignin('base','zef_data',zef_data);
evalin('base','zef_assign_data;');
clear zef_data;
evalin('base','zef_import_figure');
option_counter = option_counter + 2;
end
elseif ismember(varargin{option_counter},lower('open_figure_folder'))
file_path = varargin{option_counter+1};
dir_aux = dir(fullfile(zef_data.program_path,file_path));
for i = 3 : length(dir_aux)
    [~,file_1,file_2] = fileparts(dir_aux(i).name);
if isequal(file_2,'.fig')
zef_data.file_path = [file_path];
zef_data.file = [file_1 file_2];
zef_data.save_switch = 1; 
assignin('base','zef_data',zef_data);
evalin('base','zef_assign_data;');
clear zef_data;
evalin('base','zef_import_figure');
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
evalin('base',run_script_name{i});
end
option_counter = option_counter + 2;
elseif ismember(varargin{option_counter},lower('exit_zeffiro'))
evalin('base','zef_close_all;');
option_counter = option_counter + 1;
elseif ismember(varargin{option_counter},lower('quit_matlab'))
evalin('base','quit force;');
option_counter = option_counter + 1;
else
error('Option not found in the argument list.')
return
end
end


if exist('zef.h_zeffiro_window_main')
if ismember(start_mode,'display')
zef_data.start_mode = start_mode;
assignin('base','zef_data',zef_data);
evalin('base','zef_assign_data;');
clear zef_data;
evalin('base','zef.h_zeffiro.Visible = 1;');
evalin('base','zef.h_zeffiro_window_main.Visible = 1;');
evalin('base','zef.h_mesh_tool.Visible = 1;');
end
end

else
    
evalin('base','zeffiro_interface_start');

end


end




