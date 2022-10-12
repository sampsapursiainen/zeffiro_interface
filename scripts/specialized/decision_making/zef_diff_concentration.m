function w = zef_diff_concentration(rec_points,x,y,z)
  
aux_vec = sqrt(sum(([x y z] - rec_points).^2,2)); 
w = sum(-3.*([x y z] -  rec_points)./(aux_vec.^5));

end