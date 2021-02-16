function [h_barplot_ES] = zef_ES_plot_barplot
f = figure(200);
set(f,'Name','ZEFFIRO Interface: Electrode potentials tool')
set(f,'NumberTitle','off');
set(f,'ToolBar','figure');
set(f,'MenuBar','none');

if isfield(evalin('base','zef'),'h_barplot_ES')
    h_synth_source = evalin('base','zef.h_barplot_ES');
    if ishandle(h_synth_source)
        delete(h_synth_source)
    end
end

h_barplot_ES = findobj(evalin('base','zef.h_zeffiro'),'tag','ES_barplot');
if not(isempty(h_barplot_ES))
    colorbar(h_barplot_ES,'delete');        
end

if evalin('base','zef.ES_search_type') == 1
    if evalin('base','zef.ES_current_threshold_checkbox') == 0
        y_ES = evalin('base','zef.y_ES');
    else
        y_ES = evalin('base','zef.y_ES_threshold');
    end
end
h_axes = gca;

h_barplot_ES = bar(y_ES,0.7); % Display in Ampere
set(h_barplot_ES,'tag','ES_barplot');
set(h_barplot_ES,'FaceColor', '[0.3 0.3 0.3]');
set(h_barplot_ES,'LineWidth', 0.5);
set(get(gca,'XLabel'),'string','Electrode Channel');
set(get(gca,'YLabel'),'string','Ampere (A)');
set(gca,'XGrid','on');
set(gca,'YGrid','on');
set(gca,'XLim',[0 129]);
p_max = max(y_ES*1.15);
p_min = -p_max;
set(gca,'YLim',[p_min p_max]*1.15);

max_current = evalin('base','zef.ES_maximum_current');
hold on;
plot(xlim,[ max_current  max_current],'LineWidth',0.5,'Color','r','LineStyle','--');
plot(xlim,[-max_current -max_current],'LineWidth',0.5,'Color','r','LineStyle','--');
hold off;

h_barplot_ES = [h_axes; h_barplot_ES];
end