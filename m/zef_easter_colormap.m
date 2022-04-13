function [colormap_vec] = zef_easter_colormap(colortune_param,colormap_size)

c_aux_1 = floor(colormap_size/2);
colormap_vec = zeros(colormap_size,3);
colormap_vec(1:c_aux_1+1,:) = [zeros(c_aux_1+1,1),2*(1:c_aux_1+1)',3*(c_aux_1:-1:0)'];
c_aux_2 = c_aux_1+floor(colormap_size/4);
c_aux_1 = c_aux_1+1;
colormap_vec(c_aux_1:c_aux_2,:) = [2*(c_aux_1/floor(colormap_size/4))*(1:floor(colormap_size/4))',2*c_aux_1*ones(floor(colormap_size/4),1),zeros(floor(colormap_size/4),1)];
c_aux_1 = c_aux_2+1;
n =colormap_size-c_aux_2;
t = linspace(0,1,n)';
colormap_vec(c_aux_1:end,:) = 0.95*max(colormap_vec,[],'all')*[1,1,1].*t+colormap_vec(c_aux_2,:).*(1-t);

colormap_vec =  colormap_vec.^colortune_param;
colormap_vec = colormap_vec/max(colormap_vec(:));

end