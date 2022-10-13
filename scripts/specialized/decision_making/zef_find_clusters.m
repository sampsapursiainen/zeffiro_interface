function [index_vec,MahalanobisD] = zef_find_clusters(n_clusters,rec_points,reg_val,cred_val)

index_vec = ones(size(rec_points,1),1);
r_squared = chi2inv(cred_val,5);

for k = 1 : n_clusters
 GMModel_aux = fitgmdist(rec_points,k,'CovarianceType','full','RegularizationValue',reg_val);

if k>1
                [index_vec, ~,~, ~, MahalanobisD]=cluster(GMModel_aux, rec_points);
                ind = ones(size(MahalanobisD,1),1);
                for kk = 1:(k-1)
                    ind1=MahalanobisD(:,kk)<r_squared;
                    index_vec(ind1)=kk;
                    ind = ind & not(ind1);
                    index_vec(ind)=k;
                end
end

end

end