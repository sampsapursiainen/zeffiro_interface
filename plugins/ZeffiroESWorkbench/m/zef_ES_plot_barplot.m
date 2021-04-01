function [h_barplot_ES] = zef_ES_plot_barplot
figure('Name','ZEFFIRO Interface: Electrode potentials tool','NumberTitle','off', ...
    'ToolBar','figure','MenuBar','none');

if evalin('base','zef.ES_search_type') == 1
    if evalin('base','zef.ES_current_threshold_checkbox') == 0
        y_ES = evalin('base','zef.y_ES_single.y_ES');
    else
        y_ES = evalin('base','zef.y_ES_single_threshold.y_ES');
    end
elseif evalin('base','zef.ES_search_type') == 2
    y_ES_aux = evalin('base','zef.y_ES_interval.y_ES');
    y_ES = cell2mat(y_ES_aux(1,1));
end

h_axes = gca;

h_barplot_ES = bar(y_ES,0.7); % Display in Ampere
set(h_barplot_ES,'FaceColor', '[0.3 0.3 0.3]');
set(h_barplot_ES,'LineWidth', 0.5);
set(get(gca,'XLabel'),'string','Electrode Channel');
set(get(gca,'YLabel'),'string','Ampere (A)');
set(gca,'XGrid','on');
set(gca,'YGrid','on');
set(gca,'XLim',[0 129]);

if max(y_ES) == 0
   p_max = 1; 
   p_min = 0;
else
    p_max = max(y_ES*1.15);
    p_min = -p_max;
end

set(gca,'YLim',[p_min p_max]*1.15);

max_current = evalin('base','zef.ES_maximum_current');
if not(isinf(max_current))
    hold on;
    plot(xlim,[ max_current  max_current],'LineWidth',0.5,'Color','r','LineStyle','--');
    plot(xlim,[-max_current -max_current],'LineWidth',0.5,'Color','r','LineStyle','--');
    hold off;
end

h_barplot_ES = [h_axes; h_barplot_ES];
end