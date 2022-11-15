function [reconstruction, reconstruction_info] = zef_nse_reconstruction(nse_field,type)

reconstruction = cell(0);
reconstruction_info = cell(0);

if isequal(lower(type),'velocity')
    
    for i = 1 : size(nse_field.u_1_field,2)
    
   reconstruction{i} = [nse_field.u_1_field(:,i) nse_field.u_2_field(:,i) nse_field.u_3_field(:,i)]';
   reconstruction{i} = reconstruction{i}(:);
   
    end
    
elseif isequal(lower(type),'pressure')
    
        for i = 1 : size(nse_field.p_field,2)
    
   reconstruction{i} = (1/sqrt(3))*[nse_field.p_field(:,i) nse_field.p_field(:,i) nse_field.p_field(:,i)]';
   reconstruction{i} = reconstruction{i}(:); 
   
        end
end


end