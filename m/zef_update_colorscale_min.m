function slider_value_new = zef_update_colorscale_min(varargin)

if not(isempty(varargin))
h_figure = varargin{1};
else
h_figure = evalin('base','zef.h_zeffiro');
end

h = findobj(get(h_figure,'Children'),'Tag','axes1');
h_object = findobj(get(h_figure,'Children'),'Tag','colorscale_min_slider');
if isempty(h_object)
h_figure = evalin('base','zef.h_zeffiro');
h_object = findobj(get(h_figure,'Children'),'Tag','colorscale_min_slider');
end

slider_value_new = h_object.Value;

if isempty(h_object.UserData)
    slider_value_old = 0;
else
    slider_value_old = h_object.UserData;
end

h_object.UserData = slider_value_new;

clim_vec = h.CLim;
clim_vec(1) = clim_vec(1)*10^(slider_value_new);
h.CLim = clim_vec;

end