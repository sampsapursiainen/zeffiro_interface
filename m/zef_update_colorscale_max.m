function slider_value_new = zef_update_colorscale_max(varargin)

if not(isempty(varargin))
h_figure = varargin{1};
else
h_figure = evalin('base','zef.h_zeffiro');
end

h = findobj(get(h_figure,'Children'),'Tag','axes1');
h_object = findobj(get(h_figure,'Children'),'Tag','colorscale_max_slider');
if isempty(h_object)
h_figure = evalin('base','zef.h_zeffiro');
h_object = findobj(get(h_figure,'Children'),'Tag','colorscale_max_slider');
end

slider_value_new = h_object.Value;

if isempty(h_object.UserData)
    slider_value_old = 0;
else
    slider_value_old = h_object.UserData;
end

h_object.UserData = slider_value_new;

clim_vec = h.CLim;
if length(slider_value_new) == 1
clim_vec(2) = clim_vec(2)*10^(slider_value_new - slider_value_old);
else
clim_vec(2) = clim_vec(2)*10^(slider_value_new - slider_value_old);
end

h.CLim = clim_vec;

end