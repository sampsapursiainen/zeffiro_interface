switch evalin('base','zef.ES_plot_type');
    case 1
        if zef.ES_update_plot_data
            try
                [zef.h_current_ES, zef.h_current_coords] = zef_ES_plot_current_pattern;
            catch ME
                warning('No electrode values to plot...');
                rethrow(ME)
            end
        else
            if isfield(evalin('base','zef'),'h_current_ES')
                delete(zef.h_current_ES)
                zef = rmfield(zef,'h_current_ES');
            end
        end
    case 2
        if zef.ES_update_plot_data
            [~, star_row_idx, star_col_idx] = zef_ES_objective_function;
            if isempty(star_row_idx)
                star_row_idx = 1;
            end
            if isempty(star_col_idx)
                star_col_idx = 1;
            end
            zef.h_barplot_ES = zef_ES_plot_barplot(star_row_idx, star_col_idx);
        else
            if get(gcf,'Name') == "ZEFFIRO Interface: Electrode potentials tool"
                close(gcf);
                if isfield(evalin('base','zef'),'h_barplot_ES')
                    delete(zef.h_barplot_ES)
                    zef = rmfield(zef,'h_barplot_ES');
                end
            end
        end
    case 3
        if zef.ES_update_plot_data
            zef_ES_plot_error_chart;
        else
            if get(gcf,'Name') == "ZEFFIRO Interface: Error chart tool"
                close(gcf);
                if isfield(evalin('base','zef'),'h_colorbar_ES')
                    delete(zef.h_colorbar_ES)
                    zef = rmfield(zef,'h_colorbar_ES');
                end
            end
        end
        
         case 4
              zef_ES_optimizer_properties_show;
end
clear x y