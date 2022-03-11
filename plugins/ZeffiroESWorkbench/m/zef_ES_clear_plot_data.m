switch evalin('base','zef.ES_plot_type');
    case 1
        if isfield(evalin('base','zef'),'h_current_ES')
            delete(zef.h_current_ES)
            zef = rmfield(zef,'h_current_ES');
        end
    case 2
        if isfield(evalin('base','zef'),'h_barplot_ES')
            delete(zef.h_barplot_ES)
            zef = rmfield(zef,'h_barplot_ES');
            close(gcf);
        end
    case 3
        if isfield(evalin('base','zef'),'h_colorbar_ES')
            delete(zef.h_colorbar_ES)
            zef = rmfield(zef,'h_colorbar_ES');
            close(gcf);
        end
end
