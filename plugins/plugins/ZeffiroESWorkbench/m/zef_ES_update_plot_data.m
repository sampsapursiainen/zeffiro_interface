function zef = zef_ES_update_plot_data(varargin)
if nargin == 0
    zef = evalin('base','zef');
else
    zef = varargin{1};
end

switch zef.ES_plot_type
    case 1
        [zef.h_current_ES, zef.h_current_coords] = zef_ES_plot_current_pattern;
    case 2
        zef_ES_plot_barplot;
    case 3
        zef_ES_plot_error_chart;
    case 4
        zef_ES_optimizer_properties_show(zef);
end

if nargout == 0
    assignin('base','zef',zef);
end

end