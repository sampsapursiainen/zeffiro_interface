function [colormap_vec] = zef_monterosso_colormap(colortune_param, colormap_size)

color_mat = [26 26 26;   0.2 11.8 13.2; 42.5   98.5  108.5; 203 203 100];

color_mat = color_mat';

c_aux_1 = floor(colortune_param*colormap_size/3);
c_aux_2 = floor(colormap_size  - colortune_param*colormap_size/3);
colormap_vec_aux = [([20/colortune_param*[c_aux_1:-1:1] zeros(1,colormap_size-c_aux_1)]); ...
    ([15/colortune_param*[1: c_aux_1] 15*(1-2/3)/(1-2*colortune_param/3)*[c_aux_2-c_aux_1:-1:1] zeros(1,colormap_size-c_aux_2)]) ; ...
    ([zeros(1,c_aux_1) 6*(1-2/3)/(1-2*colortune_param/3)*[1:c_aux_2-c_aux_1] 6/colortune_param*[colormap_size-c_aux_2:-1:1]]); ...
    ([zeros(1,c_aux_2) 7.5/colortune_param*[1:colormap_size-c_aux_2]])];
colormap_vec = zeros(3,size(colormap_vec_aux,2));

for i = 1 : 4
colormap_vec = colormap_vec + repmat(color_mat(:,i),1,size(colormap_vec_aux,2)).*colormap_vec_aux(i*[1 1 1],:);
end

colormap_vec = colormap_vec'./max(colormap_vec(:));

end
