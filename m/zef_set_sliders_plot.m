function zef_set_sliders_plot(mode)

if mode == 1

evalin('base','zef.h_axes1.Colormap = zef_colormap(zef.h_update_colormap.Value);');
evalin('base','zef_update_ambience;');
evalin('base','zef_update_diffusion;');
evalin('base','zef_update_specular;');
evalin('base','if zef.update_brightness; zef_update_brightness; end;');
evalin('base','if zef.update_transparency_reconstruction; zef_update_transparency_reconstruction(zef.h_axes1,0,zef.update_transparency_reconstruction); end;');
evalin('base','if zef.update_transparency_surface; zef_update_transparency_surface(zef.h_axes1,0,zef.update_transparency_surface); end;');
evalin('base','if zef.update_transparency_sensor; zef_update_transparency_sensor(zef.h_axes1,0,zef.update_transparency_sensor); end;');
evalin('base','if zef.update_transparency_additional; zef_update_transparency_additional(zef.h_axes1,0,zef.update_transparency_additional); end');
evalin('base','if zef.update_transparency_cones; zef_update_transparency_cones(zef.h_axes1,0,zef.update_transparency_cones); end');
evalin('base','if not(isequal(zef.update_zoom,zef.cam_va)); zef_update_zoom; end');
evalin('base','if abs(zef.colorscale_min_slider); zef_update_colorscale_min(zef.h_axes1,0,zef.colorscale_min_slider); end;');
evalin('base','if abs(zef.colorscale_max_slider); zef_update_colorscale_max(zef.h_axes1,0,zef.colorscale_max_slider); end;');
evalin('base','zef_set_lights(zef.update_lights);');

elseif mode == 2 

if evalin('base','zef.brain_transparency') < 1 || evalin('base','zef.use_parcellation')
evalin('base','if zef.update_transparency_reconstruction; zef_update_transparency_reconstruction(zef.h_axes1,0,zef.update_transparency_reconstruction); end;');
end

end
end

