function w = zef_diff2_concentration(rec_points,x,y,z)

aux_vec = sqrt(sum(([x y z] - rec_points).^2,2)); 
w = zeros(3,3);
for i = 1 : length(aux_vec)
w = w - 3.*eye(3)./(aux_vec(i).^5) + 15.*([x y z] -  rec_points(i,:))'.*([x y z] -  rec_points(i,:))./(aux_vec(i).^7);
end

end