function slider_value_new = zef_update_colorscale_max

slider_value_old = evalin('base','zef.colorscale_max_slider');
slider_value_new = evalin('base','zef.h_colorscale_max_slider.Value');
clim_vec = evalin('base','zef.h_axes1.CLim');
clim_vec(2) = clim_vec(2)/10^(slider_value_old);
clim_vec(2) = clim_vec(2)/10^(slider_value_new);

evalin('base',['zef.h_axes1.CLim = [' num2str(clim_vec) ' ];']);

end