function [contrast_val, brightness_val] = zef_update_contrast(varargin)

if not(isempty(varargin))
h_figure = varargin{1};
else
h_figure = evalin('base','zef.h_zeffiro');
end

h = findobj(get(h_figure,'Children'),'Tag','axes1');
h_object_1 = findobj(get(h_figure,'Children'),'Tag','update_contrast_slider');
h_object_2 = findobj(get(h_figure,'Children'),'Tag','update_brightness_slider');
h_object_3 = findobj(get(h_figure,'Children'),'Tag','colormapselection');
if isempty(h_object_1)
h_figure = evalin('base','zef.h_zeffiro');
h_object_1 = findobj(get(h_figure,'Children'),'Tag','update_contrast_slider');
h_object_2 = findobj(get(h_figure,'Children'),'Tag','update_brightness_slider');
h_object_3 = findobj(get(h_figure,'Children'),'Tag','colormapselection');
end

slider_value_new = h_object_1.Value;

contrast_val = slider_value_new;

brightness_val = h_object_2.Value;
colormap_ind = h_object_3.Value;

colormap_vec = zef_brightness_and_contrast(zef_colormap(colormap_ind), brightness_val, contrast_val);

h.Colormap = colormap_vec;

end
