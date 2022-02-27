function slider_value_new = zef_update_transparency_sensor(varargin)

if not(isempty(varargin))
h_figure = varargin{1};
else
   h_figure = evalin('base','zef.h_zeffiro');
end

h = findobj(get(h_figure,'Children'),'Tag','axes1');
h_object = findobj(get(h_figure,'Children'),'Tag','transparency_sensor_slider');
if isempty(h_object)
h_figure = evalin('base','zef.h_zeffiro');
h_object = findobj(get(h_figure,'Children'),'Tag','transparency_sensor_slider');
end

slider_value_new = h_object.Value;

h = findobj(h,'Tag','sensor');

kappa = 1.05.^(-100*(slider_value_new));

for i = 1 : length(h)

h(i).FaceAlpha = min(1,kappa);

end

end