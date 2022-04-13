function [colormap_vec] = zef_easter_colormap(colortune_param, colormap_size)


c_aux_1 = floor(colormap_size/2);
colormap_vec = [[c_aux_1:-1:1]/c_aux_1 zeros(1,colormap_size-c_aux_1); ... 
                 0.6*[1:c_aux_1]/c_aux_1 0.6*[colormap_size-c_aux_1:-1:1]/(colormap_size-c_aux_1); ...
                 zeros(1,c_aux_1) 0.7*[1:colormap_size-c_aux_1]/(colormap_size - c_aux_1)];
colormap_vec(2,:) = colormap_vec(2,:) + colormap_vec(1,:).^2;
colormap_vec(3,:) = colormap_vec(3,:) + colormap_vec(1,:).^4;
colormap_vec =  log(0.1*colormap_vec./colortune_param.^4+1);
colormap_vec = colormap_vec'/max(colormap_vec(:));
colormap_vec = flipud(colormap_vec);


end
