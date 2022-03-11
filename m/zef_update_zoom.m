function kappa = zef_update_zoom(varargin)

if not(isempty(varargin))
h_figure = varargin{1};
else
h_figure = evalin('base','zef.h_zeffiro');
end

h = findobj(get(h_figure,'Children'),'Tag','axes1');
h_object = findobj(get(h_figure,'Children'),'Tag','update_zoom_slider');
if isempty(h_object)
h_figure = evalin('base','zef.h_zeffiro');
h_object = findobj(get(h_figure,'Children'),'Tag','update_zoom_slider');
end

kappa = h_object.Value;
h.CameraViewAngle = kappa;

end
