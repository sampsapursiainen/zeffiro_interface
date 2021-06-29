quantile_val_1 = 0.25;
quantile_val_2 = 0.01;

if isequal(zef.h_eit_sensitivity_tool_distribution.Value,zef.h_eit_sensitivity_tool_distribution.Items{1})

    zef.sigma(zef.brain_ind,1) = 1/4*(zef.eit_sensitivity_tool_data.avg(zef.source_interpolation_ind{1}(:,1)) +  zef.eit_sensitivity_tool_data.avg(zef.source_interpolation_ind{1}(:,2)) +  zef.eit_sensitivity_tool_data.avg(zef.source_interpolation_ind{1}(:,3)) +  zef.eit_sensitivity_tool_data.avg(zef.source_interpolation_ind{1}(:,4)));
    
elseif isequal(zef.h_eit_sensitivity_tool_distribution.Value,zef.h_eit_sensitivity_tool_distribution.Items{2})
 
     %zef.reconstruction = sqrt(max((zef.L)));
%zef.reconstruction = real(sqrt(sum((zef.L(1:end-2,:)).^2)));
 zef.reconstruction = (1./zef.n_sources)*sum(zef_eit_sensitivity_tool_volume)*sqrt(mean(zef.L(1:end-2,:).^2))./zef_eit_sensitivity_tool_volume'./sqrt(mean(zef.inv_bg_data(1:end-2).^2));
 
%zef.reconstruction = sqrt(sum((zef.reconstruction - zef.inv_bg_data(1:end-2).*(abs(sum((zef.reconstruction.*repmat(zef.inv_bg_data(1:end-2),1,size(zef.L,2))))))./norm(zef.inv_bg_data(1:end-2),2)).^2))./sqrt(sum(zef.reconstruction.^2));

%zef.reconstruction = sqrt(abs(sum((zef.L(1:end-2,:).^2))) - abs(sum((zef.L(1:end-2,:).*repmat(zef.inv_bg_data(1:end-2),1,size(zef.L,2))))./norm(zef.inv_bg_data(1:end-2),2)).^2);
%zef.reconstruction = zef.reconstruction./sqrt(abs(sum((zef.L(1:end-2,:).^2))));
%zef.reconstruction = max(abs((zef.L(1:end-2,:)-repmat(mean(zef.L(1:end-2,:),1),size(zef.L,1)-2,1))));

zef.reconstruction = min(quantile(zef.reconstruction,1-quantile_val_2),zef.reconstruction);
% zef.reconstruction = max(quantile(zef.reconstruction,quantile_val_2),zef.reconstruction);

zef.reconstruction = repmat(zef.reconstruction,3,1);
 zef.reconstruction = zef.reconstruction(:);
    
elseif    isequal(zef.h_eit_sensitivity_tool_distribution.Value,zef.h_eit_sensitivity_tool_distribution.Items{3})
 
zef.reconstruction =  sqrt(mean(zef.L(1:end-2,:).^2))./zef_eit_sensitivity_tool_volume'./sqrt(mean(zef.inv_bg_data(1:end-2).^2));
% zef.reconstruction = repmat(zef.reconstruction./zef_eit_sensitivity_tool_volume',3,1);

 zef.reconstruction = min(quantile(zef.reconstruction,1-quantile_val_2),zef.reconstruction);
 
 
 
  zef.reconstruction = (1./zef.n_sources)*sum(zef_eit_sensitivity_tool_volume)*std(zef.eit_sensitivity_tool_data.covK').*zef.reconstruction;

 
% zef.reconstruction = max(quantile(zef.reconstruction,quantile_val_2),zef.reconstruction);
 
 zef.reconstruction = repmat(zef.reconstruction,3,1);
 zef.reconstruction = zef.reconstruction(:);
 
end