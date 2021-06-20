function [h_barplot_ES] = zef_ES_plot_barplot(varargin)
n = length(varargin);
switch n
    case 0
        if evalin('base','zef.ES_search_type') == 1
            if evalin('base','zef.ES_current_threshold_checkbox') == 0
                y_ES = evalin('base','zef.y_ES_single.y_ES');
            else
                try
                    y_ES = evalin('base','zef.y_ES_single_threshold.y_ES');
                catch
                    error('Attempting to plot threshold values that have not yet been calculated.')
                end
            end
        elseif evalin('base','zef.ES_search_type') >= 2
            [star_row_idx, star_col_idx] = zef_ES_objective_function;
            if evalin('base','zef.ES_current_threshold_checkbox') == 0
                load_aux = evalin('base','zef.y_ES_interval.y_ES');
            else
                try
                    load_aux = evalin('base','zef.y_ES_interval_threshold');
                catch
                    error('Attempting to plot threshold values that have not yet been calculated.')
                end
            end
            y_ES = cell2mat(load_aux(star_row_idx, star_col_idx));
        end
    case 2
        [star_row_idx,star_col_idx] = varargin{:};
        if evalin('base','zef.ES_current_threshold_checkbox') == 0
            load_aux = evalin('base','zef.y_ES_interval.y_ES');
        else
            load_aux = evalin('base','zef.y_ES_interval_threshold.y_ES');
        end
        y_ES = cell2mat(load_aux(star_row_idx, star_col_idx));
    case 3
        if numel(varargin{1}) > 1
            y_ES = varargin{1};
        else
            error('Tis not a y_ES value!')
        end
        [~,star_row_idx,star_col_idx] = varargin{:};
    otherwise
        error('Too many input arguments declared. Insert 2, 3 or no argument at all.')
end

if n ~= 3
    f = figure('Name','ZEFFIRO Interface: Electrode potentials tool','NumberTitle','off', ...
        'ToolBar','figure','MenuBar','none');
        win_temp = findobj('type','figure','name','ZEFFIRO Interface: Error chart tool');
        win_temp = get(win_temp(1),'Position');
        f.Position(1) = win_temp(1)+win_temp(3);
        f.Position(2) = win_temp(2)+(win_temp(4)-f.Position(4));
        sgtitle(['[' num2str(star_row_idx) ',' num2str(star_col_idx) ']']);
end

h_axes = gca;
h_barplot_ES = bar(y_ES,0.7); % Display in Ampere
set(h_barplot_ES,'FaceColor', '[0.3 0.3 0.3]');
set(h_barplot_ES,'LineWidth', 0.1);
set(get(gca,'XLabel'),'string','Electrode Channel');
set(get(gca,'YLabel'),'string','Amplitude (mA)');
set(gca,'XGrid','on');
set(gca,'YGrid','on');
set(gca,'XLim',[0 129]);
if n == 0
    sgtitle(['[' num2str(star_row_idx) ',' num2str(star_col_idx) ']']);
end

if max(y_ES) == 0
    p_max = 1;
    p_min = 0;
else
    p_max = max(y_ES*1.15);
    p_min = -p_max;
end

max_current = evalin('base','zef.ES_maximum_current');
if p_max > max_current
    set(gca,'YLim',[p_min p_max]*1.15);
end
if not(isinf(max_current))
    hold on;
    plot(xlim,[ max_current  max_current],'LineWidth',0.5,'Color','r','LineStyle','--');
    plot(xlim,[-max_current -max_current],'LineWidth',0.5,'Color','r','LineStyle','--');
    hold off;
else
    hold on;
    plot(xlim,[ 0.002  0.002],'LineWidth',0.5,'Color','r','LineStyle','--');
    plot(xlim,[-0.002 -0.002],'LineWidth',0.5,'Color','r','LineStyle','--');
    hold off;
end

h_barplot_ES = [h_axes; h_barplot_ES];
end