function [reconstruction, reconstruction_info] = zef_nse_reconstruction(nse_field,type)

reconstruction = cell(0);
reconstruction_info = cell(0);

if isequal(type,1)
    
    for i = 1 : size(nse_field.bp_vessels,2)
  
  aux_vec = zef_nse_threshold_distribution(nse_field.bp_vessels{i}(:),nse_field.min_reconstruction_quantile,nse_field.max_reconstruction_quantile);
   reconstruction{i} = (1/sqrt(3))*aux_vec(:,[1 1 1])';
   reconstruction{i} = reconstruction{i}(:);
   
    end
    
elseif isequal(type,2)
    
    for i = 1 : size(nse_field.bv_vessels_1,2)
      aux_vec_1 = zef_nse_threshold_distribution(nse_field.bv_vessels_1{i}(:),nse_field.min_reconstruction_quantile,nse_field.max_reconstruction_quantile);
      aux_vec_2 = zef_nse_threshold_distribution(nse_field.bv_vessels_2{i}(:),nse_field.min_reconstruction_quantile,nse_field.max_reconstruction_quantile);
      aux_vec_3 = zef_nse_threshold_distribution(nse_field.bv_vessels_3{i}(:),nse_field.min_reconstruction_quantile,nse_field.max_reconstruction_quantile);

   reconstruction{i} = (1/sqrt(3))*[aux_vec_1 aux_vec_2 aux_vec_3]';
   reconstruction{i} = reconstruction{i}(:);
   
    end

elseif isequal(type,3)
    
    for i = 1 : size(nse_field.mu_vessels,2)
    
  aux_vec = zef_nse_threshold_distribution(nse_field.mu_vessels{i}(:),nse_field.min_reconstruction_quantile,nse_field.max_reconstruction_quantile);
  
   reconstruction{i} = (1/sqrt(3))*aux_vec(:,[1 1 1])';
   reconstruction{i} = reconstruction{i}(:);
   
    end
    
elseif isequal(type,4)
    
        for i = 1 : size(nse_field.bf_capillaries,2)
    
   aux_vec = zef_nse_threshold_distribution(nse_field.bf_capillaries{i}(:),nse_field.min_reconstruction_quantile,nse_field.max_reconstruction_quantile);
  
   reconstruction{i} = (1/sqrt(3))*aux_vec(:,[1 1 1])';
   reconstruction{i} = reconstruction{i}(:); 
   
        end
end


end