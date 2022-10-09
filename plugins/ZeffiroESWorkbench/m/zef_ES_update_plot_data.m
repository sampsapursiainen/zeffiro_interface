function zef = zef_ES_update_plot_data(zef)

if nargin == 0
    zef = evalin('base','zef');
end

switch zef.ES_plot_type
    case 1
        [zef.h_current_ES, zef.h_current_coords] = zef_ES_plot_current_pattern(zef);
    case 2
                %switch evalin('base','zef.ES_search_type')
                 %   case 1
                  %      zef.h_barplot_ES = zef_ES_plot_barplot;
                   % case 2
                        [sr, sc] = zef_ES_objective_function(zef);
                        if isempty(sr)
                            sr = 1;
                        end
                        if isempty(sc)
                            sc = 1;
                        end
                        zef.h_barplot_ES = zef_ES_plot_barplot(zef);
              %  end

    case 3
        zef_ES_plot_error_chart(zef);
    case 4
        zef_ES_optimizer_properties_show(zef);
end
clear sr sc

if nargout == 0
assignin('base','zef',zef);
end

end