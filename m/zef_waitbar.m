
function h_waitbar = zef_waitbar(varargin)

    h_zeffiro_menu = findall(groot,'-property','ZefSystemSettings');

    % Set our plan of action. Start by setting constants.

    INITIALIZING = "{{initializing}}";
    PROGRESSING = "{{progressing}}";
    PROGRESSING_WITH_CHANGED_TEXT = "{{progressing with text}}";

    if nargin == 2

        second = varargin{2};

        if isa(second, "matlab.graphics.Graphics")

            plan_of_action = PROGRESSING;

        elseif isa(second, "string") || isa(second, "char")

            plan_of_action = INITIALIZING;

        else

            error("Got 2 arguments but second one was neither a string nor a figure that could be updated. Aborting...");

        end

    elseif nargin == 3 && ( isa(varargin{3}, "string") || isa(varargin{3}, "char") )

        plan_of_action = PROGRESSING_WITH_CHANGED_TEXT;

    else

        error("zef_waitbar received more or less arguments than it wants to handle: 2 or 3 needed.")

    end

    if isempty(h_zeffiro_menu)

        if plan_of_action == INITIALIZING

            h_waitbar = init_figure([0.375 0.35 0.2 0.2], 1, -1);

            progress_bar_text = varargin{2};

        elseif plan_of_action == PROGRESSING

            h_waitbar = varargin{2};

            progress_bar_text = h_waitbar.Name;

        elseif plan_of_action == PROGRESSING_WITH_CHANGED_TEXT ...

            h_waitbar = varargin{2};

            progress_bar_text = varargin{3};

            h_axes = axes(h_waitbar,'Position',[0.1 0.525 0.8 0.3]);
            h_axes.Visible = 'off';
            h_axes.Tag= 'progress_bar_main_axes';

            % uicontrol('Tag','progress_bar_text_container','Style','text','Parent',h_waitbar,'Units','normalized','String',progress_bar_text,'HorizontalAlignment','center','Position',[0.1 0.7 0.8 0.15]);

            font_size = 12;

            set(findobj(h_waitbar.Children,'-property','FontUnits'),'FontUnits','pixels');
            set(findobj(h_waitbar.Children,'-property','FontSize'),'FontSize',font_size);

        else

            error("zef_waitbar encountered an invalid plan of action.")

        end

        return % early

    end

    h_zeffiro_menu = h_zeffiro_menu(1);

    log_frequency = 5;
    first_step = 0;
    progress_value = varargin{1};
    progress_value = min(1,progress_value(:));
    progress_value = max(0,progress_value(:));
    progress_bar_text = '';

    visible_value = h_zeffiro_menu.ZefSystemSettings.use_display;
    font_size = h_zeffiro_menu.ZefSystemSettings.font_size;
    verbose_mode = h_zeffiro_menu.ZefSystemSettings.zeffiro_verbose_mode;
    use_waitbar = h_zeffiro_menu.ZefSystemSettings.use_waitbar;
    use_log = h_zeffiro_menu.ZefSystemSettings.use_log;
    log_name = h_zeffiro_menu.ZefSystemSettings.zeffiro_log_file_name;
    current_log_file = h_zeffiro_menu.ZefCurrentLogFile;
    task_id = h_zeffiro_menu.ZefTaskId;
    restart_time = h_zeffiro_menu.ZefRestartTime;
    program_path = h_zeffiro_menu.ZefProgramPath;

    if use_log
        fid = fopen(current_log_file,'a');
    end

    if not(use_waitbar)
        visible_value = 0;
    end

    % Choose whether to update and existing waitbar or an new one.

    if plan_of_action == INITIALIZING

        h_waitbar = init_figure([0.375 0.35 0.2 0.2], 1, -1);

        progress_bar_text = varargin{2};

    elseif plan_of_action == PROGRESSING

        h_waitbar = varargin{2};

        h_text = findobj(h_waitbar.Children,'Tag','progress_bar_text');

        progress_bar_text = h_text.String;

    elseif plan_of_action == PROGRESSING_WITH_CHANGED_TEXT

        h_waitbar = varargin{2};

        progress_bar_text = varargin{3};

    else

        error("zef_waitbar encountered an invalid plan of action. You gave the wrong number of arguments in the wrong order")

    end

    % Update waitbar.

    first_step = 1;
    task_id = task_id + 1;
    h_zeffiro_menu.ZefTaskId = h_zeffiro_menu.ZefTaskId + 1;

    position_vec_0 = h_zeffiro_menu.Position;
    position_vec_1 = h_zeffiro_menu.ZefSystemSettings.segmentation_tool_default_position;
    screen_size = get(groot,'ScreenSize');
    position_vec_0([1 3]) = position_vec_0([1 3])/screen_size(3);
    position_vec_0([2 4]) = position_vec_0([2 4])/screen_size(4);
    position_vec_1([1 3]) = position_vec_1([1 3])/screen_size(3);
    position_vec_1([2 4]) = position_vec_1([2 4])/screen_size(4);

    position_vec = [position_vec_0(1) position_vec_0(2)-0.3*position_vec_1(4) 0.5*position_vec_1(3) 0.3*position_vec_1(4)];

    h_waitbar.UserData = [cputime now*86400 now*86400];

    % Create bar elements on first run.

    if plan_of_action == INITIALIZING

        uicontrol('Tag','progress_bar_text','Style','text','Parent',h_waitbar,'Units','normalized','String',progress_bar_text,'HorizontalAlignment','center','Position',[0.1 0.7 0.8 0.15]);
        uicontrol('Tag','auxiliary_text_1','Style','text','Parent',h_waitbar,'Units','normalized','String','Workspace size (MB)','HorizontalAlignment','center','Position',[0.15 0.05 0.2 0.15]);
        uicontrol('Tag','auxiliary_text_2','Style','text','Parent',h_waitbar,'Units','normalized','String','Time (s)','HorizontalAlignment','center','Position',[0.4 0.05 0.2 0.15]);
        uicontrol('Tag','auxiliary_text_3','Style','text','Parent',h_waitbar,'Units','normalized','String','CPU usage (%)','HorizontalAlignment','center','Position',[0.65 0.05 0.2 0.15]);

    end

    % Either create or use existing axes.

    if plan_of_action == INITIALIZING

        h_axes = axes(h_waitbar,'Position',[0.1 0.525 0.8 0.3]);
        h_axes_2 = axes(h_waitbar,'Position',[0.15 0.25 0.2 0.2]);
        h_axes_3 = axes(h_waitbar,'Position',[0.4 0.25 0.2 0.2]);
        h_axes_4 = axes(h_waitbar,'Position',[0.65 0.25 0.2 0.2]);

    else

        h_axes = findobj(h_waitbar.Children,'Tag','progress_bar_main_axes');
        h_axes_2 = findobj(h_waitbar.Children,'Tag','progress_bar_auxiliary_axes_1');
        h_axes_3 = findobj(h_waitbar.Children,'Tag','progress_bar_auxiliary_axes_2');
        h_axes_4 = findobj(h_waitbar.Children,'Tag','progress_bar_auxiliary_axes_3');

    end

    h_text = findobj(h_waitbar.Children,'Tag','progress_bar_text');
    h_text.String = progress_bar_text;

    h_axes.Visible = 'off';
    h_axes.Tag= 'progress_bar_main_axes';

    h_axes_2.Visible = 'off';
    h_axes_2.Tag= 'progress_bar_auxiliary_axes_1';

    h_axes_3.Visible = 'off';
    h_axes_3.Tag= 'progress_bar_auxiliary_axes_2';

    h_axes_4.Visible = 'off';
    h_axes_4.Tag= 'progress_bar_auxiliary_axes_3';

    h_waitbar.Colormap = [[ 0 1 1]; [ 0.145   0.624    0.631]];

    detail_condition =or((86400*now - h_waitbar.UserData(2)) >= log_frequency,first_step);

    if detail_condition

        var_1 = evalin('caller','round(sum(cell2mat({whos().bytes}))/1E6)');
        var_1_max = 6;
        progress_value_1 = min(max(0,log10(var_1))/var_1_max,1);
        var_2 = round(86400*now - h_waitbar.UserData(3));
        var_2_max = 6;
        progress_value_2 = min(max(0,log10(var_2))/var_2_max,1);
        var_3 = round(100*(cputime - h_waitbar.UserData(1))/(86400*now - h_waitbar.UserData(2)));
        var_3_max = 100*feature('numcores');
        h_waitbar.UserData(1:2) = [cputime now*86400];
        progress_value_3 = min(1,var_3/var_3_max);

    end

    if h_waitbar.Visible

        h_bar = barh(h_axes,[progress_value 1-progress_value; 0 0],'barlayout','stacked','showbaseline','off','edgecolor','none');

        h_bar(1).FaceColor = [ 0 1 1];
        h_bar(2).FaceColor = [ 0.145   0.624    0.631];
        h_axes.Visible = 'off';
        uistack(h_text,'top');

        if detail_condition

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

        end

        pause(1e-6)

        h_axes.Tag= 'progress_bar_main_axes';
        h_axes_2.Tag= 'progress_bar_auxiliary_axes_1';
        h_axes_3.Tag= 'progress_bar_auxiliary_axes_2';
        h_axes_4.Tag= 'progress_bar_auxiliary_axes_3';
        h_text.Tag='progress_bar_text';
        h_waitbar.Tag ='progress_bar';

    end

    if detail_condition

        caller_file_name = {dbstack(1).file};

        if not(isempty(caller_file_name))
            caller_file_name = caller_file_name{1};
        else
            caller_file_name = 'no caller script';
        end

        output_line = ['Task ID; ' num2str(task_id) '; Progress; ' num2str(round(100*progress_value(:)')) '; File; ' caller_file_name '; Message; ' progress_bar_text '; Workspace size; ' num2str(var_1) '; Task time; ' num2str(var_2) '; CPU usage; ' num2str(var_3) '; Total time; ' num2str(restart_time) ';'];

        if use_log
            fprintf(fid,'%s',[output_line newline]);
        end

        if and(verbose_mode,not(visible_value))
          disp(output_line)
        end

    end

    fclose(fid);

end % function

%% Local helper functions.

function fig = init_figure(position, visible, task_id)

    arguments

        position (1,4) double { mustBeReal, mustBeNonnegative }

        visible (1,1) logical

        task_id (1,1) double { mustBeInteger }

    end

    % If task ID is negative, do not print it.

    if task_id < 0

        task_number_str = "";

    else

        task_number_str = string(task_id);

    end

    fig = figure( ...
        'PaperUnits',get(0,'defaultfigurePaperUnits'),...
        'Units','normalized',...
        'Position', position,...
        'Renderer',get(0,'defaultfigureRenderer'),...
        'Visible', visible,...
        'Color',get(0,'defaultfigureColor'),...
        'CloseRequestFcn','closereq;',...
        'CurrentAxesMode','manual',...
        'IntegerHandle','off',...
        'NextPlot',get(0,'defaultfigureNextPlot'),...
        'DoubleBuffer','off',...
        'MenuBar','none',...
        'ToolBar','none',...
        'Name', "ZEFFIRO Interface: Task " + task_number_str,...
        'NumberTitle','off',...
        'HandleVisibility','callback',...
        'DeleteFcn','delete(gcf);',...
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

end
