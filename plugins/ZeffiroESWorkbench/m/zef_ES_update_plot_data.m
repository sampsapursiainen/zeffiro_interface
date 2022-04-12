switch evalin('base','zef.ES_plot_type')
    case 1
        try
            [zef.h_current_ES, zef.h_current_coords] = zef_ES_plot_current_pattern;
        catch ME
            error('No electrode values to plot...');
        end
    case 2
        switch evalin('base','zef.ES_search_method')
            case {1,2}
                [~, sr, sc] = zef_ES_objective_function;
                if isempty(sr)
                    sr = 1;
                end
                if isempty(sc)
                    sc = 1;
                end
                zef.h_barplot_ES = zef_ES_plot_barplot(sr, sc);      
            case 3
                zef.h_barplot_ES = zef_ES_plot_barplot;
        end
    case 3
        zef_ES_plot_error_chart;
    case 4
        zef_ES_optimizer_properties_show;
end
clear sr sc