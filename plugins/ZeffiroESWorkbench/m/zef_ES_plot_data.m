n = evalin('base','zef.ES_plot_type');
switch n
    case 1
        zef.h_current_ES = zef_ES_plot_current_pattern;
    case 2
        zef.h_barplot_ES = zef_ES_plot_barplot;
    case 3
        zef.h_colorbar_ES = zef_ES_plot_error_chart;
end
clear n