if evalin('base','zef.ES_plot_type') == 1
    if isfield(zef,'h_current_ES')
        delete(zef.h_current_ES)
        zef = rmfield(zef,'h_current_ES');
    end
end
if evalin('base','zef.ES_plot_type') == 2 || evalin('base','zef.ES_plot_type') == 3
    if isfield(zef,'h_barplot_ES')
        delete(zef.h_barplot_ES)
        zef = rmfield(zef,'h_barplot_ES');
    elseif isfield(zef,'h_colorbar_ES')
        delete(zef.h_colorbar_ES)
        zef = rmfield(zef,'h_colorbar_ES');
    else
        close(gcf);
    end
end