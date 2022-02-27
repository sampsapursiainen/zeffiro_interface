function contrast_val = zef_update_contrast(varargin)

slider_value_new = evalin('base','zef.h_update_contrast.Value');

if not(isempty(varargin))
      h = varargin{1};
else
    h = evalin('base','zef.h_axes1');
end

if not(isempty(varargin))
if length(varargin) > 1
slider_value_new = varargin{2};
end
end

contrast_val = slider_value_new;

brightness_val = evalin('base','zef.update_brightness');
colormap_ind = evalin('base','zef.h_update_colormap.Value');

colormap_vec = zef_brightness_and_contrast(zef_colormap(colormap_ind), brightness_val, contrast_val);

h.Colormap = colormap_vec;

end