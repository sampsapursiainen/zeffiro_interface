function [index_vec,MahalanobisD,GMModel] = zef_find_clusters(n_clusters,rec_points,reg_val,cred_val,max_iter)

index_vec = ones(size(rec_points,1),1);
if isequal(length(cred_val),1)
cred_val = cred_val*ones(size(index_vec));
end

    r_squared = chi2inv(cred_val,5);

k = 0;

while  and(k < n_clusters, isequal(length(unique(index_vec)),k+1))
    k = k+1;
    GMModel= fitgmdist(rec_points,k,'CovarianceType','full','RegularizationValue',reg_val,'Start',index_vec,'MaxIter',max_iter);
    
    [index_vec, ~,~, ~, MahalanobisD]=cluster(GMModel, rec_points);
    ind = [1:size(MahalanobisD,1)]';
                for kk = 1:k
                    aux_vec = MahalanobisD(:,kk);
                    ind1 = find(aux_vec(:)<r_squared(:));
                    index_vec(ind1)=kk;
                    ind = setdiff(ind,ind1);
                    index_vec(ind)=k+1;
                end

end

end