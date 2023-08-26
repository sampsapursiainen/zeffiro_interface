
c_ind_1_domain = find(ismember(zef.domain_labels,zef.nse_field.artery_domain_ind));
[v_1_nodes, v_1_tetra, ~] = zef_get_submesh(zef.nodes, zef.tetra, c_ind_1_domain);
found = find(abs(v_1_nodes(145873,1)-v_1_nodes(:,1))<=1.5 & abs(v_1_nodes(145873,2)-v_1_nodes(:,2))<=1.5 & abs(v_1_nodes(145873,3)-v_1_nodes(:,3))<=1.5);
found2 = find(abs(v_1_nodes(73405,1)-v_1_nodes(:,1))<=2.4 & abs(v_1_nodes(73405,2)-v_1_nodes(:,2))<=2.4 & abs(v_1_nodes(73405,3)-v_1_nodes(:,3))<=2.4);

dir_aux = -v_1_nodes(found,:)+v_1_nodes(147109,:);
dir_aux = dir_aux./sqrt(dir_aux(:,1).^2+dir_aux(:,2).^2+dir_aux(:,3).^2);
dir_aux2 = v_1_nodes(75640,:)-v_1_nodes(found2,:);
dir_aux2 = dir_aux2./sqrt(dir_aux2(:,1).^2+dir_aux2(:,2).^2+dir_aux2(:,3).^2);

clear aux_backward_pressure_wave aux_forward_pressure_wave;

%%

aux_forward_pressure_wave = zeros(size(zef.nse_field.bp_vessels,2)-1,1);
aux_backward_pressure_wave = zeros(size(zef.nse_field.bp_vessels,2)-1,1);
aux_forward_velocity_wave = zeros(size(zef.nse_field.bp_vessels,2)-1,1);
aux_backward_velocity_wave = zeros(size(zef.nse_field.bp_vessels,2)-1,1);
time_vec_aux = [0:zef.nse_field.time_step_length:zef.nse_field.time_length];
time_cycle_aux = size([0:zef.nse_field.time_step_length:zef.nse_field.cycle_length],2);
start_ind = find(time_vec_aux>zef.nse_field.start_time,1,'first');
time_cycle_start_aux = time_cycle_aux*ceil(start_ind/time_cycle_aux)-start_ind;
cycle_frame_length1 =  find(time_vec_aux-zef.nse_field.start_time >= zef.nse_field.cycle_length,1,'first');
cycle_frame_length2 =  find(time_vec_aux-zef.nse_field.start_time >= 2*zef.nse_field.cycle_length,1,'first');
time_frame_ind = [start_ind:ceil((length(time_vec_aux)-start_ind)/zef.nse_field.n_frames):length(time_vec_aux)];
cycle_time_vec = cycle_frame_length2-cycle_frame_length1;
cycle_frame_start = find(time_frame_ind>=start_ind+time_cycle_start_aux,1,'first');
cycle_frame_length = find(time_frame_ind-start_ind >= time_cycle_aux,1,'first');
y = zef_nse_signal_pulse(time_vec_aux,zef.nse_field);

steps = floor(((size(aux_forward_pressure_wave,1)-(cycle_frame_start))/cycle_frame_length))+1;
time_s = zef.nse_field.time_step_length;
time_s = 1;

cycles_frames = [1 cycle_frame_start:cycle_frame_length:steps*(cycle_frame_length) size(aux_forward_pressure_wave,1)];
cycles_frames = unique(cycles_frames);
pressure_total_sum = 0;
direction = dir_aux;
region = found;
P0 = mean(zef.nse_field.bp_vessels{1,1}(region));
U0 = mean(direction(:,1).*zef.nse_field.bv_vessels_1{1,1}(region,1)+direction(:,2).*zef.nse_field.bv_vessels_2{1,1}(region)+direction(:,3).*zef.nse_field.bv_vessels_3{1,1}(region,1));
steps = length(cycles_frames)-1;
for i=1:1
    pressure_sum = 0;
    velocity_sum = 0;
    for j=cycles_frames(1):cycles_frames(1+1)-1
        pressure_sum = pressure_sum + ((mean(zef.nse_field.bp_vessels{1,j+1}(region))-mean(zef.nse_field.bp_vessels{1,j}(region)))/time_s)^2;
        aux_velocity_wave1 =  mean(direction(:,1).*zef.nse_field.bv_vessels_1{1,j}(region,1)+direction(:,2).*zef.nse_field.bv_vessels_2{1,j}(region)+direction(:,3).*zef.nse_field.bv_vessels_3{1,j}(region,1));
        aux_velocity_wave2 =  mean(direction(:,1).*zef.nse_field.bv_vessels_1{1,j+1}(region,1)+direction(:,2).*zef.nse_field.bv_vessels_2{1,j+1}(region)+direction(:,3).*zef.nse_field.bv_vessels_3{1,j+1}(region,1));
        velocity_sum = velocity_sum + ((aux_velocity_wave2-aux_velocity_wave1)/time_s)^2;
    end   
    c = 1/1050*sqrt(pressure_sum/velocity_sum);

%     multiplier = 1;
    pressure_total_sum_plus = 0;
    pressure_total_sum_minus = 0;
    velocity_total_sum_plus = 0;
    velocity_total_sum_minus = 0;
    for i2 =1:length(zef.nse_field.bp_vessels)-1 % cycles_frames(i):cycles_frames(i+1)-1  %cycles_frames(i+1)-1
        aux_velocity_wave1 =  mean(direction(:,1).*zef.nse_field.bv_vessels_1{1,i2}(region,1)+direction(:,2).*zef.nse_field.bv_vessels_2{1,i2}(region)+direction(:,3).*zef.nse_field.bv_vessels_3{1,i2}(region,1));
        aux_velocity_wave2 =  mean(direction(:,1).*zef.nse_field.bv_vessels_1{1,i2+1}(region,1)+direction(:,2).*zef.nse_field.bv_vessels_2{1,i2+1}(region)+direction(:,3).*zef.nse_field.bv_vessels_3{1,i2+1}(region,1));
%         dP_plus = 1/2*(((mean(zef.nse_field.bp_vessels{1,i2+1}(region))-mean(zef.nse_field.bp_vessels{1,i2}(region)))/time_s)+1050*c*((aux_velocity_wave2-aux_velocity_wave1)/time_s));
%         dP_minus = 1/2*(((mean(zef.nse_field.bp_vessels{1,i2+1}(region))-mean(zef.nse_field.bp_vessels{1,i2}(region)))/time_s)-1050*c*((aux_velocity_wave2-aux_velocity_wave1)/time_s));
        dP_minus = 1/2*(mean(zef.nse_field.bp_vessels{1,i2}(region))-1050*c*aux_velocity_wave1);
        dP_plus = 1/2*(mean(zef.nse_field.bp_vessels{1,i2}(region))+1050*c*aux_velocity_wave1);   
        pressure_total_sum_minus = dP_minus;
        pressure_total_sum_plus =  dP_plus;
%         
% 
%         pressure_total_sum_plus = pressure_total_sum_plus + dP_plus;
%         pressure_total_sum_minus = pressure_total_sum_minus + dP_minus; 
% %     
        aux_forward_pressure_wave(i2) = pressure_total_sum_plus;
        aux_backward_pressure_wave(i2) = pressure_total_sum_minus;
% 
%         aux_forward_pressure_wave(i2) = pressure_total_sum_plus + P0 ;
%         aux_backward_pressure_wave(i2) = pressure_total_sum_minus + P0;
% 
        aux_forward_velocity_wave(i2) = dP_plus/(1050*c);
        aux_backward_velocity_wave(i2) = -dP_minus/(1050*c);
%         dU_plus = 1/2*((aux_velocity_wave2-aux_velocity_wave1)+(mean(zef.nse_field.bp_vessels{1,i2+1}(region))-mean(zef.nse_field.bp_vessels{1,i2}(region)))/(c*1050));
%         dU_minus = 1/2*((aux_velocity_wave2-aux_velocity_wave1)-(mean(zef.nse_field.bp_vessels{1,i2+1}(region))-mean(zef.nse_field.bp_vessels{1,i2}(region)))/(c*1050));
%         velocity_total_sum_plus = velocity_total_sum_plus + dU_plus;
%         velocity_total_sum_minus = velocity_total_sum_minus + dU_minus;
%         aux_forward_velocity_wave(i2) = velocity_total_sum_plus + U0;
%         aux_backward_velocity_wave(i2) = velocity_total_sum_minus + U0;
%         if i2>=cycles_frames(i)
%             aux_forward_pressure_wave(i2) = pressure_total_sum_plus ;
%             aux_backward_pressure_wave(i2) = pressure_total_sum_minus ;
%             aux_forward_pressure_wave(i2) = pressure_total_sum_plus + P0;
%             aux_backward_pressure_wave(i2) = pressure_total_sum_minus + P0 ;
%         end
    end
%     multiplier = multiplier + 1;
        
end

intensities = zeros(size(aux_forward_pressure_wave,1),1);
for i=1:size(aux_forward_pressure_wave,1)-1
%     aux_velocity_wave1 =  mean(direction(:,1).*zef.nse_field.bv_vessels_1{1,i}(region,1)+direction(:,2).*zef.nse_field.bv_vessels_2{1,i}(region)+direction(:,3).*zef.nse_field.bv_vessels_3{1,i}(region,1));
%     aux_velocity_wave2 =  mean(direction(:,1).*zef.nse_field.bv_vessels_1{1,i+1}(region,1)+direction(:,2).*zef.nse_field.bv_vessels_2{1,i+1}(region)+direction(:,3).*zef.nse_field.bv_vessels_3{1,i+1}(region,1));
%     intensities(i) = mean((zef.nse_field.bp_vessels{1,i+1}(region))-mean(zef.nse_field.bp_vessels{1,i}(region)))*(aux_velocity_wave2-aux_velocity_wave1);
    
    aux_velocity_wave1 =  direction(:,1).*zef.nse_field.bv_vessels_1{1,i}(region,1)+direction(:,2).*zef.nse_field.bv_vessels_2{1,i}(region)+direction(:,3).*zef.nse_field.bv_vessels_3{1,i}(region,1);
    aux_velocity_wave2 =  direction(:,1).*zef.nse_field.bv_vessels_1{1,i+1}(region,1)+direction(:,2).*zef.nse_field.bv_vessels_2{1,i+1}(region)+direction(:,3).*zef.nse_field.bv_vessels_3{1,i+1}(region,1);
    intensities(i) = mean((zef.nse_field.bp_vessels{1,i+1}(region)-zef.nse_field.bp_vessels{1,i}(region)).*(aux_velocity_wave2-aux_velocity_wave1));

end

aux_forward_pressure_wave = 2*aux_forward_pressure_wave;
aux_backward_pressure_wave = 2*aux_backward_pressure_wave;

time_vec = linspace(zef.nse_field.start_time, zef.nse_field.time_length,length(aux_forward_pressure_wave));

figure(6); clf;
hold on
plot(time_vec,aux_forward_pressure_wave,'r')
plot(time_vec,aux_backward_pressure_wave,'g')
hold off
% figure
% hold on
% plot(1:size(aux_forward_pressure_wave,1),aux_forward_velocity_wave,'r')
% plot(1:size(aux_forward_pressure_wave,1),aux_backward_velocity_wave,'g')
% hold off
figure(1)
plot(1:size(aux_forward_pressure_wave,1),intensities)
h_axes = gca;
h_axes.FontSize = 18;
h_axes.XGrid = 'on';
h_axes.YGrid = 'on';
xlabel('Time (s)')
ylabel('Intentsity (W/m^2)')