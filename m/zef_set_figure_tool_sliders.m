function zef_set_figure_tool_sliders(varargin)

set_mode = 1;

if not(isempty(varargin))
set_mode = varargin{1};
end

if evalin('base','isfield(zef,''h_axes1'');')
if isvalid(evalin('base','zef.h_axes1'))

if set_mode == 0

evalin('base','zef.h_update_colormap.Value = zef.inv_colormap;');
evalin('base','zef.h_update_colorscale.Value = 1;');
evalin('base','zef.h_update_zoom.Value = 7;');
evalin('base','zef.h_update_transparency_reconstruction.Value = 0;');
evalin('base','zef.h_update_transparency_surface.Value = 0;');
evalin('base','zef.h_update_transparency_sensor.Value = 0;');
evalin('base','zef.h_update_transparency_cones.Value = 0;');
evalin('base','zef.h_update_transparency_additional.Value = 0;');
evalin('base','zef.h_update_transparency_sensor.Value = 0;');
evalin('base','zef.h_update_transparency_cones.Value = 0;');
evalin('base','zef.h_update_transparency_additional.Value = 0;');
evalin('base','zef.h_update_brightness.Value = 0;');
evalin('base','zef.h_update_contrast.Value = 0;');
evalin('base','zef.h_update_ambience.Value = 0.8;');
evalin('base','zef.h_update_diffusion.Value = 0.8;');
evalin('base','zef.h_update_specular.Value = 0.1;');
evalin('base','zef.h_colorscale_min_slider.Value = 0;');
evalin('base','zef.h_colorscale_max_slider.Value = 0;');
evalin('base','zef.update_lights = 1; zef.h_update_lights.Value = 1;');

else

evalin('base','zef.h_update_colormap.Value = zef.update_colormap;');
evalin('base','zef.h_update_colorscale.Value = zef.update_colorscale;');
evalin('base','zef.h_update_zoom.Value = zef.update_zoom;');
evalin('base','zef.h_update_transparency_reconstruction.Value = zef.update_transparency_reconstruction;');
evalin('base','zef.h_update_transparency_surface.Value = zef.update_transparency_surface;');
evalin('base','zef.h_update_transparency_sensor.Value = zef.update_transparency_sensor;');
evalin('base','zef.h_update_transparency_cones.Value = zef.update_transparency_cones;');
evalin('base','zef.h_update_transparency_additional.Value = zef.update_transparency_additional;');
evalin('base','zef.h_update_transparency_sensor.Value = zef.update_transparency_sensor;');
evalin('base','zef.h_update_transparency_cones.Value = zef.update_transparency_cones;');
evalin('base','zef.h_update_transparency_additional.Value = zef.update_transparency_additional;');
evalin('base','[zef.h_update_contrast.Value, zef.h_update_brightness.Value] = zef_update_contrast_and_brightness;');
evalin('base','zef.h_update_ambience.Value =  zef.update_ambience;');
evalin('base','zef.h_update_diffusion.Value = zef.update_diffusion;');
evalin('base','zef.h_update_specular.Value = zef.update_specular;');
evalin('base','zef.h_colorscale_min_slider.Value = zef.colorscale_min_slider;');
evalin('base','zef.h_colorscale_max_slider.Value = zef.colorscale_max_slider;');

end

evalin('base','zef.update_colormap = zef.h_update_colormap.Value; zef.h_axes1.Colormap = zef_colormap(zef.h_update_colormap.Value);');
evalin('base','zef.update_colorscale = zef_update_colorscale;');
evalin('base','zef.update_ambience = zef_update_ambience;');
evalin('base','zef.update_diffusion = zef_update_diffusion;');
evalin('base','zef.update_specular = zef_update_specular;');
evalin('base','[zef.update_contrast, zef.update_brightness] = zef_update_contrast_and_brightness;');
evalin('base','zef.update_transparency_reconstruction = zef_update_transparency_reconstruction;');
evalin('base','zef.update_transparency_surface = zef_update_transparency_surface;');
evalin('base','zef.update_transparency_sensor = zef_update_transparency_sensor;');
evalin('base','zef.update_transparency_additional = zef_update_transparency_additional;');
evalin('base','zef.update_transparency_cones = zef_update_transparency_cones;');
evalin('base','zef.update_zoom = zef_update_zoom;');
evalin('base','zef.colorscale_min_slider = zef_update_colorscale_min;');
evalin('base','zef.colorscale_max_slider = zef_update_colorscale_max;');
evalin('base','zef_set_lights(zef.update_lights);');

end
end
end

