function zef_ES_plot_barplot(varargin)
switch nargin
    case {0,1}
        if nargin == 0
            zef = evalin('base','zef');
            warning('ZI: No zef were called as an input argument.')
        else
            zef = varargin{1};
        end
        try
            [sr, sc] = zef_ES_objective_function(zef);
            y_ES = zef.y_ES_interval.y_ES{sr,sc};
        catch
            arg_aux = varargin{1};
            vec = zef_ES_table(arg_aux);
            zef = evalin('base','zef');
            warning('ZI: Missing objective functions. The variable ''zef'' has been called to fulfill the missing arguments.')
            [sr, sc] = zef_ES_objective_function(zef, arg_aux);
            y_ES = vec.("ES Channels"){1,1}{sr, sc};
        end
    case {2}
        zef = varargin{1};
        try
            vec = zef_ES_table(varargin{2});
            [sr, sc] = zef_ES_objective_function(zef, vec);
        catch
            vec = zef_ES_table(varargin{1});
            zef = varargin{2};
            warning('ZI: input1 and input2 arguments were added incorrectly. Re-declare input1 as input2 and vice-versa.')
            [sr, sc] = zef_ES_objective_function(zef, vec);
        end
        y_ES = vec.("ES Channels"){1,1}{sr, sc};
    case {3}
        try
            vec = zef_ES_table(varargin{1});
            zef = evalin('base','zef');
            warning('ZI: No zef were called as an input argument.')
            [sr, sc] = zef_ES_objective_function(zef, vec);
        catch
            vec = zef_ES_table(varargin{1}.y_ES_interval);
            [sr, sc] = zef_ES_objective_function(varargin{1}, zef_ES_table(varargin{1}.y_ES_interval));
        end
        y_ES = vec.("ES Channels"){1,1}{sr, sc};
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

h_fig.Position = [530         265        1458         420];
%%
h_barplot_ES = bar(y_ES, 0.3);
h_barplot_ES.FaceColor = [0.3 0.3 0.3];
h_barplot_ES.LineWidth = 0.1;
pbaspect([3 1 1]);

FontSize_aux = 16;

h_axes = gca;
h_axes.XLabel.String = 'Electrode channel';
h_axes.XLabel.FontSize = FontSize_aux;
h_axes.XLabel.FontWeight = 'bold';

h_axes.YLabel.String = 'Amplitude (mA)';
h_axes.YLabel.FontSize = FontSize_aux;
h_axes.YLabel.FontWeight = 'bold';

h_axes.XGrid = 'off';
h_axes.YGrid = 'on';

if exist('zef','var')
    max_current_montage = zef.ES_total_max_current;
    max_current_channel = zef.ES_max_current_channel;
else
    max_current_montage = 0.004;
    max_current_channel = 0.002;
end

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
    %h_axes.YLim = [-max_current_montage max_current_montage]*1.05;
    h_axes.YLim = [-max_current_channel max_current_channel]*1.05;
end

hold on;
%plot(xlim,[ max_current_montage  max_current_montage],'LineWidth',1.0,'Color',[1 0 0],'LineStyle','--');
plot(xlim,[ max_current_channel  max_current_channel],'LineWidth',0.3,'Color',[1 0 0],'LineStyle','--');
legend('Channel','Channel Max','location','eastoutside','AutoUpdate','off');
%plot(xlim,[-max_current_montage -max_current_montage],'LineWidth',1.0,'Color',[1 0 0],'LineStyle','--');
plot(xlim,[-max_current_channel -max_current_channel],'LineWidth',0.3,'Color',[1 0 0],'LineStyle','--');
hold off;

grid on;

if exist('zef','var')
    h_fig.Visible = zef.use_display;
    zef.h_ES_barplot = h_fig;
    %h_barplot_ES = [h_axes; h_barplot_ES];
end

end
