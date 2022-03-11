function colormap_vec = zef_brighness_and_contrast(colormap_vec, brightness_val, contrast_val)

colormap_vec = (((colormap_vec + brightness_val)/(1+brightness_val)).^(1+contrast_val));

end
