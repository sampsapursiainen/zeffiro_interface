function [index_vec,MahalanobisD,GMModel] = zef_find_clusters(n_clusters, rec_points,reg_val,cred_val,max_iter,tol_val)

index_vec = ones(size(rec_points,1),1);
if isequal(length(cred_val),1)
cred_val = cred_val*ones(size(index_vec));
end

options = statset('TolFun',tol_val,'MaxIter',max_iter);

    r_squared = chi2inv(cred_val,size(rec_points,2));

k = 0;

h_waitbar = zef_waitbar(0,'Clustering');
GMModel_old = [];
MahalanobisD_old = [];
index_vec_old = [];
unique_cond = 1;
max_ind = 1;
index_vec_old = [];
while  and(k < n_clusters,k<max(index_vec))
    k = k+1;
    GMModel = fitgmdist(rec_points,k,'CovarianceType','full','RegularizationValue',reg_val,'Start',index_vec,'Options',options);
    [index_vec, ~,~,~, MahalanobisD]=cluster(GMModel, rec_points);
    index_vec_old = index_vec;
    ind = [1:size(MahalanobisD,1)]';
    if k < n_clusters
                for kk = 1:k
                    aux_vec = MahalanobisD(:,kk);
                    ind1 = find(aux_vec(:)<r_squared(:));
                    index_vec(ind1)=kk;
                    ind = setdiff(ind,ind1);
                    index_vec(ind)=k+1;
                end
    [~,~,index_vec] = unique(index_vec); 
    end

    zef_waitbar(k/n_clusters,h_waitbar,'Clustering.');
    
end

k = max(index_vec);
  GMModel = fitgmdist(rec_points,k,'CovarianceType','full','RegularizationValue',reg_val,'Start',index_vec,'Options',options);
    [index_vec, ~,~,~, MahalanobisD]=cluster(GMModel, rec_points);

if k < n_clusters
zef_waitbar(1,h_waitbar,'Clustering.');
end

close(h_waitbar);

end