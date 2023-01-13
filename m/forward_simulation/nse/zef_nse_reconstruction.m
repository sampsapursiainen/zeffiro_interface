function [reconstruction, reconstruction_info] = zef_nse_reconstruction(nse_field,type)

reconstruction = cell(0);
reconstruction_info = cell(0);

if isequal(type,1)
    
    for i = 1 : size(nse_field.bp_vessels,2)
    
  aux_vec = nse_field.bp_vessels(:,i);
   reconstruction{i} = (1/sqrt(3))*aux_vec(:,[i i i])';
   reconstruction{i} = reconstruction{i}(:);
   
    end
    
elseif isequal(type,2)
    
        for i = 1 : size(nse_field.bf_capillaries,2)
    
   aux_vec = nse_field.bf_capillaries(:,i);
   reconstruction{i} = (1/sqrt(3))*aux_vec(:,[i i i])';
   reconstruction{i} = reconstruction{i}(:); 
   
        end
end


end