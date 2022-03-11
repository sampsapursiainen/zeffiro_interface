function [colormap_vec] = zef_blue_brain_3_colormap(colortune_param, colormap_size)

colormap_vec = [[1:colormap_size] ; 0.5*[1:colormap_size] ; 0.5*[colormap_size:-1:1] ];
colormap_vec = colormap_vec + 1;
colormap_vec = colormap_vec'/max(colormap_vec(:));
colormap_vec = colormap_vec.^(colortune_param);

end
