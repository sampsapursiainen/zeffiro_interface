
function h_waitbar = zef_waitbar(varargin)

log_frequency = 5;
first_step = 0;
progress_value = varargin{1};
progress_value = min(1,progress_value(:));
progress_value = max(0,progress_value(:));
progress_bar_text = '';

if evalin('caller','exist(''zef'',''var'')')
zef = evalin('caller','zef');
workspace_mode = 'caller';
elseif evalin('caller','exist(''zef'',''var'')')
 zef = evalin('base','zef');
 workspace_mode = 'base';
end

visible_value = zef.use_display;
font_size = zef.font_size;
verbose_mode = zef.zeffiro_verbose_mode;
use_waitbar = zef.use_waitbar;
task_id = zef.zeffiro_task_id + 1;
use_log = zef.use_log; 
log_name = zef.zeffiro_log_file_name;
program_path = zef.program_path; 
current_log_file = zef.current_log_file;

if use_log
fid = fopen(current_log_file,'a');
end

if not(use_waitbar)
    visible_value = 0;
end

if nargin == 3
    h_waitbar = varargin{2};
    if length(varargin)>2
     progress_bar_text = varargin{3};
    else
    h_text = findobj(h_waitbar.Children,'Tag','progress_bar_text');
    progress_bar_text = h_text.String;
    end
else
    if length(varargin) > 1
    progress_bar_text = varargin{2};
    end
    
    first_step = 1;
    if isequal(workspace_mode,'caller')
    evalin('caller','zef.zeffiro_task_id = zef.zeffiro_task_id + 1;');
    else 
   evalin('base','zef.zeffiro_task_id = zef.zeffiro_task_id + 1;');   
    end
    
h_waitbar = figure(...
'PaperUnits',get(0,'defaultfigurePaperUnits'),...
'Units','normalized',...
'Position',[0.375 0.35 0.2 0.2],...
'Renderer',get(0,'defaultfigureRenderer'),...
'Visible',visible_value,...
'Color',get(0,'defaultfigureColor'),...
'CloseRequestFcn','closereq;',...
'CurrentAxesMode','manual',...
'IntegerHandle','off',...
'NextPlot',get(0,'defaultfigureNextPlot'),...
'DoubleBuffer','off',...
'MenuBar','none',...
'ToolBar','none',...
'Name',['ZEFFIRO Interface: Task ' num2str(task_id)],...
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
'ScreenPixelsPerInchMode','manual' );

h_waitbar.UserData = [cputime now*86400 now*86400];


h_axes = axes(h_waitbar,'Position',[0.1 0.525 0.8 0.3]);
h_axes.Visible = 'off';
h_axes.Tag= 'progress_bar_main_axes';

uicontrol('Tag','progress_bar_text','Style','text','Parent',h_waitbar,'Units','normalized','String',progress_bar_text,'HorizontalAlignment','center','Position',[0.1 0.7 0.8 0.15]);
uicontrol('Tag','auxiliary_text_1','Style','text','Parent',h_waitbar,'Units','normalized','String','Workspace size (MB)','HorizontalAlignment','center','Position',[0.15 0.05 0.2 0.15]);
uicontrol('Tag','auxiliary_text_2','Style','text','Parent',h_waitbar,'Units','normalized','String','Time (s)','HorizontalAlignment','center','Position',[0.4 0.05 0.2 0.15]);
uicontrol('Tag','auxiliary_text_3','Style','text','Parent',h_waitbar,'Units','normalized','String','CPU usage (%)','HorizontalAlignment','center','Position',[0.65 0.05 0.2 0.15]);

h_axes_2 = axes(h_waitbar,'Position',[0.15 0.25 0.2 0.2]);
h_axes_2.Visible = 'off';
h_axes_2.Tag= 'progress_bar_auxiliary_axes_1';

h_axes_2 = axes(h_waitbar,'Position',[0.4 0.25 0.2 0.2]);
h_axes_2.Visible = 'off';
h_axes_2.Tag= 'progress_bar_auxiliary_axes_2';

h_axes_2 = axes(h_waitbar,'Position',[0.65 0.25 0.2 0.2]);
h_axes_2.Visible = 'off';
h_axes_2.Tag= 'progress_bar_auxiliary_axes_3';

h_waitbar.Colormap = [[ 0 1 1]; [ 0.145   0.624    0.631]];

end

 detail_condition =or((86400*now - h_waitbar.UserData(2)) >= log_frequency,first_step);

if detail_condition
    if isequal(workspace_mode,'caller')
 var_1 = evalin('caller','round(sum(cell2mat({whos().bytes}))/1E6)');
    else
        var_1 = evalin('base','round(sum(cell2mat({whos().bytes}))/1E6)');
    end
        
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

if isequal(h_waitbar.Visible,'on') || isequal(h_waitbar.Visible,1)

h_axes = findobj(h_waitbar.Children,'Tag','progress_bar_main_axes');
h_text = findobj(h_waitbar.Children,'Tag','progress_bar_text');
h_text.String = progress_bar_text;
h_bar = barh(h_axes,[progress_value 1-progress_value; 0 0],'barlayout','stacked','showbaseline','off','edgecolor','none');

h_bar(1).FaceColor = [ 0 1 1];
h_bar(2).FaceColor = [ 0.145   0.624    0.631];
h_axes.Visible = 'off';
uistack(h_text,'top');

if detail_condition

h_axes_2 = findobj(h_waitbar.Children,'Tag','progress_bar_auxiliary_axes_1');
h_axes_3 = findobj(h_waitbar.Children,'Tag','progress_bar_auxiliary_axes_2');
h_axes_4 = findobj(h_waitbar.Children,'Tag','progress_bar_auxiliary_axes_3');

h_pie = pie(h_axes_2,[progress_value_1 1-progress_value_1]);
h_axes_2.Visible = 'off';
h_pie(2).String = num2str(var_1); 
h_pie(4).String = '';
h_pie = pie(h_axes_3,[progress_value_2 1-progress_value_2]);
h_axes_3.Visible = 'off';
h_pie(2).String = num2str(var_2); 
h_pie(4).String = '';
h_pie = pie(h_axes_4,[progress_value_3 1-progress_value_3]);
h_axes_4.Visible = 'off';
h_pie(2).String = num2str(var_3);
h_pie(4).String = '';
end
pause(1e-6)

h_axes.Tag= 'progress_bar_main_axes';
h_axes_2.Tag= 'progress_bar_auxiliary_axes_1';
h_axes_3.Tag= 'progress_bar_auxiliary_axes_2';
h_axes_4.Tag= 'progress_bar_auxiliary_axes_3';
h_text.Tag='progress_bar_text';
h_waitbar.Tag ='progress_bar';

end

if not(ishandle(varargin{2}))

    set(findobj(h_waitbar.Children,'-property','FontUnits'),'FontUnits','pixels');
set(findobj(h_waitbar.Children,'-property','FontSize'),'FontSize',font_size);

for i = 1 : length(h_waitbar.Children)
    
    set(findobj(h_waitbar.Children(i).Children,'-property','FontUnits'),'FontUnits','pixels');
set(findobj(h_waitbar.Children(i).Children,'-property','FontSize'),'FontSize',font_size);

end
  
end
    
if detail_condition
caller_file_name = {dbstack(1).file};
caller_file_name = caller_file_name{1};
output_line = ['Task ID; ' num2str(task_id) '; Progress; ' num2str(round(100*progress_value(:)')) '; File; ' caller_file_name '; Message; ' progress_bar_text '; Workspace size; ' num2str(var_1) '; Task time; ' num2str(var_2) '; CPU usage; ' num2str(var_3) '; Total time; ' num2str(zef.zeffiro_restart_time) ';'];
if use_log
    fprintf(fid,'%s',[output_line newline]);
end

  if and(verbose_mode,not(visible_value))
    disp(output_line)
  end
  
end

fclose(fid);
    
end


