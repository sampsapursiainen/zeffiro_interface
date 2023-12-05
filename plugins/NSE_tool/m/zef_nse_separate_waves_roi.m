
function [forward_pressure, backward_pressure, forward_velocity, backward_velocity, intensities] = zef_nse_separate_waves_roi(zef, nse_field)

roi_ind = zef_nse_roi_ind(zef,nse_field);
dir_aux = zef_nse_vel_dir(zef,nse_field);
% [~, dir_aux] = zef_nse_mean_velocity_roi(zef,nse_field);
n_time = length(zef.nse_field.bp_vessels);
d_time = (nse_field.time_length - nse_field.start_time)/(n_time-1);
mmhg_conversion = 101325/760;
n_cycle = floor(nse_field.cycle_length/d_time);

   pressure_sum = zeros(n_time,1);
   velocity_sum = zeros(n_time,1);
    for j=1:n_time-1
        pressure_sum(j) = (mean(mmhg_conversion*zef.nse_field.bp_vessels{j+1}(roi_ind))-mean(mmhg_conversion*zef.nse_field.bp_vessels{j}(roi_ind))).^2;
        aux_velocity_wave1 =  mean(dir_aux(:,1).*zef.nse_field.bv_vessels_1{j}(roi_ind,1)+dir_aux(:,2).*zef.nse_field.bv_vessels_2{j}(roi_ind)+dir_aux(:,3).*zef.nse_field.bv_vessels_3{j}(roi_ind,1));
        aux_velocity_wave2 =  mean(dir_aux(:,1).*zef.nse_field.bv_vessels_1{j+1}(roi_ind,1)+dir_aux(:,2).*zef.nse_field.bv_vessels_2{j+1}(roi_ind)+dir_aux(:,3).*zef.nse_field.bv_vessels_3{j+1}(roi_ind,1));
        velocity_sum(j) =(aux_velocity_wave2-aux_velocity_wave1).^2;

    end 
%     c = zeros(n_time-1,1);
%    c =  sqrt(sqrt(abs(pressure_sum))/(sqrt(abs(velocity_sum))*nse_field.rho));
    c =  (1/nse_field.rho)*sqrt(movmean(pressure_sum,2*n_cycle))./(sqrt(movmean(velocity_sum,2*n_cycle)));
%     c =  sqrt(pressure_sum/velocity_sum)/nse_field.rho;
%     c(1:end,1) =  (1/nse_field.rho)*sqrt(mean(pressure_sum)/mean(velocity_sum));

 
   forward_pressure = zeros(n_time-1,1);
   backward_pressure = zeros(n_time-1,1);
   forward_velocity = zeros(n_time-1,1);
   backward_velocity = zeros(n_time-1,1);
   pressure_total_sum_plus = 0;
   pressure_total_sum_minus = 0;
   velocity_total_sum_plus = 0;
   velocity_total_sum_minus = 0;

%    pressure_vec = zeros(n_time,1);
%    velocity_vec = zeros(n_time,1);
% 
%    pressure_vec(1) = mean(mmhg_conversion*(nse_field.bp_vessels{1}(roi_ind)));
%    velocity_vec(1) =  mean(dir_aux(:,1).*nse_field.bv_vessels_1{1}(roi_ind)+dir_aux(:,2).*nse_field.bv_vessels_2{1}(roi_ind)+dir_aux(:,3).*nse_field.bv_vessels_3{1}(roi_ind,1));



    for i =1:n_time-1 
        
        if i == 1
            int_param = 1 ;
        elseif i== n_time-1
            int_param = 1;
        else 
            int_param = 0.5; 
        end
        
       aux_velocity_wave1 =  mean(dir_aux(:,1).*zef.nse_field.bv_vessels_1{i}(roi_ind)+dir_aux(:,2).*zef.nse_field.bv_vessels_2{i}(roi_ind)+dir_aux(:,3).*zef.nse_field.bv_vessels_3{i}(roi_ind,1));
       aux_velocity_wave2 =  mean(dir_aux(:,1).*zef.nse_field.bv_vessels_1{i+1}(roi_ind)+dir_aux(:,2).*zef.nse_field.bv_vessels_2{i+1}(roi_ind)+dir_aux(:,3).*zef.nse_field.bv_vessels_3{i+1}(roi_ind));

       dP_plus = 1/2*((mean(mmhg_conversion*zef.nse_field.bp_vessels{i+1}(roi_ind)-mmhg_conversion*zef.nse_field.bp_vessels{i}(roi_ind)))+nse_field.rho*c(i)*(aux_velocity_wave2-aux_velocity_wave1));
       dP_minus = 1/2*((mean(mmhg_conversion*zef.nse_field.bp_vessels{i+1}(roi_ind)-mmhg_conversion*zef.nse_field.bp_vessels{i}(roi_ind)))-nse_field.rho*c(i)*(aux_velocity_wave2-aux_velocity_wave1));

       dU_plus = 1/2*((aux_velocity_wave2-aux_velocity_wave1)+(mean(mmhg_conversion*zef.nse_field.bp_vessels{i+1}(roi_ind)-mmhg_conversion*zef.nse_field.bp_vessels{i}(roi_ind)))/(nse_field.rho*c(i)));
       dU_minus = 1/2*((aux_velocity_wave2-aux_velocity_wave1)-(mean(mmhg_conversion*zef.nse_field.bp_vessels{i+1}(roi_ind)-mmhg_conversion*zef.nse_field.bp_vessels{i}(roi_ind)))/(nse_field.rho*c(i)));
        
       dP_plus = dP_plus/mmhg_conversion;
       dP_minus = dP_minus/mmhg_conversion;
        
        pressure_total_sum_plus = pressure_total_sum_plus + dP_plus;
        pressure_total_sum_minus = pressure_total_sum_minus + dP_minus; 
        
       forward_pressure(i) = pressure_total_sum_plus + nse_field.pressure;
       backward_pressure(i) = pressure_total_sum_minus + nse_field.pressure;

       velocity_total_sum_plus = velocity_total_sum_plus - 0.5*dU_plus;
       velocity_total_sum_minus = velocity_total_sum_minus + 0.5*dU_minus;
       forward_velocity(i) = velocity_total_sum_plus;
       backward_velocity(i) = velocity_total_sum_minus;

%         forward_velocity(i) = dP_plus./(nse_field.rho.*c(i));
%         backward_velocity(i) = dP_minus./(nse_field.rho.*c(i));
    end

intensities = zeros(n_time-1,1);

for i=1:n_time-1
    aux_velocity_wave1 =  dir_aux(:,1).*zef.nse_field.bv_vessels_1{i}(roi_ind)+dir_aux(:,2).*zef.nse_field.bv_vessels_2{i}(roi_ind)+dir_aux(:,3).*zef.nse_field.bv_vessels_3{i}(roi_ind);
    aux_velocity_wave2 =  dir_aux(:,1).*zef.nse_field.bv_vessels_1{i+1}(roi_ind)+dir_aux(:,2).*zef.nse_field.bv_vessels_2{i+1}(roi_ind)+dir_aux(:,3).*zef.nse_field.bv_vessels_3{i+1}(roi_ind,1);
    intensities(i) = mean((zef.nse_field.bp_vessels{i+1}(roi_ind)-zef.nse_field.bp_vessels{i}(roi_ind)).*(aux_velocity_wave2-aux_velocity_wave1));
end

forward_pressure = interp1(1:n_time-1,forward_pressure,linspace(1,n_time-1,n_time));
backward_pressure = interp1(1:n_time-1,backward_pressure,linspace(1,n_time-1,n_time));
forward_velocity = interp1(1:n_time-1,forward_velocity,linspace(1,n_time-1,n_time));
backward_velocity = interp1(1:n_time-1,backward_velocity,linspace(1,n_time-1,n_time));
intensities = interp1(1:n_time-1,intensities,linspace(1,n_time-1,n_time));

min_correction = min([forward_velocity(:); backward_velocity(:)]);
forward_velocity = forward_velocity - min_correction;
backward_velocity = backward_velocity - min_correction;

if sum(forward_velocity) < sum(backward_velocity)
aux_vec = forward_velocity;
forward_velocity = backward_velocity;
backward_velocity = aux_vec;

aux_vec = forward_pressure;
forward_pressure = backward_pressure;
backward_pressure = aux_vec;
end



end
