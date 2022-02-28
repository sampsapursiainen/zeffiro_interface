function [colormap_vec] = zef_blue_brain_1_colormap(colortune_param, colormap_size)

c_aux_1 = floor(colormap_size - colortune_param*colormap_size/2);
colormap_vec = [10*(colormap_size/3)*[c_aux_1:-1:1]/c_aux_1 zeros(1,colormap_size-c_aux_1); 8*(colormap_size/3)*[1: c_aux_1]/c_aux_1 8*(colormap_size/3)*[colormap_size-c_aux_1:-1:1]/(colormap_size-c_aux_1); zeros(1,c_aux_1) 5*(colormap_size/3)*[1:colormap_size-c_aux_1]/(colormap_size-c_aux_1)];
colormap_vec = colormap_vec+100;
colormap_vec = colormap_vec'/max(colormap_vec(:));
colormap_vec = flipud(colormap_vec);

end