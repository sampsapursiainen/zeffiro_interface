if isequal(zef.h_eit_sensitivity_tool_distribution.Value,zef.h_eit_sensitivity_tool_distribution.Items{1})

    zef.sigma(zef.brain_ind,1) = 1/4*(zef.eit_sensitivity_tool_data.avg(zef.source_interpolation_ind{1}(:,1)) +  zef.eit_sensitivity_tool_data.avg(zef.source_interpolation_ind{1}(:,2)) +  zef.eit_sensitivity_tool_data.avg(zef.source_interpolation_ind{1}(:,3)) +  zef.eit_sensitivity_tool_data.avg(zef.source_interpolation_ind{1}(:,4)));
    
elseif isequal(zef.h_eit_sensitivity_tool_distribution.Value,zef.h_eit_sensitivity_tool_distribution.Items{2})
 
 zef.reconstruction = repmat(sqrt(sum(zef.L.^2)),3,1);
 zef.reconstruction = zef.reconstruction(:);
    
elseif    isequal(zef.h_eit_sensitivity_tool_distribution.Value,zef.h_eit_sensitivity_tool_distribution.Items{3})
 
 zef.reconstruction = repmat(std(interp_data.covK').*sqrt(sum(zef.L.^2))./interp_data.avg,3,1);
 zef.reconstruction = zef.reconstruction(:);
   
end