function zef_reset_color_sliders

evalin('base','zef.colorscale_min_slider = 0;');
evalin('base','zef.colorscale_max_slider = 0;');
evalin('base','zef.h_colorscale_min_slider.Value = 0;');
evalin('base','zef.h_colorscale_max_slider.Value = 0;');

end
