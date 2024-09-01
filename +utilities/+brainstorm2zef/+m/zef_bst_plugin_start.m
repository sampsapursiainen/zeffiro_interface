
function varargout = zef_bst_plugin_start(folder_name,zef_bst,open_dialog)

if nargin < 2
    zef_bst = struct;
end

if nargin < 3
open_dialog = 1;
end

varargout = cell(0);
zef.program_path = folder_name;
addpath(fullfile(folder_name,'m'));
zef = zef_apply_system_settings(zef);
position_vec = zef.segmentation_tool_default_position;
position_vec([2])  = position_vec([2])+position_vec([4]);
screen_size = groot().ScreenSize;
position_vec = position_vec./screen_size([3 4 3 4]);
position_vec([3 4]) = 0.25;
position_vec([2]) = position_vec([2]) - 0.25;

zef = struct;

h_fig = figure(...
    'PaperUnits',get(0,'defaultfigurePaperUnits'),...
    'Units','normalized',...
    'OuterPosition',position_vec,...
    'Renderer',get(0,'defaultfigureRenderer'),...
    'Visible',open_dialog,...
    'Color',get(0,'defaultfigureColor'),...
    'CloseRequestFcn','set(findobj(gcbo().Children,''Tag'',''run_button''),''UserData'',0);',...
    'CurrentAxesMode','manual',...
    'IntegerHandle','off',...
    'NextPlot',get(0,'defaultfigureNextPlot'),...
    'Colormap',[0 0 0.5625;0 0 0.625;0 0 0.6875;0 0 0.75;0 0 0.8125;0 0 0.875;0 0 0.9375;0 0 1;0 0.0625 1;0 0.125 1;0 0.1875 1;0 0.25 1;0 0.3125 1;0 0.375 1;0 0.4375 1;0 0.5 1;0 0.5625 1;0 0.625 1;0 0.6875 1;0 0.75 1;0 0.8125 1;0 0.875 1;0 0.9375 1;0 1 1;0.0625 1 1;0.125 1 0.9375;0.1875 1 0.875;0.25 1 0.8125;0.3125 1 0.75;0.375 1 0.6875;0.4375 1 0.625;0.5 1 0.5625;0.5625 1 0.5;0.625 1 0.4375;0.6875 1 0.375;0.75 1 0.3125;0.8125 1 0.25;0.875 1 0.1875;0.9375 1 0.125;1 1 0.0625;1 1 0;1 0.9375 0;1 0.875 0;1 0.8125 0;1 0.75 0;1 0.6875 0;1 0.625 0;1 0.5625 0;1 0.5 0;1 0.4375 0;1 0.375 0;1 0.3125 0;1 0.25 0;1 0.1875 0;1 0.125 0;1 0.0625 0;1 0 0;0.9375 0 0;0.875 0 0;0.8125 0 0;0.75 0 0;0.6875 0 0;0.625 0 0;0.5625 0 0],...
    'DoubleBuffer','off',...
    'Name','ZEFFIRO-Brainstorm plugin',...
    'NumberTitle','off',...
    'HandleVisibility','callback',...
    'DeleteFcn','set(findobj(gcbo().Children,''Tag'',''run_button''),''UserData'',0);',...
    'Tag','zeffiro_bst_plugin',...
    'UserData',[],'ToolBar','none','MenuBar','none',...
    'WindowStyle',get(0,'defaultfigureWindowStyle'),...
    'Resize',get(0,'defaultfigureResize'),...
    'PaperPosition',get(0,'defaultfigurePaperPosition'),...
    'PaperSize',[20.99999864 29.69999902],...
    'PaperType',get(0,'defaultfigurePaperType'),...
    'InvertHardcopy',get(0,'defaultfigureInvertHardcopy'),...
    'ScreenPixelsPerInchMode','manual' );

addprop(h_fig,'user_settings');
set(h_fig,'user_settings',zef_bst);

file_name = 'zef_bst_default.m';
settings_subfolder_name = fullfile('+utilities', '+brainstorm2zef', '+settings');
project_subfolder_name = fullfile('+utilities', '+brainstorm2zef', 'projects');

run_script_list = dir([folder_name filesep '+utilities' filesep '+brainstorm2zef' filesep '+m' filesep '+run_script_bank']);
run_script_list = {run_script_list().name}'; 
run_script_list = run_script_list(3:end);

for i = 1 : length(run_script_list)
[~,name_string] = fileparts(run_script_list{i});
run_script_list{i} = name_string;
end

popmenu_1_value = find(ismember(run_script_list,'zef_bst_default_fem_mesh_create'),1);

h_popmenu_1 = uicontrol('Style','popupmenu','Parent',h_fig,'Visible','on','Units','normalized','Position',[0.40 0.365 0.55 0.1],'String',run_script_list,'Tag','run_script');
h_popmenu_2 = uicontrol('Style','popupmenu','Parent',h_fig,'Visible','on','Units','normalized','Position',[0.625 0.22 0.325 0.1],'String',{'Fresh start','Import compartments','Use project'},'Tag','run_type');
h_popmenu_3 = uicontrol('Style','popupmenu','Parent',h_fig,'Visible','on','Units','normalized','Position',[0.375 0.77 0.25 0.15],'String',{'Use input files','Ignore input files'},'Tag','input_mode');

h_popmenu_1.Value = popmenu_1_value;

h_button_1 = uicontrol('Style','pushbutton','Parent',h_fig,'Visible','on','Units','normalized','Position',[0.70 0.80 0.25 0.15],'String','Settings file','Callback','utilities.brainstorm2zef.m.zef_bst_settings_file;');
h_button_3 = uicontrol('Style','pushbutton','Parent',h_fig,'Visible','on','Units','normalized','Position',[0.375 0.05 0.25 0.15],'String','Create project','Callback','utilities.brainstorm2zef.m.zef_bst_create_project(utilities.brainstorm2zef.m.zef_bst_get_settings_file_name,utilities.brainstorm2zef.m.zef_bst_get_project_file_name,utilities.brainstorm2zef.m.zef_bst_get_run_type,utilities.brainstorm2zef.m.zef_bst_get_input_mode,get(get(gcbo,''Parent''),''user_settings''));');
h_button_4 = uicontrol('Style','pushbutton','Parent',h_fig,'Visible','on','Units','normalized','Position',[0.05 0.20 0.25 0.15],'String','Edit project','Callback','utilities.brainstorm2zef.m.zef_bst_edit_project(utilities.brainstorm2zef.m.zef_bst_get_project_file_name);');
h_button_5 = uicontrol('Style','pushbutton','Parent',h_fig,'Visible','on','Units','normalized','Position',[0.05 0.05 0.25 0.15],'String','Edit settings','Callback','edit(utilities.brainstorm2zef.m.zef_bst_get_settings_file_name);');
h_button_7 = uicontrol('Style','pushbutton','Parent',h_fig,'Visible','on','Units','normalized','Position',[0.70 0.05 0.25 0.15],'String','Run','Callback','set(gcbo,''UserData'',1);','Tag','run_button');

h_text_1 = uicontrol('Style','text','Parent',h_fig,'Units','normalized','String',file_name,'HorizontalAlignment','left','Position',[0.40 0.70 0.55 0.1],'BackgroundColor',[0.9 0.9 0.9],'Tag','settings_file');
h_text_2 = uicontrol('Style','text','Parent',h_fig,'Units','normalized','String',folder_name,'HorizontalAlignment','left','Position',[0.40 0.50 0.55 0.2],'BackgroundColor',[0.9 0.9 0.9],'Tag','toolbox_path');
h_text_3 = uicontrol('Style','text','Parent',h_fig,'Units','normalized','String','Run script:','HorizontalAlignment','left','Position',[0.05 0.365 0.35 0.1],'BackgroundColor',[0.94 0.94 0.94]);
h_text_4 = uicontrol('Style','text','Parent',h_fig,'Units','normalized','String','Settings file:','HorizontalAlignment','left','Position',[0.05 0.70 0.35 0.1],'BackgroundColor',[0.94 0.94 0.94]);
h_text_5 = uicontrol('Style','text','Parent',h_fig,'Units','normalized','String','Toolbox path:','HorizontalAlignment','left','Position',[0.05 0.60 0.35 0.1],'BackgroundColor',[0.94 0.94 0.94]);
h_text_6 = uicontrol('Style','text','Parent',h_fig,'Units','normalized','String','Run type:','HorizontalAlignment','left','Position',[0.375 0.22 0.25 0.1],'BackgroundColor',[0.94 0.94 0.94]);

h_axes = uiaxes('Parent',h_fig,'visible','on','Units','normalized','Position',[0.05 0.80 0.30 0.16],'FontSize',0.587962962962963,'Tag','image_axes','BackgroundColor',[0.94 0.94 0.94],'Visible','off');
imagesc(h_axes,imread(fullfile(folder_name, 'fig', 'zeffiro_logo.png'), 'BackgroundColor', [0.94 0.94 0.94]));

addprop(h_fig,'settings_file_name');
set(h_fig,'settings_file_name',file_name);

addprop(h_fig,'folder_name');
set(h_fig,'folder_name',folder_name);

addprop(h_fig,'settings_subfolder_name');
set(h_fig,'settings_subfolder_name',settings_subfolder_name);

addprop(h_fig,'project_subfolder_name');
set(h_fig,'project_subfolder_name',project_subfolder_name);

%addprop(h_button_7,'run_script');
set(h_button_7,'UserData',-1);

if open_dialog
waitfor(h_button_7,'UserData');
else 
set(h_button_7,'UserData',1);
end

set(h_fig,'DeleteFcn','closereq;')
set(h_fig,'CloseRequestFcn','closereq;')

callback_1 = sprintf(['%s(%d,%d,utilities.brainstorm2zef.m.zef_bst_get_settings_file_name(h_fig),utilities.brainstorm2zef.m.zef_bst_get_project_file_name(h_fig),zef_bst);'],['utilities.brainstorm2zef.m.run_script_bank.' h_popmenu_1.String{h_popmenu_1.Value}],h_popmenu_2.Value,h_popmenu_3.Value);
callback_2 = sprintf(['%s(%d,%d,utilities.brainstorm2zef.m.zef_bst_get_settings_file_name(h_fig),utilities.brainstorm2zef.m.zef_bst_get_project_file_name(h_fig),zef_bst);'],['utilities.brainstorm2zef.m.run_script_bank.' h_popmenu_1.String{h_popmenu_1.Value}],0,0);

if get(h_button_7,'UserData')
varargout = eval(callback_1);
else
varargout = eval(callback_2);
end

closereq;

end

