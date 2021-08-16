function slider_value_new = zef_update_colorscale_min(varargin)

slider_value_old = evalin('base','zef.colorscale_min_slider');
slider_value_new = evalin('base','zef.h_colorscale_min_slider.Value');

if not(isempty(varargin))
      h = varargin{1};
else
    h = evalin('base','zef.h_axes1');
end

if not(isempty(varargin))
if length(varargin) > 1
slider_value_old= varargin{2};
end
if length(varargin) > 1
slider_value_new = varargin{3};
end
end

clim_vec = h.CLim;

clim_vec(1) = clim_vec(1)/10^(slider_value_old);
clim_vec(1) = clim_vec(1)*10^(slider_value_new);

h.CLim = clim_vec;



end