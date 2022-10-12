function p = zef_newton_concentration(rec_points,p0,tol_val,max_iter)

p = p0;

norm_1 = norm(zef_diff_concentration(rec_points,p(1),p(2),p(3)));
norm_2 = Inf;

iter_step = 0; 

while and(norm_2/norm_1 > tol_val, iter_step < max_iter)
    
iter_step = iter_step + 1;    
p = p - zef_diff_concentration(rec_points,p(1),p(2),p(3))/zef_diff2_concentration(rec_points,p(1),p(2),p(3));
norm_2 = norm(zef_diff_concentration(rec_points,p(1),p(2),p(3)));

end


end