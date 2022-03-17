function [colormap_vec] = zef_blue_brain_2_colormap(colortune_param, colormap_size)

colormap_vec = [(colormap_size/5)^3 + (colormap_size)^2*[1 : colormap_size] ; (colormap_size/2)^3 + ((colormap_size)/2)*[1:colormap_size].^2 ; ...
    (0.7*colormap_size)^3+(0.5*colormap_size)^2*[1:colormap_size]];
colormap_vec = colormap_vec'/max(colormap_vec(:));
colormap_vec = colormap_vec.^(colortune_param);

end
