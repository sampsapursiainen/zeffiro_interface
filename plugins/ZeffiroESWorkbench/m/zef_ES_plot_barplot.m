function [h_barplot_ES] = zef_ES_plot_barplot(varargin)
n = length(varargin);
switch n
    case 0
        if evalin('base','zef.ES_search_method') ~= 3
            switch evalin('base','zef.ES_search_type')
                case 1
                    y_ES = evalin('base','zef.y_ES_single.y_ES');
                case 2
                    [~, sr, sc] = zef_ES_objective_function;
                    if isempty(sr)
                        sr = 1;
                    end
                    if isempty(sc)
                        sc = 1;
                    end
                    load_aux = evalin('base','zef.y_ES_interval.y_ES');
                    y_ES = cell2mat(load_aux(sr, sc));
            end
        else
            y_ES = evalin('base','zef.y_ES_4x1.y_ES');
        end

    case 2
        [sr, sc] = varargin{:};
        load_aux = evalin('base','zef.y_ES_interval.y_ES');
        y_ES = cell2mat(load_aux(sr, sc));
    case 3
        if numel(varargin{1}) > 1
            y_ES = varargin{1};
        else
            error('Tis not a y_ES value!')
        end
        [~, sr, sc] = varargin{:};
    otherwise
        error('Too many input arguments declared. Insert 2, 3 or no argument at all.')
end

if n ~= 3
    f = figure('Name','ZEFFIRO Interface: Electrode potentials tool','NumberTitle','off', ...
        'ToolBar','figure','MenuBar','none');
    try
        win_temp = findobj('type','figure','name','ZEFFIRO Interface: Error chart tool');
        win_temp = get(win_temp(1),'Position');
    catch
        win_temp = [10 800 570 413];
    end
    f.Position(1) = win_temp(1)+win_temp(3);
    f.Position(2) = win_temp(2)+(win_temp(4)-f.Position(4));
    f.Position(3) = 880;
    f.Position(4) = 500;

    if evalin('base','zef.ES_search_method') ~= 3
        sgtitle(['[' num2str(sr) ',' num2str(sc) ']']);
    else
        sgtitle(['4x1 using separation angle of ' num2str(evalin('base','zef.ES_separation_angle')) ' degrees'])
    end
end

h_barplot_ES = bar(y_ES,0.3);
h_barplot_ES.FaceColor = [0.3 0.3 0.3];
h_barplot_ES.LineWidth = 0.1;
pbaspect([4 1 1]);

h_axes = gca;
h_axes.XLabel.String = 'EEG Channel';
h_axes.XLabel.FontSize = 11;
h_axes.XLabel.FontWeight = 'bold';
h_axes.XLabel.FontName = 'Arial';

h_axes.YLabel.String = 'Amplitude (mA)';
h_axes.YLabel.FontSize = 11;
h_axes.YLabel.FontWeight = 'bold';
h_axes.YLabel.FontName = 'Arial';

h_axes.XGrid = 'off';
h_axes.YGrid = 'on';

max_current = evalin('base','zef.ES_solvermaximumcurrent');

h_axes.XLim = [0 length(y_ES)+1];
%h_axes.YLim = [-0.005 0.005];

if max(abs(y_ES)) == 0
    p_max = 1; p_min = 0;
else
    p_max = max(abs(y_ES)); p_min = -p_max;
end

if p_max > max_current
    h_axes.YLim = [p_min p_max]*1.05;
else
    h_axes.YLim = [-max_current max_current]*1.05;
end

hold on;
plot(xlim,[ max_current  max_current],'LineWidth',1.0,'Color','r','LineStyle','--');
plot(xlim,[-max_current -max_current],'LineWidth',1.0,'Color','r','LineStyle','--');
hold off;

h_barplot_ES = [h_axes; h_barplot_ES];
clear sr sc
end