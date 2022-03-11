function brightness_val = zef_update_brightness(varargin)

slider_value_new = evalin('base','zef.h_update_brightness.Value');

if not(isempty(varargin))
   h = varargin{1};
else
    h = evalin('base','zef.h_axes1');
end

if not(isempty(varargin))
if length(varargin) > 1
slider_value_new = varargin{1};
end
end

brightness_val = slider_value_new;

contrast_val = evalin('base','zef.update_contrast');

colormap_ind = evalin('base','zef.h_update_colormap.Value');

colormap_vec = zef_brightness_and_contrast(zef_colormap(colormap_ind), brightness_val, contrast_val);

h.Colormap = colormap_vec;

end
