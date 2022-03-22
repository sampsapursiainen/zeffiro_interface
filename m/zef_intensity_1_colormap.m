function [colormap_vec] = zef_intensity_1_colormap(colortune_param, colormap_size)

c_aux_1 = floor(colortune_param*colormap_size/3);
c_aux_2 = floor(colormap_size  - colortune_param*colormap_size/3);
colormap_vec = zeros(3,colormap_size);
colormap_vec(1,:) =10*([colormap_size:-1:1]/colormap_size);
colormap_vec(2,:) = [10*(3*(1  - 1/3)/(2*(1- colortune_param/3)))*[c_aux_2:-1:1]/colormap_size zeros(1,colormap_size-c_aux_2)];
colormap_vec(3,:) = [10*((3/colortune_param)*[c_aux_1:-1:1]/colormap_size) zeros(1,colormap_size-c_aux_1)];
colormap_vec = colormap_vec'/max(colormap_vec(:));
colormap_vec = flipud(colormap_vec);
colormap_vec = colormap_vec + repmat(0.2*([colormap_size:-1:1]'/colormap_size),1,3);
colormap_vec = colormap_vec/max(colormap_vec(:));

end
