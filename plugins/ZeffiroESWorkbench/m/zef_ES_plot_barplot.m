function zef_ES_plot_barplot(varargin)
switch nargin
    case 0
        [sr, sc] = zef_ES_objective_function(zef_ES_table);
        y_ES = evalin('base',['zef.y_ES_interval.y_ES{' num2str(sr) ',' num2str(sc) '}']);
    case 1
        if isvector(varargin{1})
            y_ES = varargin{1};
        else
            error('Inserted argument is not a vector.')
        end
    case 2
        [sr, sc] = deal(varargin{1:2});
        try
            y_ES = evalin('base',['zef.y_ES_interval.y_ES{' num2str(sr) ',' num2str(sc) '}']);
        catch
            error('No y_ES data found.')
        end
    case 3
        if isvector(varargin{1})
            y_ES = varargin{1};
        else
            error('Invalid y_ES data inserted. Not a vector.')
        end
        [sr, sc] = deal(varargin{2}, varargin{3});
    otherwise
        error('Too many input arguments.')
end

if nargin ~= 3
    fig_aux = figure('Name','ZEFFIRO Interface: ES electrode potentials','NumberTitle','off', ...
        'ToolBar','figure','MenuBar','none');
    try
        win_temp = findobj('type','figure','name','ZEFFIRO Interface: ES error chart');
        win_temp = get(win_temp(1),'Position');
    catch
        win_temp = [10 800 550 150];
    end
    fig_aux.Position(1) = win_temp(1)+win_temp(3);
    fig_aux.Position(2) = win_temp(2)+(win_temp(4)-fig_aux.Position(4));
    fig_aux.Position(3) = 750;
    fig_aux.Position(4) = 250;
    sgtitle(['[' num2str(sr) ',' num2str(sc) ']']);
end

h_barplot_ES = bar(y_ES,0.3);
h_barplot_ES.FaceColor = [0.3 0.3 0.3];
h_barplot_ES.LineWidth = 0.1;
pbaspect([4 1 1]);

h_axes = gca;
h_axes.XLabel.String = 'Electrode channel';
h_axes.XLabel.FontSize = 10;
h_axes.XLabel.FontWeight = 'bold';

h_axes.YLabel.String = 'Amplitude (mA)';
h_axes.YLabel.FontSize = 10;
h_axes.YLabel.FontWeight = 'bold';

h_axes.XGrid = 'off';
h_axes.YGrid = 'on';

max_current_montage = evalin('base','zef.ES_total_max_current');
max_current_channel = evalin('base','zef.ES_max_current_channel');

h_axes.XLim = [0 length(y_ES)];
% h_axes.YLim = [-max_current max_current]*1.05;

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


%h_barplot_ES = [h_axes; h_barplot_ES];
end