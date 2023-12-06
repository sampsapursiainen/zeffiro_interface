function [v_mag, v_dir, v_vec] = zef_nse_mean_velocity_roi(zef,nse_field)

roi_ind = zef_nse_roi_ind(zef,nse_field);
v_1 = 0; 
v_2 = 0; 
v_3 = 0; 

for i = 1 : length(zef.nse_field.bv_vessels_1)
v_1 = v_1 + mean(zef.nse_field.bv_vessels_1{i}(roi_ind));
v_2 = v_2 + mean(zef.nse_field.bv_vessels_2{i}(roi_ind));
v_3 = v_3 + mean(zef.nse_field.bv_vessels_3{i}(roi_ind));
end
v_vec = [v_1 v_2 v_3]./length(zef.nse_field.bv_vessels_1);
v_mag = sqrt(sum(v_vec.^2));
v_dir = v_vec/v_mag;

end