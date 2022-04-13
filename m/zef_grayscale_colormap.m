function [colormap_vec] = zef_grayscale_colormap(colortune_param, colormap_size)

t = linspace(0.15,0.95,colormap_size)';
colormap_vec = repmat(t.^colortune_param,1,3);

end