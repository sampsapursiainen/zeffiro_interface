function zef_ES_plot_barplot(zef, varargin)
switch nargin
    case 0
        zef = evalin('base','zef');
    case 1
        [sr, sc] = zef_ES_objective_function(zef);
        y_ES = zef.y_ES_interval.y_ES{sr,sc};
    case 3
        if nargin >= 3
            vec = zef_ES_table(zef);
            y_ES = vec.("ES Channels"){varargin{2}, varargin{3}};
        end
    otherwise
        error('Too many input arguments.')
end
%% figure declaration and positioning
h_fig = figure('Name','ZEFFIRO Interface: ES electrode potentials', 'NumberTitle','off', ...
    'ToolBar','figure','MenuBar','none');
try
    win_temp = findall(groot,'-regexp','Name','ZEFFIRO Interface: Error chart*');
    win_temp = get(win_temp(1),'Position');
    h_fig.Position(1) = win_temp(1)+win_temp(3);
    h_fig.Position(2) = win_temp(2)+(win_temp(4)-h_fig.Position(4));
    h_fig.Position(3) = 750;
    h_fig.Position(4) = 250;
catch
    movegui(h_fig,'center')
end


%%
h_barplot_ES = bar(y_ES,0.3);
h_barplot_ES.FaceColor = [0.3 0.3 0.3];
h_barplot_ES.LineWidth = 0.1;
pbaspect([2 1 1]);

h_axes = gca;
h_axes.XLabel.String = 'Electrode channel';
h_axes.XLabel.FontSize = 10;
h_axes.XLabel.FontWeight = 'bold';

h_axes.YLabel.String = 'Amplitude (mA)';
h_axes.YLabel.FontSize = 10;
h_axes.YLabel.FontWeight = 'bold';

h_axes.XGrid = 'off';
h_axes.YGrid = 'on';

max_current_montage = zef.ES_total_max_current;
max_current_channel = zef.ES_max_current_channel;

h_axes.XLim = [0 length(y_ES)];
h_axes.YLim = [-max_current_channel max_current_channel]*1.05;

if max(abs(y_ES)) == 0
    p_max = 1;
    p_min = 0;
else
    p_max = max(abs(y_ES));
    p_min = -p_max;
end

if p_max > max_current_montage
    h_axes.YLim = [p_min p_max]*1.05;
else
    h_axes.YLim = [-max_current_montage max_current_montage]*1.05;
end

hold on;
plot(xlim,[ max_current_montage  max_current_montage],'LineWidth',1.0,'Color',[1 0 0],'LineStyle','--');
plot(xlim,[ max_current_channel  max_current_channel],'LineWidth',0.3,'Color',[1 0.3 0],'LineStyle','-.');
legend('Channel','Total Max','Channel Max','location','eastoutside','AutoUpdate','off');
plot(xlim,[-max_current_montage -max_current_montage],'LineWidth',1.0,'Color',[1 0 0],'LineStyle','--');
plot(xlim,[-max_current_channel -max_current_channel],'LineWidth',0.3,'Color',[1 0.3 0],'LineStyle','-.');
hold off;

h_fig.Visible = zef.use_display;

zef.h_ES_barplot = h_fig;
%h_barplot_ES = [h_axes; h_barplot_ES];
end