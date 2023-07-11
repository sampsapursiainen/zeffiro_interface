
function h_waitbar = zef_waitbar(varargin)
%
% zef_waitbar
%
% A function that either creates a new Zeffiro Interface waitbar with a
% certain title, updates an existing waitbar while keeping the title the same,
% or updates a waitbar while also updating the title.
%
% Inputs: a varargin cell array with either 3 or 4 elements:
%
% - varargin { 1 }
%
%   The current integer state of the progress, that the caller is keeping
%   track of.
%
% - varargin { 2 }
%
%   The ending integer progress state, that the caller is keeping track of. If
%   varargin{1} reaches this, the computation whose progress is being tracked
%   should terminate.
%
% - varargin { 3 }
%
%   If initializing a new waitbar, the textual title of the waitbar. If
%   updating an existing waitbar, a handle to the waitbar that is being
%   updated.
%
% - varargin { 4 }
%
%   If updating an existing waitbar with a new textual title, the title that
%   is to be shown by the updated waitbar.
%


if nargin < 3 || nargin > 4

    error("zef_waitbar needs 3 or 4 arguments")

end

current_iter = double ( varargin { 1 } ) ;

max_iter = double ( varargin { 2 } ) ;

assert ( isequal ( size ( current_iter ), size ( max_iter ) ), "The first and second arguments need to be integer arrays of equal size." ) ;

if any ( isnan ( current_iter ) ) || not ( all ( is_integer ( current_iter ) ) ) || not ( all ( current_iter >= 0 ) )

    error ( "The first argument must be a positive integer." ) ;

end

if any ( isnan ( max_iter ) ) || not ( all ( is_integer ( max_iter ) ) ) || not ( all ( max_iter >= current_iter ) )

    error ( "The second argument must be a positive integer, greater than the first argument." ) ;

end

progress_ratio = current_iter ./ max_iter ;

progress_threshold = ceil ( max_iter / 100 ) ;

% Set our plan of action. Start by setting constants.

INITIALIZING = "{{initializing}}";
PROGRESSING = "{{progressing}}";
PROGRESSING_WITH_CHANGED_TEXT = "{{progressing with text}}";

if nargin == 3

    third = varargin{3};

    if isa(third, "matlab.graphics.Graphics")

        if isvalid(third)
            h_waitbar = third ;
            plan_of_action = PROGRESSING;
            if abs(current_iter - varargin{3}.ZefWaitbarCurrentProgress) < progress_threshold
                return
            else
                varargin{3}.ZefWaitbarCurrentProgress = current_iter ;
            end

        else

            plan_of_action = INITIALIZING;

        end

    elseif isa(third, "string") || isa(third, "char")

        plan_of_action = INITIALIZING;

    else

        error("Got 2 arguments but third one was neither a string nor a figure that could be updated. Aborting...");

    end

elseif nargin == 4 && ( isa(varargin{4}, "string") || isa(varargin{4}, "char") )

    if isvalid(varargin{3})

        h_waitbar = varargin{3};

        plan_of_action = PROGRESSING_WITH_CHANGED_TEXT;

        if abs(current_iter - h_waitbar.ZefWaitbarCurrentProgress) < progress_threshold
            return
        else
            h_waitbar.ZefWaitbarCurrentProgress = current_iter ;
        end

    else

        plan_of_action = INITIALIZING;

    end

else

    error("zef_waitbar received more or less arguments than it wants to handle: 3 or 4 needed. The 4th argument should also be a string.")

end


h_zeffiro_menu = findall(groot,'ZefTool','zef_menu_tool');


if not(exist('h_waitbar','var'))

    h_waitbar = h_zeffiro_menu.ZefWaitbarHandle;

    if not(isempty(h_waitbar))

        if isvalid(h_waitbar)

            h_waitbar = h_waitbar(1);

        else

            h_waitbar = [];

        end

    end

end


if not(h_zeffiro_menu.ZefUseWaitbar)

    return;

end

if isempty(h_zeffiro_menu)

    if plan_of_action == INITIALIZING

        h_waitbar = init_figure([0.375 0.35 0.2 0.2], 0, -1, h_waitbar);
        h_zeffiro_menu.ZefWaitbarHandle = h_waitbar;

        h_waitbar.ZefWaitbarStartTime = now;

    elseif plan_of_action == PROGRESSING

        h_waitbar = varargin{3};

    elseif plan_of_action == PROGRESSING_WITH_CHANGED_TEXT ...

        h_waitbar = varargin{3};


        h_axes = axes(h_waitbar,'Position',[0.1 0.525 0.8 0.3]);
        h_axes.Visible = 'off';
        h_axes.Tag= 'progress_bar_main_axes';

        font_size = 10;

        set(findobj(h_waitbar.Children,'-property','FontUnits'),'FontUnits','pixels');
        set(findobj(h_waitbar.Children,'-property','FontSize'),'FontSize',font_size);

    else

        error("zef_waitbar encountered an invalid plan of action.")

    end

    return % early

end % if

position_vec_0 = h_zeffiro_menu.Position;
position_vec_1 = h_zeffiro_menu.ZefWaitbarSize;
s_h = zef_eval_entry(get(groot,'ScreenSize'),3);
s_v = zef_eval_entry(get(groot,'ScreenSize'),4);
position_vec_0([1 3]) = position_vec_0([1 3])/s_h;
position_vec_0([2 4]) = position_vec_0([2 4])/s_v;
position_vec_1(1) = position_vec_1(1)*position_vec_0(3);
position_vec_1(2) = position_vec_1(2)*position_vec_0(3)*s_h/s_v;

position_vec = [position_vec_0(1) position_vec_0(2)-position_vec_1(2) position_vec_1(1) position_vec_1(2)];

h_zeffiro_menu = h_zeffiro_menu(1);

log_frequency = 5;
first_step = 0;
progress_value = double ( progress_ratio );
progress_value = min(1,progress_value(:));
progress_value = max(0,progress_value(:));

visible_value = h_zeffiro_menu.Visible;
font_size = h_zeffiro_menu.ZefFontSize;
verbose_mode = h_zeffiro_menu.ZefVerboseMode;
use_waitbar = h_zeffiro_menu.ZefUseWaitbar;
use_log = h_zeffiro_menu.ZefUseLog;
current_log_file = h_zeffiro_menu.ZefCurrentLogFile;
task_id = h_zeffiro_menu.ZefTaskId;
restart_time = h_zeffiro_menu.ZefRestartTime;

if use_log

    fid = fopen(current_log_file,'a');

end

if not(use_waitbar)

    visible_value = 0;

end

% Choose whether to update and existing waitbar or an new one.

if plan_of_action == INITIALIZING

    first_step = 1;

    task_id = task_id + 1;

    h_waitbar = init_figure(position_vec, visible_value, task_id, h_waitbar);

    h_zeffiro_menu.ZefTaskId = h_zeffiro_menu.ZefTaskId + 1;

    h_waitbar.ZefWaitbarStartTime = now;

    h_zeffiro_menu.ZefWaitbarHandle = h_waitbar;

    caller_file_name = {dbstack(1).file};

    if isempty(caller_file_name)

        caller_file_name = 'no caller file';

    else

        caller_file_name = caller_file_name{1};

    end

    progress_bar_text = varargin{end};

elseif plan_of_action == PROGRESSING

    h_waitbar = varargin{3};

    h_text = findobj(h_waitbar.Children,'Tag','progress_bar_text');

    h_text_ready = findobj(h_waitbar.Children,'Tag','progress_bar_ready_text');

    progress_bar_text = h_text.String;

    progress_bar_ready_text = h_text_ready.String;

elseif plan_of_action == PROGRESSING_WITH_CHANGED_TEXT

    h_waitbar = varargin{3};

    progress_bar_text = varargin{end};

else

    error("zef_waitbar encountered an invalid plan of action. You gave the wrong number of arguments in the wrong order")

end

% Create bar elements on first run.

if plan_of_action == INITIALIZING

    initial_time = now * 86400 ;

    h_waitbar.UserData = [cputime initial_time initial_time];

    h_caller_file_name = uicontrol('Tag','caller_file_name','Style','text','FontWeight','bold','Parent',h_waitbar,'Units','normalized','String',caller_file_name,'HorizontalAlignment','center','Position',[0.1 0.78 0.8 0.15]);

    uicontrol('Tag','progress_bar_text','Style','text','Parent',h_waitbar,'Units','normalized','String',progress_bar_text,'HorizontalAlignment','center','Position',[0.1 0.70 0.8 0.15]);

    uicontrol('Tag','progress_bar_ready_text','Style','text','Parent',h_waitbar,'Units','normalized','String',progress_bar_text,'HorizontalAlignment','center','Position',[0.1 0.02 0.8 0.08]);

    uicontrol('Tag','auxiliary_text_1','Style','text','Parent',h_waitbar,'Units','normalized','String','Workspace size (MB)','HorizontalAlignment','center','Position',[0.15 0.1 0.2 0.15]);

    uicontrol('Tag','auxiliary_text_2','Style','text','Parent',h_waitbar,'Units','normalized','String','Time (s)','HorizontalAlignment','center','Position',[0.4 0.1 0.2 0.15]);

    uicontrol('Tag','auxiliary_text_3','Style','text','Parent',h_waitbar,'Units','normalized','String','CPU usage (%)','HorizontalAlignment','center','Position',[0.65 0.1 0.2 0.15]);

    font_size = h_zeffiro_menu.ZefFontSize;

    set(findobj(h_waitbar.Children,'-property','FontUnits'),'FontUnits','pixels');

    set(findobj(h_waitbar.Children,'-property','FontSize'),'FontSize',font_size);

end

% Either create or use existing axes.

if plan_of_action == INITIALIZING

    h_axes = axes(h_waitbar,'Position',[0.1 0.50 0.8 0.25]);
    h_axes_2 = axes(h_waitbar,'Position',[0.15 0.3 0.2 0.17]);
    h_axes_3 = axes(h_waitbar,'Position',[0.4 0.3 0.2 0.17]);
    h_axes_4 = axes(h_waitbar,'Position',[0.65 0.3 0.2 0.17]);

else

    h_axes = findobj(h_waitbar.Children,'Tag','progress_bar_main_axes');
    h_axes_2 = findobj(h_waitbar.Children,'Tag','progress_bar_auxiliary_axes_1');
    h_axes_3 = findobj(h_waitbar.Children,'Tag','progress_bar_auxiliary_axes_2');
    h_axes_4 = findobj(h_waitbar.Children,'Tag','progress_bar_auxiliary_axes_3');

end

h_text = findobj(h_waitbar.Children,'Tag','progress_bar_text');
h_text.String = progress_bar_text;

h_text_ready = findobj(h_waitbar.Children,'Tag','progress_bar_ready_text');

h_axes.Visible = 'off';
h_axes.Tag= 'progress_bar_main_axes';

h_axes_2.Visible = 'off';
h_axes_2.Tag= 'progress_bar_auxiliary_axes_1';

h_axes_3.Visible = 'off';
h_axes_3.Tag= 'progress_bar_auxiliary_axes_2';

h_axes_4.Visible = 'off';
h_axes_4.Tag= 'progress_bar_auxiliary_axes_3';


h_waitbar.Colormap = [[ 0 1 1]; [ 0.145   0.624    0.631]];

detail_condition = or((86400*now - h_waitbar.UserData(2)) >= log_frequency,first_step);

if detail_condition

    var_1 = evalin('caller','round(sum(cell2mat({whos().bytes}))/1E6)');
    var_1_max = 6;
    progress_value_1 = min(max(0,log10(var_1))/var_1_max,1);
    var_2 = round(86400*now - h_waitbar.UserData(3));
    var_2_max = 6;
    progress_value_2 = min(max(0,log10(var_2))/var_2_max,1);
    var_3 = round(100*(cputime - h_waitbar.UserData(1))/(now*86400 - h_waitbar.UserData(2)));
    var_3_max = 100*feature('numcores');
    h_waitbar.UserData(1:2) = [cputime now*86400];
    progress_value_3 = min(1,var_3/var_3_max);

    if progress_value(1) > 0



        time_in_seconds = now + ((1-progress_value(end))/progress_value(end))*(now - h_waitbar.ZefWaitbarStartTime) ;

        progress_bar_ready_text = datestr ( time_in_seconds );

    else

        progress_bar_ready_text = '';

        h_text_ready.String = [progress_bar_ready_text];

    end

end % if

if h_waitbar.Visible

    h_bar = barh(h_axes,[progress_value 1-progress_value; 0 0],'barlayout','stacked','showbaseline','off','edgecolor','none');

    h_bar(1).FaceColor = [ 0 1 1];
    h_bar(2).FaceColor = [ 0.145   0.624    0.631];
    h_axes.Visible = 'off';
    uistack(h_text,'top');
    uistack(h_text_ready,'top');

    if detail_condition

        caller_file_name = {dbstack(1).file};

        if isempty(caller_file_name)

            caller_file_name = 'no caller file';

        else

            caller_file_name = caller_file_name{1};

        end

        h_pie = pie(h_axes_2,[progress_value_1 1-progress_value_1]);
        h_axes_2.Visible = 'off';
        h_pie(2).String = num2str(var_1);
        h_pie(2).FontUnits = 'pixels';
        h_pie(2).FontSize = font_size;
        h_pie(4).String = '';
        h_pie(4).FontUnits = 'pixels';
        h_pie(4).FontSize = font_size;
        h_pie = pie(h_axes_3,[progress_value_2 1-progress_value_2]);
        h_axes_3.Visible = 'off';
        h_pie(2).String = num2str(var_2);
        h_pie(2).FontUnits = 'pixels';
        h_pie(2).FontSize = font_size;
        h_pie(4).String = '';
        h_pie(4).FontUnits = 'pixels';
        h_pie(4).FontSize = font_size;
        h_pie = pie(h_axes_4,[progress_value_3 1-progress_value_3]);
        h_axes_4.Visible = 'off';
        h_pie(2).String = num2str(var_3);
        h_pie(2).FontUnits = 'pixels';
        h_pie(2).FontSize = font_size;
        h_pie(4).String = '';
        h_pie(4).FontUnits = 'pixels';
        h_pie(4).FontSize = font_size;

    end % if

    pause(1e-6)

    h_axes.Tag= 'progress_bar_main_axes';
    h_axes_2.Tag= 'progress_bar_auxiliary_axes_1';
    h_axes_3.Tag= 'progress_bar_auxiliary_axes_2';
    h_axes_4.Tag= 'progress_bar_auxiliary_axes_3';
    h_text.Tag= 'progress_bar_text';
    h_text_ready.Tag= 'progress_bar_ready_text';
    h_waitbar.Tag ='progress_bar';

end % if

if detail_condition

    caller_file_name = {dbstack(1).file};

    if isempty(caller_file_name)

        caller_file_name = 'no caller file';

    else

        caller_file_name = caller_file_name{1};

    end

    h_caller_file_name.String = ['File: ' caller_file_name];

    output_line = ['Task ID; ' num2str(task_id) '; Progress; ' num2str(round(100*progress_value(:)')) '; File; ' caller_file_name '; Message; ' progress_bar_text '; Workspace size; ' num2str(var_1) '; Task time; ' num2str(var_2) '; CPU usage; ' num2str(var_3) '; Ready; ' progress_bar_ready_text '; Total CPU time; ' sprintf('%g',(cputime-restart_time)) ';'];

    if use_log

        fprintf(fid,'%s',[output_line newline]);

    end

    if and(verbose_mode,not(visible_value))

        disp(output_line)

    end

end % if

fclose(fid);

end % function

%% Local helper functions.

function fig = init_figure(position, visible, task_id, fig)

%Note: here it is difficult to define any class-based argument list,
%because it is absolutely necessary to distinguish between two cases (1) when
%fig is not a figure (when there is no figure yet) and (2) when it is a figure.
%The first incoming figure variable needs to be empty. Otherwise there will
%be confusion in deciding, whether there is a figure open or not.

if task_id < 0

    task_number_str = "";

else

    task_number_str = string(task_id);

end

if not(isempty(fig))

    if isvalid(fig)

        clf(fig);

        set(fig,...
            'PaperUnits',get(0,'defaultfigurePaperUnits'),...
            'Units','normalized',...
            'Position', position,...
            'Renderer',get(0,'defaultfigureRenderer'),...
            'Visible', visible,...
            'Color',get(0,'defaultfigureColor'),...
            'CurrentAxesMode','manual',...
            'IntegerHandle','off',...
            'NextPlot',get(0,'defaultfigureNextPlot'),...
            'DoubleBuffer','off',...
            'MenuBar','none',...
            'ToolBar','none',...
            'Name', "ZEFFIRO Interface: Task " + task_number_str,...
            'NumberTitle','off',...
            'HandleVisibility','off',...
            'Tag','progress_bar',...
            'UserData',[],...
            'WindowStyle',get(0,'defaultfigureWindowStyle'),...
            'Resize',get(0,'defaultfigureResize'),...
            'PaperPosition',get(0,'defaultfigurePaperPosition'),...
            'PaperSize',[20.99999864 29.69999902],...
            'PaperType',get(0,'defaultfigurePaperType'),...
            'InvertHardcopy',get(0,'defaultfigureInvertHardcopy'),...
            'ScreenPixelsPerInchMode','manual' ...
            );

        fig.CloseRequestFcn = 'set(gcbo,''Visible'',''off'');';
        fig.DeleteFcn = 'set(gcbo,''Visible'',''off'');';
        fig.ZefWaitbarStartTime = now;
        fig.ZefWaitbarCurrentProgress = 0;

    end

else

    zef_delete_waitbar;
    fig = figure( ...
        'PaperUnits',get(0,'defaultfigurePaperUnits'),...
        'Units','normalized',...
        'Position', position,...
        'Renderer',get(0,'defaultfigureRenderer'),...
        'Visible', visible,...
        'Color',get(0,'defaultfigureColor'),...
        'CurrentAxesMode','manual',...
        'IntegerHandle','off',...
        'NextPlot',get(0,'defaultfigureNextPlot'),...
        'DoubleBuffer','off',...
        'MenuBar','none',...
        'ToolBar','none',...
        'Name', "ZEFFIRO Interface: Task " + task_number_str,...
        'NumberTitle','off',...
        'HandleVisibility','off',...
        'Tag','progress_bar',...
        'UserData',[],...
        'WindowStyle',get(0,'defaultfigureWindowStyle'),...
        'Resize',get(0,'defaultfigureResize'),...
        'PaperPosition',get(0,'defaultfigurePaperPosition'),...
        'PaperSize',[20.99999864 29.69999902],...
        'PaperType',get(0,'defaultfigurePaperType'),...
        'InvertHardcopy',get(0,'defaultfigureInvertHardcopy'),...
        'ScreenPixelsPerInchMode','manual' ...
        );

    addprop(fig,'ZefWaitbarStartTime');
    addprop(fig,'ZefWaitbarCurrentProgress');
    fig.ZefWaitbarStartTime = now;
    fig.ZefWaitbarCurrentProgress = 0;
    fig.CloseRequestFcn = 'set(gcbo,''Visible'',''off'');';
    fig.DeleteFcn = 'set(gcbo,''Visible'',''off'');';

end % if

end % function

function result = is_integer(float)
%
% is_integer
%
% Checks whether a floating point number is an integer, up to the accuracy of
% machine epsilon eps.
%

    arguments

        float (:,:) double
    end

    result = float == round ( float ) ;

end % function
