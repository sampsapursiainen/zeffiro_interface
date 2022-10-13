function mean_point = zef_cluster_mean(rec_points,n_points)

while size(rec_points,1) > n_points
    
    mean_point = mean(rec_points,1); 
    aux_vec = sqrt(sum((rec_points - mean_point).^2,2)); 
    [~, max_ind] = max(aux_vec);
    I = setdiff(1:size(rec_points,1),max_ind);
    rec_points = rec_points(I,:);

end

mean_point = mean(rec_points,1);

end