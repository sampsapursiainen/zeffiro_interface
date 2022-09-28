
function h_waitbar = zef_waitbar(varargin)

    h_zeffiro_menu = findall(groot,'ZefTool','zef_menu_tool');

    if h_zeffiro_menu.ZefUseWaitbar

        if not(exist('h_waitbar','var'))

            h_waitbar = findall(groot,'-property','ZefWaitbarStartTime');

            if not(isempty(h_waitbar))

                if isvalid(h_waitbar)

                    h_waitbar = h_waitbar(1);

                else

                    h_waitbar = [];

                end

            end

        end

        % Set our plan of action. Start by setting constants.

        INITIALIZING = "{{initializing}}";
        PROGRESSING = "{{progressing}}";
        PROGRESSING_WITH_CHANGED_TEXT = "{{progressing with text}}";

        if nargin == 2

            second = varargin{2};

            if isa(second, "matlab.graphics.Graphics")

                if isvalid(second)

                plan_of_action = PROGRESSING;

                else

                    plan_of_action = INITIALIZING;

                end

            elseif isa(second, "string") || isa(second, "char")

                plan_of_action = INITIALIZING;

            else

                error("Got 2 arguments but second one was neither a string nor a figure that could be updated. Aborting...");

            end

        elseif nargin == 3 && ( isa(varargin{3}, "string") || isa(varargin{3}, "char") )

            if isvalid(varargin{2})

                plan_of_action = PROGRESSING_WITH_CHANGED_TEXT;

            else

                plan_of_action = INITIALIZING;

            end

        else

            error("zef_waitbar received more or less arguments than it wants to handle: 2 or 3 needed.")

        end

        if isempty(h_zeffiro_menu)

            if plan_of_action == INITIALIZING

                h_waitbar = init_figure([0.375 0.35 0.2 0.2], 0, -1, h_waitbar);

                addprop(h_waitbar,'ZefWaitbarStartTime');
                addprop(h_waitbar,'ZefWaitbarCurrentProgress');

                h_waitbar.ZefWaitbarStartTime = now;

            elseif plan_of_action == PROGRESSING

                h_waitbar = varargin{2};

            elseif plan_of_action == PROGRESSING_WITH_CHANGED_TEXT ...

                h_waitbar = varargin{2};


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
        progress_value = varargin{1};
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

            h_zeffiro_menu.ZefTaskId = h_zeffiro_menu.ZefTaskId + 1;

            empty_fig = figure('Visible', false);

            addprop(empty_fig, 'ZefWaitbarStartTime');
            addprop(empty_fig,'ZefWaitbarCurrentProgress');

            empty_fig.ZefWaitbarStartTime = now;
empty_fig.ZefWaitbarCurrentProgress = [];
            
            h_waitbar = init_figure(position_vec, visible_value, task_id, empty_fig);

            caller_file_name = {dbstack(1).file};

            if isempty(caller_file_name)

                caller_file_name = 'no caller file';

            else

                caller_file_name = caller_file_name{1};

            end

            progress_bar_text = varargin{end};

        elseif plan_of_action == PROGRESSING

            h_waitbar = varargin{2};

            h_text = findobj(h_waitbar.Children,'Tag','progress_bar_text');

            h_text_ready = findobj(h_waitbar.Children,'Tag','progress_bar_ready_text');

            progress_bar_text = h_text.String;

            progress_bar_ready_text = h_text_ready.String;

        elseif plan_of_action == PROGRESSING_WITH_CHANGED_TEXT

            h_waitbar = varargin{2};

            progress_bar_text = varargin{end};

        else

            error("zef_waitbar encountered an invalid plan of action. You gave the wrong number of arguments in the wrong order")

        end

        % Create bar elements on first run.

        if plan_of_action == INITIALIZING

            h_waitbar.UserData = [cputime now*86400 now*86400];

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

            if progress_value(1) > 0

                progress_bar_ready_text = datestr(now + ((1-progress_value(end))/progress_value(end))*(now - h_waitbar.ZefWaitbarStartTime));

                h_text_ready.String = ['Ready: ' progress_bar_ready_text];

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

            output_line = ['Task ID; ' num2str(task_id) '; Progress; ' num2str(round(100*progress_value(:)')) '; File; ' caller_file_name '; Message; ' progress_bar_text '; Workspace size; ' num2str(var_1) '; Task time; ' num2str(var_2) '; CPU usage; ' num2str(var_3) '; Ready; ' progress_bar_ready_text 'Total time; ' sprintf('%15.10f',restart_time) ';'];

            if use_log

                fprintf(fid,'%s',[output_line newline]);

            end

            if and(verbose_mode,not(visible_value))

                disp(output_line)

            end

        end % if

        fclose(fid);

    else

        h_waitbar = [];

    end % if

end % function

%% Local helper functions.

function fig = init_figure(position, visible, task_id, fig)

    %
    % init_figure
    %
    % Initializes a figure on the first run of zef_waitbar.
    %
    % Inputs:
    %
    % - position
    %
    %   The position of the figure
    %
    % - visible
    %
    %   A boolean that indicates whether the figure is to be displayed or not.
    %
    % - task_id
    %
    %   The integer ID of a task whose progress the waitbar is displaying.
    %
    % - fig
    %
    %   A figure that is to be modified.
    %
    % Output:
    %
    % - fig
    %
    %   The initialized figure
    %

    arguments

        position (1,4) double { mustBeReal }

        visible (1,1) logical

        task_id (1,1) double { mustBeInteger }

        fig (1,1) matlab.ui.Figure

    end

    % If task ID is negative, do not print it.

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
            fig.ZefWaitbarCurrentProgress = [];

        end

    else

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
        fig.ZefWaitbarCurrentProgress = [];
        fig.CloseRequestFcn = 'set(gcbo,''Visible'',''off'');';
        fig.DeleteFcn = 'set(gcbo,''Visible'',''off'');';

    end

end % function
