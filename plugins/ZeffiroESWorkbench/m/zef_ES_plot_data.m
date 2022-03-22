switch evalin('base','zef.ES_plot_type');
    case 1
        zef.h_current_ES  = zef_ES_plot_current_pattern;
    case 2
        zef.h_barplot_ES  = zef_ES_plot_barplot;
    case 3
        zef.h_colorbar_ES = zef_ES_plot_error_chart;
    case 4
        zef_ES_optimizer_properties_show;
end
