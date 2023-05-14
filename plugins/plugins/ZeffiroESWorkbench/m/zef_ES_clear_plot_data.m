function zef = zef_ES_clear_plot_data(zef)

if nargin == 0 
zef = eval('zef');
end

switch eval('zef.ES_plot_type');
    case 1
        if isfield(eval('zef'),'h_current_ES')
            delete(zef.h_current_ES)
            zef = rmfield(zef,'h_current_ES');
        end
    case 2
        if isfield(eval('zef'),'h_barplot_ES')
            delete(zef.h_barplot_ES)
            zef = rmfield(zef,'h_barplot_ES');
            close(gcf);
        end
    case 3
        if isfield(eval('zef'),'h_colorbar_ES')
            delete(zef.h_colorbar_ES)
            zef = rmfield(zef,'h_colorbar_ES');
            close(gcf);
        end
end

if nargout == 0
    assignin('base','zef',zef);
end

end
