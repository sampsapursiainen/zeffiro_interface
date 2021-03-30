if zef.ES_plot_type == 1
    zef.h_current_ES = zef_ES_plot_current_pattern;
elseif zef.ES_plot_type == 2
    zef.h_barplot_ES = zef_ES_plot_barplot;
elseif zef.ES_plot_type == 3
    if exist('zef','var') && isfield(zef,'y_ES_interval')
        zef.h_colorbar_ES = zef_ES_plot_error_chart;
    end
end