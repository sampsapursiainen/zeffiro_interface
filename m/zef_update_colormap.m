function new_colormap = zef_update_colormap(colormap_ind, colortune_param, colormap_size)

colormap_cell = evalin('base','zef.colormap_cell');
new_colormap = evalin('base',[colormap_cell{colormap_ind} '(' num2str(colortune_param) ',' num2str(colormap_size) ')']);

end
