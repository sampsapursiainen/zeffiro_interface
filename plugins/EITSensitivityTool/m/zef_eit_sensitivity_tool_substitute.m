

if isequal(zef.h_eit_sensitivity_tool_distribution.Value,zef.h_eit_sensitivity_tool_distribution.Items{1})

    zef.sigma(zef.brain_ind,1) = 1/4*(zef.eit_sensitivity_tool_data.avg(zef.source_interpolation_ind{1}(:,1)) +  zef.eit_sensitivity_tool_data.avg(zef.source_interpolation_ind{1}(:,2)) +  zef.eit_sensitivity_tool_data.avg(zef.source_interpolation_ind{1}(:,3)) +  zef.eit_sensitivity_tool_data.avg(zef.source_interpolation_ind{1}(:,4)));
    
elseif isequal(zef.h_eit_sensitivity_tool_distribution.Value,zef.h_eit_sensitivity_tool_distribution.Items{2})
 
zef.reconstruction = abs(sum(zef.L(1:end-2,:).*repmat(zef.inv_bg_data(1:end-2),1,size(zef.L,2))))./sqrt(sum(zef.inv_bg_data(1:end-2).^2));
zef.reconstruction = 1000./zef_eit_sensitivity_tool_volume'.*zef.reconstruction;
zef.reconstruction = repmat(zef.reconstruction,3,1);
zef.reconstruction = zef.reconstruction(:);

elseif isequal(zef.h_eit_sensitivity_tool_distribution.Value,zef.h_eit_sensitivity_tool_distribution.Items{3})
 
zef.reconstruction = sqrt(sum(zef.L(1:end-2,:).^2)./sum(zef.inv_bg_data(1:end-2).^2)-abs(sum(zef.L(1:end-2,:).*repmat(zef.inv_bg_data(1:end-2),1,size(zef.L,2)))).^2./(sum(zef.inv_bg_data(1:end-2).^2)));
zef.reconstruction = 1000./zef_eit_sensitivity_tool_volume'.*zef.reconstruction;
zef.reconstruction = repmat(zef.reconstruction,3,1);
zef.reconstruction = zef.reconstruction(:);

    
elseif    isequal(zef.h_eit_sensitivity_tool_distribution.Value,zef.h_eit_sensitivity_tool_distribution.Items{4})
 
zef.reconstruction = abs(sum(zef.L(1:end-2,:).*repmat(zef.inv_bg_data(1:end-2),1,size(zef.L,2))))./sqrt(sum(zef.inv_bg_data(1:end-2).^2));
zef.reconstruction = 1000./zef_eit_sensitivity_tool_volume'.*zef.reconstruction;
zef.reconstruction = std(zef.eit_sensitivity_tool_data.covK').*zef.reconstruction;
zef.reconstruction = repmat(zef.reconstruction,3,1);
 zef.reconstruction = zef.reconstruction(:);
 
 elseif    isequal(zef.h_eit_sensitivity_tool_distribution.Value,zef.h_eit_sensitivity_tool_distribution.Items{5})
 
zef.reconstruction = sqrt(sum(zef.L(1:end-2,:).^2)./sum(zef.inv_bg_data(1:end-2).^2)-abs(sum(zef.L(1:end-2,:).*repmat(zef.inv_bg_data(1:end-2),1,size(zef.L,2)))).^2./(sum(zef.inv_bg_data(1:end-2).^2)));
zef.reconstruction = 1000./zef_eit_sensitivity_tool_volume'.*zef.reconstruction;
zef.reconstruction = std(zef.eit_sensitivity_tool_data.covK').*zef.reconstruction;
zef.reconstruction = repmat(zef.reconstruction,3,1);
zef.reconstruction = zef.reconstruction(:);
 
end