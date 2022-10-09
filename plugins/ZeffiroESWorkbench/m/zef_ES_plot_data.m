function zef = zef_ES_plot_data(zef)

if nargin == 0
    zef = evalin('base','zef');
end

switch zef.ES_plot_type
    case 1
        [zef.h_current_ES, zef.h_current_coords] = zef_ES_plot_current_pattern(zef);
    case 2
        zef = zef_ES_plot_barplot(zef);
    case 3
        zef = zef_ES_plot_error_chart(zef);
    case 4
        zef = zef_ES_optimizer_properties_show(zef);
    case 5
       zef = zef_ES_plot_distance_curves(zef);
end
clear sr sc

if nargout == 0 
assignin('base','zef',zef);
end

end