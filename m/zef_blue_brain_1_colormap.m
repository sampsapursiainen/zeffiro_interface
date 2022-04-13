function [colormap_vec] = zef_blue_brain_1_colormap(colortune_param, colormap_size)


c_aux_1 = floor(colormap_size/2);
colormap_vec = [(colormap_size/2)*[c_aux_1:-1:1]/c_aux_1 zeros(1,colormap_size-c_aux_1); ... 
                 (colormap_size/3)*[1:c_aux_1]/c_aux_1 (colormap_size/3)*[colormap_size-c_aux_1:-1:1]/(colormap_size-c_aux_1); ...
                 zeros(1,c_aux_1) (colormap_size/3)*[1:colormap_size-c_aux_1]/(colormap_size - c_aux_1)];
colormap_vec =  log(colormap_vec./colortune_param.^2+1);
colormap_vec = colormap_vec'/max(colormap_vec(:));
colormap_vec = flipud(colormap_vec);



end
