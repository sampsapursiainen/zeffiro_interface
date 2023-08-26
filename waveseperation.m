
forward_pressure_wave, backward_pressure_wave, forward_velocity_wave, zef_nse_separate_waves_roi(zef,nse_field)

roi_ind = zef_nse_field_roi_ind(zef,nse_field);
[~, dir_aux] = zef_nse_mean_velocity_roi(zef,zef.nse_field);
n_time = length(zef.nse_field.bp_vessels);


    pressure_sum = 0;
    velocity_sum = 0;
    for j=n_time-1
        pressure_sum = pressure_sum + ((mean(zef.nse_field.bp_vessels{j+1}(roi_ind))-mean(zef.nse_field.bp_vessels{j}(roi_ind)))/time_s)^2;
        aux_velocity_wave1 =  mean(dir_aux(:,1).*zef.nse_field.bv_vessels_1{j}(roi_ind,1)+dir_aux(:,2).*zef.nse_field.bv_vessels_2{j}(roi_ind)+dir_aux(:,3).*zef.nse_field.bv_vessels_3{j}(roi_ind,1));
        aux_velocity_wave2 =  mean(dir_aux(:,1).*zef.nse_field.bv_vessels_1{j+1}(roi_ind,1)+dir_aux(:,2).*zef.nse_field.bv_vessels_2{j+1}(roi_ind)+dir_aux(:,3).*zef.nse_field.bv_vessels_3{j+1}(roi_ind,1));
        velocity_sum = velocity_sum + ((aux_velocity_wave2-aux_velocity_wave1)/time_s)^2;
    end   
    c = 1/zef.nse_field.rho*sqrt(pressure_sum/velocity_sum);

   forward_pressure_wave = zeros(n_time-1,1);
   backward_pressure_wave = zeros(n_time-1,1);
   forward_velocity_wave = zeros(n_time-1,1);
   backward_velocity_wave = zeros(n_time-1,1);
    
    for i =1:n_time-1 
        aux_velocity_wave1 =  mean(dir_aux(:,1).*zef.nse_field.bv_vessels_1{i}(roi_ind)+dir_aux(:,2).*zef.nse_field.bv_vessels_2{i}(roi_ind)+dir_aux(:,3).*zef.nse_field.bv_vessels_3{i}(roi_ind,1));
        aux_velocity_wave2 =  mean(dir_aux(:,1).*zef.nse_field.bv_vessels_1{i+1}(roi_ind)+dir_aux(:,2).*zef.nse_field.bv_vessels_2{i+1}(roi_ind)+dir_aux(:,3).*zef.nse_field.bv_vessels_3{i+1}(roi_ind));
       dP_minus = 1/2*(mean(zef.nse_field.bp_vessels{i}(roi_ind))-zef.nse_field.rho*c*aux_velocity_wave1);
        dP_plus = 1/2*(mean(zef.nse_field.bp_vessels{i}(roi_ind))+zef.nse_field.rho*c*aux_velocity_wave1);   
        pressure_total_sum_minus = dP_minus;
        pressure_total_sum_plus =  dP_plus;
  
        forward_pressure_wave(i) = 2*pressure_total_sum_plus;
        backward_pressure_wave(i) = 2*pressure_total_sum_minus;

        forward_velocity_wave(i) = 2*dP_plus/(zef.nse_field.rho*c);
        backward_velocity_wave(i) = -2*dP_minus/(zef.nse_field.rho*c);

    end



intensities = zeros(n_time-1,1);

for i=1:n_time-1

    aux_velocity_wave1 =  dir_aux(:,1).*zef.nse_field.bv_vessels_1{i}(roi_ind)+dir_aux(:,2).*zef.nse_field.bv_vessels_2{i}(roi_ind)+dir_aux(:,3).*zef.nse_field.bv_vessels_3{i}(roi_ind);
    aux_velocity_wave2 =  dir_aux(:,1).*zef.nse_field.bv_vessels_1{i+1}(roi_ind)+dir_aux(:,2).*zef.nse_field.bv_vessels_2{i+1}(roi_ind)+dir_aux(:,3).*zef.nse_field.bv_vessels_3{i+1}(roi_ind,1);
    intensities(i) = mean((zef.nse_field.bp_vessels{i+1}(roi_ind)-zef.nse_field.bp_vessels{i}(roi_ind)).*(aux_velocity_wave2-aux_velocity_wave1));

end

forward_pressure_wave = interp1(1:n_time-1,forward_pressure_wave,linspace(1,n_time-1,n_time));
backward_pressure_wave = interp1(1:n_time-1,backward_pressure_wave,linspace(1,n_time-1,n_time));
forward_velocity_wave = interp1(1:n_time-1,forward_velocity_wave,linspace(1,n_time-1,n_time));
backward_velocity_wave = interp1(1:n_time-1,backward_velocity_wave,linspace(1,n_time-1,n_time));
intensities = interp1(1:n_time-1,intensities,linspace(1,n_time-1,n_time));

end
