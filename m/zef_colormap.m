function colormap_vec = zef_colormap(inv_colormap)

if isequal(evalin('caller','exist(''zef'')'),1)
    zef = evalin('caller','zef');
else
    zef = evalin('base','zef');
end

colortune_param = zef.colortune_param;
colormap_size = zef.colormap_size;
colormap_cell = zef.colormap_cell;
colormap_vec = eval([colormap_cell{inv_colormap} '(' num2str(colortune_param) ',' num2str(colormap_size) ')']);

end
