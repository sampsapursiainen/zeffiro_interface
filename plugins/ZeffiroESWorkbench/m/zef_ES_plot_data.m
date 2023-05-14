function zef_ES_plot_data(varargin)
if nargin == 0
    zef = evalin('base','zef');
else
    zef = varargin{1};
end

switch zef.ES_plot_type
    case 1
        zef_ES_plot_current_pattern(zef);
    case 2
        zef_ES_plot_barplot(zef);
    case 3
        zef_ES_plot_error_chart(zef);
    case 4
        zef_ES_optimizer_properties_show(zef);
    case 5
        zef_ES_plot_distance_curves;
end
end