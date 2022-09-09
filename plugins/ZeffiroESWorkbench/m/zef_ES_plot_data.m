switch evalin('base','zef.ES_plot_type')
    case 1
        [zef.h_current_ES, zef.h_current_coords] = zef_ES_plot_current_pattern;
    case 2
        zef_ES_plot_barplot;
    case 3
        zef_ES_plot_error_chart;
    case 4
        zef_ES_optimizer_properties_show;
    case 5
        zef_ES_plot_distance_curves;
end
clear sr sc