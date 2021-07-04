zef.aux_vec_L = zef.L(1:end-2,:);
zef.aux_vec_bg_data = zef.inv_bg_data(1:end-2);
    
zef.aux_vec_L = zef.aux_vec_L - repmat(mean(zef.aux_vec_L),size(zef.L,1)-2,1);
zef.aux_vec_bg_data = zef.aux_vec_bg_data - mean(zef.aux_vec_bg_data);

if isequal(zef.h_eit_sensitivity_tool_distribution.Value,zef.h_eit_sensitivity_tool_distribution.Items{1})

zef.sigma(zef.brain_ind,1) = 1/4*(zef.eit_sensitivity_tool_data.avg(zef.source_interpolation_ind{1}(:,1)) +  zef.eit_sensitivity_tool_data.avg(zef.source_interpolation_ind{1}(:,2)) +  zef.eit_sensitivity_tool_data.avg(zef.source_interpolation_ind{1}(:,3)) +  zef.eit_sensitivity_tool_data.avg(zef.source_interpolation_ind{1}(:,4)));
zef.reconstruction = repmat(zef.eit_sensitivity_tool_data.avg,3,1);
zef.reconstruction = zef.reconstruction(:);

if isequal(zef.h_eit_sensitivity_tool_distribution.Value,zef.h_eit_sensitivity_tool_distribution.Items{2})

zef.sigma(zef.brain_ind,1) = 1/4*(zef.eit_sensitivity_tool_data_2.avg(zef.source_interpolation_ind{1}(:,1)) +  zef.eit_sensitivity_tool_data_2.avg(zef.source_interpolation_ind{1}(:,2)) +  zef.eit_sensitivity_tool_data_2.avg(zef.source_interpolation_ind{1}(:,3)) +  zef.eit_sensitivity_tool_data_2.avg(zef.source_interpolation_ind{1}(:,4)));
zef.reconstruction = repmat(zef.eit_sensitivity_tool_data_2.avg,3,1);
zef.reconstruction = zef.reconstruction(:);

elseif isequal(zef.h_eit_sensitivity_tool_distribution.Value,zef.h_eit_sensitivity_tool_distribution.Items{3})

zef.aux_vec_sigma_index = unique(zef.sigma(:,2));
zef.aux_vec_sigma_index = find(not(ismember(zef.brain_ind, find(ismember(zef.sigma(:,2),zef.aux_vec_sigma_index(end-1:end))))));
zef.sigma(zef.brain_ind(zef.aux_vec_sigma_index),1) = 1/4*(zef.eit_sensitivity_tool_data.avg(zef.source_interpolation_ind{1}(zef.aux_vec_sigma_index,1)) +  zef.eit_sensitivity_tool_data.avg(zef.source_interpolation_ind{1}(zef.aux_vec_sigma_index,2)) +  zef.eit_sensitivity_tool_data.avg(zef.source_interpolation_ind{1}(zef.aux_vec_sigma_index,3)) +  zef.eit_sensitivity_tool_data.avg(zef.source_interpolation_ind{1}(zef.aux_vec_sigma_index,4)));
zef.reconstruction = repmat(zef.eit_sensitivity_tool_data.avg,3,1);
zef.reconstruction = zef.reconstruction(:);
 
elseif isequal(zef.h_eit_sensitivity_tool_distribution.Value,zef.h_eit_sensitivity_tool_distribution.Items{4})

zef.aux_vec_sigma_index = unique(zef.sigma(:,2));
zef.aux_vec_sigma_index = find(not(ismember(zef.brain_ind, find(ismember(zef.sigma(:,2),zef.aux_vec_sigma_index(end-1:end))))));
zef.sigma(zef.brain_ind(zef.aux_vec_sigma_index),1) = 1/4*(zef.eit_sensitivity_tool_data_2.avg(zef.source_interpolation_ind{1}(zef.aux_vec_sigma_index,1)) +  zef.eit_sensitivity_tool_data_2.avg(zef.source_interpolation_ind{1}(zef.aux_vec_sigma_index,2)) +  zef.eit_sensitivity_tool_data_2.avg(zef.source_interpolation_ind{1}(zef.aux_vec_sigma_index,3)) +  zef.eit_sensitivity_tool_data_2.avg(zef.source_interpolation_ind{1}(zef.aux_vec_sigma_index,4)));
zef.reconstruction = repmat(zef.eit_sensitivity_tool_data_2.avg,3,1);
zef.reconstruction = zef.reconstruction(:);

elseif isequal(zef.h_eit_sensitivity_tool_distribution.Value,zef.h_eit_sensitivity_tool_distribution.Items{5})
 
zef.reconstruction = abs(sum(zef.aux_vec_L.*repmat(zef.aux_vec_bg_data,1,size(zef.L,2))))./(sum(zef.aux_vec_bg_data.^2));
zef.reconstruction = 1./zef_eit_sensitivity_tool_volume'.*zef.reconstruction;

elseif isequal(zef.h_eit_sensitivity_tool_distribution.Value,zef.h_eit_sensitivity_tool_distribution.Items{6})
 
zef.reconstruction = (sum(zef.aux_vec_L.*repmat(zef.aux_vec_bg_data,1,size(zef.L,2))))./sqrt(sum(zef.aux_vec_bg_data.^2));
zef.reconstruction = zef.aux_vec_L - repmat(zef.reconstruction,size(zef.aux_vec_L,1),1).*repmat(zef.aux_vec_bg_data,1,size(zef.aux_vec_L,2))./sqrt(sum(zef.aux_vec_bg_data.^2));
zef.reconstruction = sqrt(sum(zef.reconstruction.^2)./sum(zef.aux_vec_bg_data.^2));
zef.reconstruction = 1./zef_eit_sensitivity_tool_volume'.*zef.reconstruction;

elseif isequal(zef.h_eit_sensitivity_tool_distribution.Value,zef.h_eit_sensitivity_tool_distribution.Items{7})
 
zef.reconstruction = abs(sum(zef.aux_vec_L.*repmat(zef.aux_vec_bg_data,1,size(zef.L,2))))./(sum(zef.aux_vec_bg_data.^2));
zef.reconstruction = 1./zef_eit_sensitivity_tool_volume'.*zef.reconstruction;
zef.reconstruction = std(zef.eit_sensitivity_tool_data.covK').*zef.reconstruction;
 
 elseif    isequal(zef.h_eit_sensitivity_tool_distribution.Value,zef.h_eit_sensitivity_tool_distribution.Items{8})
 
zef.reconstruction = (sum(zef.aux_vec_L.*repmat(zef.aux_vec_bg_data,1,size(zef.L,2))))./sqrt(sum(zef.aux_vec_bg_data.^2));
zef.reconstruction = zef.aux_vec_L - repmat(zef.reconstruction,size(zef.aux_vec_L,1),1).*repmat(zef.aux_vec_bg_data,1,size(zef.aux_vec_L,2))./sqrt(sum(zef.aux_vec_bg_data.^2));
zef.reconstruction = sqrt(sum(zef.reconstruction.^2)./sum(zef.aux_vec_bg_data.^2));
zef.reconstruction = 1./zef_eit_sensitivity_tool_volume'.*zef.reconstruction;
zef.reconstruction = std(zef.eit_sensitivity_tool_data.covK').*zef.reconstruction;

elseif isequal(zef.h_eit_sensitivity_tool_distribution.Value,zef.h_eit_sensitivity_tool_distribution.Items{9})
 
zef.reconstruction = abs(sum(zef.aux_vec_L.*repmat(zef.aux_vec_bg_data,1,size(zef.L,2))))./(sum(zef.aux_vec_bg_data.^2));
zef.reconstruction = 1./zef_eit_sensitivity_tool_volume'.*zef.reconstruction;
zef.reconstruction = abs(zef.eit_sensitivity_tool_data_2.avg-zef.eit_sensitivity_tool_data.avg).*zef.reconstruction;
 
 elseif    isequal(zef.h_eit_sensitivity_tool_distribution.Value,zef.h_eit_sensitivity_tool_distribution.Items{10})
 
zef.reconstruction = (sum(zef.aux_vec_L.*repmat(zef.aux_vec_bg_data,1,size(zef.L,2))))./sqrt(sum(zef.aux_vec_bg_data.^2));
zef.reconstruction = zef.aux_vec_L - repmat(zef.reconstruction,size(zef.aux_vec_L,1),1).*repmat(zef.aux_vec_bg_data,1,size(zef.aux_vec_L,2))./sqrt(sum(zef.aux_vec_bg_data.^2));
zef.reconstruction = sqrt(sum(zef.reconstruction.^2)./sum(zef.aux_vec_bg_data.^2));
zef.reconstruction = 1./zef_eit_sensitivity_tool_volume'.*zef.reconstruction;
zef.reconstruction = abs(zef.eit_sensitivity_tool_data_2.avg-zef.eit_sensitivity_tool_data.avg).*zef.reconstruction;

elseif    isequal(zef.h_eit_sensitivity_tool_distribution.Value,zef.h_eit_sensitivity_tool_distribution.Items{11})
 
zef.h_eit_sensitivity_tool_L_1 = zef.L;

elseif    isequal(zef.h_eit_sensitivity_tool_distribution.Value,zef.h_eit_sensitivity_tool_distribution.Items{12})
 
zef.h_eit_sensitivity_tool_L_2 = zef.L;

elseif    isequal(zef.h_eit_sensitivity_tool_distribution.Value,zef.h_eit_sensitivity_tool_distribution.Items{13})
 
zef.reconstruction = abs(sum(zef.eit_sensitivity_tool_L_2.*zef.eit_sensitivity_tool_L_1))./(sum(zef.eit_sensitivity_tool_L_1.^2));
zef.reconstruction = 1./zef_eit_sensitivity_tool_volume'.*zef.reconstruction;
 

elseif    isequal(zef.h_eit_sensitivity_tool_distribution.Value,zef.h_eit_sensitivity_tool_distribution.Items{14})

zef.reconstruction = (sum(zef.eit_sensitivity_tool_L_2.*zef.eit_sensitivity_tool_L_1))./sqrt(sum(zef.eit_sensitivity_tool_L_1.^2));
zef.reconstruction = zef.eit_sensitivity_tool_L_2 - repmat(zef.reconstruction,size(zef.eit_sensitivity_tool_L_2,1),1).*zef.eit_sensitivity_tool_L_1./sqrt(sum(zef.eit_sensitivity_tool_L_1.^2));
zef.reconstruction = sqrt(sum(zef.reconstruction.^2)./sum(zef.aux_vec_bg_data.^2));
zef.reconstruction = 1./zef_eit_sensitivity_tool_volume'.*zef.reconstruction;
    
end

zef.aux_quantile = quantile(zef.reconstruction, [zef.eit_sensitivity_tool_lower_quantile zef.eit_sensitivity_tool_upper_quantile]);
zef.reconstruction = max(zef.reconstruction, zef.aux_quantile(1));
zef.reconstruction = min(zef.reconstruction, zef.aux_quantile(2));
zef = rmfield(zef,{'aux_quantile','aux_vec_L','aux_vec_bg_data'});

zef.reconstruction = repmat(zef.reconstruction,3,1);
zef.reconstruction = zef.reconstruction(:);
