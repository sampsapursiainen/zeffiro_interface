function colormap_vec = zef_colormap(inv_colormap)

colortune_param = evalin('base','zef.colortune_param');
colormap_size = evalin('base','zef.colormap_size');
colormap_cell = evalin('base','zef.colormap_cell');
colormap_vec = evalin('base',[colormap_cell{inv_colormap} '(' num2str(colortune_param) ',' num2str(colormap_size) ')']);

end
