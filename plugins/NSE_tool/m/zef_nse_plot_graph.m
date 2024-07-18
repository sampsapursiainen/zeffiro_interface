function zef_nse_plot_graph(zef, nse_field)

if nargin == 0
    zef = evalin('base','zef');
    nse_field = evalin('base','zef.nse_field');
end

if zef.nse_field.graph_type == 1
    roi_ind = zef_nse_roi_ind(zef, nse_field);
    plot_vec = zeros(length(nse_field.bp_vessels),1);
    for i = 1 : length(nse_field.bp_vessels)
    plot_vec(i) = mean(nse_field.bp_vessels{i}(roi_ind));
    end
    zef_nse_plot_full(zef,zef.nse_field,plot_vec,'Pressure (mmHg)');
end

if zef.nse_field.graph_type == 2
    roi_ind = zef_nse_roi_ind(zef, nse_field);
    plot_vec = zeros(length(nse_field.bp_vessels),1);
    for i = 1 : length(nse_field.bp_vessels)
    plot_vec(i) = mean(nse_field.bp_vessels{i}(roi_ind));
    end
    zef_nse_plot_epoched(zef,zef.nse_field,plot_vec,'Pressure (mmHg)',[]);
end

if zef.nse_field.graph_type == 3
    [forward_wave, backward_wave] = zef_nse_separate_waves_roi(zef, nse_field);
    plot_vec = [forward_wave(:) backward_wave(:)];
    zef_nse_plot_full(zef,zef.nse_field,plot_vec,'Pressure (mmHg)',{'Forward','Backward'});
end

if zef.nse_field.graph_type == 4
    [plot_vec] = zef_nse_separate_waves_roi(zef, nse_field);
    zef_nse_plot_epoched(zef,zef.nse_field,plot_vec,'Pressure (mmHg)',[]);
end

if zef.nse_field.graph_type == 5
    [~, plot_vec] = zef_nse_separate_waves_roi(zef, nse_field);
    zef_nse_plot_epoched(zef,zef.nse_field,plot_vec,'Pressure (mmHg)',[]);
end

if zef.nse_field.graph_type == 6
       roi_ind = zef_nse_roi_ind(zef, nse_field);
    plot_vec = zeros(length(nse_field.bp_vessels),1);
    for i = 1 : length(nse_field.bp_vessels)
    plot_vec(i) = mean(nse_field.bp_vessels{i}(roi_ind));
    end
    zef_nse_plot_histogram(zef,plot_vec,'Pressure (mmHg)');
end

if zef.nse_field.graph_type == 7
    roi_ind = zef_nse_roi_ind(zef, nse_field);
    [~, dir_aux] = zef_nse_mean_velocity_roi(zef,nse_field);
    dir_aux = zef_nse_vel_dir(zef,nse_field);
    plot_vec = zeros(length(nse_field.bv_vessels_1),1);
    for i=1:length(nse_field.bv_vessels_1)
      plot_vec(i) = mean(dir_aux(:,1).*zef.nse_field.bv_vessels_1{i}(roi_ind,1)+dir_aux(:,2).*zef.nse_field.bv_vessels_2{i}(roi_ind)+dir_aux(:,3).*zef.nse_field.bv_vessels_3{i}(roi_ind,1));
%     plot_vec(i) = dir_aux(1).*mean(nse_field.bv_vessels_1{i}(roi_ind))+dir_aux(2).*mean(nse_field.bv_vessels_2{i}(roi_ind))+dir_aux(3).*mean(nse_field.bv_vessels_3{i}(roi_ind));    
    end
    zef_nse_plot_full(zef,zef.nse_field,plot_vec,'Velocity (m/s)');
end

if zef.nse_field.graph_type == 8
    roi_ind = zef_nse_roi_ind(zef, nse_field);
    [~, dir_aux] = zef_nse_mean_velocity_roi(zef,nse_field);
    dir_aux = zef_nse_vel_dir(zef,nse_field);
    plot_vec = zeros(length(nse_field.bv_vessels_1),1);
    for i = 1 : length(nse_field.bv_vessels_1)
        plot_vec(i) = mean(dir_aux(:,1).*zef.nse_field.bv_vessels_1{i}(roi_ind,1)+dir_aux(:,2).*zef.nse_field.bv_vessels_2{i}(roi_ind)+dir_aux(:,3).*zef.nse_field.bv_vessels_3{i}(roi_ind,1));
%     plot_vec(i) = dir_aux(1).*mean(nse_field.bv_vessels_1{i}(roi_ind))+dir_aux(2).*mean(nse_field.bv_vessels_2{i}(roi_ind))+dir_aux(3).*mean(nse_field.bv_vessels_3{i}(roi_ind));    
    end
    zef_nse_plot_epoched(zef,zef.nse_field,plot_vec,'Velocity (m/s)',[]);
end

if zef.nse_field.graph_type == 9
    [~, ~,forward_wave, backward_wave] = zef_nse_separate_waves_roi(zef, nse_field);
    plot_vec = [forward_wave(:) backward_wave(:)];
    zef_nse_plot_full(zef,zef.nse_field,plot_vec,'Velocity (m/s)',{'Forward','Backward'});
end

if zef.nse_field.graph_type == 10
    [~, ~,plot_vec] = zef_nse_separate_waves_roi(zef, nse_field);
    zef_nse_plot_epoched(zef,zef.nse_field,plot_vec,'Velocity (m/s)',[]);
end

if zef.nse_field.graph_type == 11
    [~, ~,~, plot_vec] = zef_nse_separate_waves_roi(zef, nse_field);
    zef_nse_plot_epoched(zef,zef.nse_field,plot_vec,'Velocity (m/s)',[]);
end

if zef.nse_field.graph_type == 12
    roi_ind = zef_nse_roi_ind(zef, nse_field);
    [~, dir_aux] = zef_nse_mean_velocity_roi(zef,nse_field);
    plot_vec = zeros(length(nse_field.bv_vessels_1),1);
    for i = 1 : length(nse_field.bv_vessels_1)
    plot_vec(i) = dir_aux(1).*mean(nse_field.bv_vessels_1{i}(roi_ind))+dir_aux(2).*mean(nse_field.bv_vessels_2{i}(roi_ind))+dir_aux(3).*mean(nse_field.bv_vessels_3{i}(roi_ind));    
    end
    zef_nse_plot_histogram(zef,plot_vec,'Velocity (m/s)');
end


if zef.nse_field.graph_type == 13
    roi_ind = zef_nse_roi_ind(zef, nse_field);
    plot_vec = zeros(length(nse_field.mu_vessels),1);
    for i = 1 : length(nse_field.mu_vessels)
    plot_vec(i) = mean(nse_field.mu_vessels{i}(roi_ind));
    end
    zef_nse_plot_full(zef,zef.nse_field,plot_vec,'Viscosity (Pa s)');
end

if zef.nse_field.graph_type == 14
    roi_ind = zef_nse_roi_ind(zef, nse_field);
    plot_vec = zeros(length(nse_field.mu_vessels),1);
    for i = 1 : length(nse_field.mu_vessels)
    plot_vec(i) = mean(nse_field.mu_vessels{i}(roi_ind));
    end
    zef_nse_plot_epoched(zef,zef.nse_field,plot_vec,'Viscosity (Pa s)',[]);
end

if zef.nse_field.graph_type == 15
    roi_ind = zef_nse_roi_ind(zef, nse_field);
    plot_vec = zeros(length(nse_field.mu_vessels),1);
    for i = 1 : length(nse_field.mu_vessels)
    plot_vec(i) = mean(nse_field.mu_vessels{i}(roi_ind));
    end
    zef_nse_plot_histogram(zef,plot_vec,'Viscosity (Pa s)');
end

if zef.nse_field.graph_type == 16
plot_vec = zef_nse_calculate_perfusion(zef.nse_field,zef.nodes,zef.tetra,zef.domain_labels,zef.mvd_length);
zef_nse_plot_full(zef,zef.nse_field,plot_vec,'Perfusion (ml / min)');
end

if zef.nse_field.graph_type == 17
plot_vec = zef_nse_calculate_perfusion(zef.nse_field,zef.nodes,zef.tetra,zef.domain_labels,zef.mvd_length);
zef_nse_plot_epoched(zef,zef.nse_field,plot_vec,'Perfusion (ml / min)',[]);
end

if zef.nse_field.graph_type == 18
plot_vec = zef_nse_calculate_perfusion(zef.nse_field,zef.nodes,zef.tetra,zef.domain_labels,zef.mvd_length);
zef_nse_plot_histogram(zef,zef.nse_field,plot_vec,'Perfusion (ml / min)');
end

if zef.nse_field.graph_type == 19
    zef_nse_plot_signal_pulse(zef, zef.nse_field);
end

if zef.nse_field.graph_type == 20
    mmhg_conversion = 101325/760;
    plot_vec = zef_nse_signal_pulse([0:zef.nse_field.time_step_length:zef.nse_field.cycle_length],zef.nse_field)/mmhg_conversion;
    zef_nse_plot_histogram(zef,plot_vec(:),'Pressure (mmHg)');
end

if zef.nse_field.graph_type == 21
    [roi_ind_1, roi_ind_2] = zef_nse_roi_ind(zef, nse_field);
    plot_vec_1 = zeros(length(nse_field.bf_capillaries),1);
    aux_vec_1 = zeros(length(nse_field.bf_capillaries),1);
    aux_vec_2 = zeros(length(nse_field.bf_capillaries),1);
     for i = 1 : length(nse_field.bf_capillaries)
   plot_vec_1(i) = (mean(nse_field.bf_capillaries{i}(roi_ind_2)));
   aux_vec_1(i) = (mean((nse_field.bf_capillaries{i}(roi_ind_1))));
   aux_vec_2(i) = (mean((nse_field.bf_capillaries{i}(roi_ind_2))));
     end
  scale_val = max(abs(aux_vec_1-aux_vec_1(end)))/max(abs(aux_vec_2-aux_vec_2(end)));
scale_val = scale_val/abs(aux_vec_1(end));
  plot_vec_1 = scale_val*(plot_vec_1-plot_vec_1(end));
    zef_nse_plot_full(zef,zef.nse_field,plot_vec_1,'Concentration (relative)');
end

if zef.nse_field.graph_type == 22
   
    nse_field.roi_radius = 2*nse_field.roi_radius;
    [roi_ind_1,roi_ind_2,roi_ind_3] = zef_nse_roi_ind(zef, nse_field);

    ref_val_1 = nse_field.relative_blood_oxygenation*mean(nse_field.bf_capillaries_background{1}(roi_ind_1));
    ref_val_2 = (1-nse_field.relative_blood_oxygenation)*mean(nse_field.bf_capillaries_background{1}(roi_ind_1));
    plot_vec_1 = zeros(length(nse_field.bf_capillaries),1);
    aux_vec_1 = zeros(length(nse_field.bf_capillaries),1);
    aux_vec_2 = zeros(length(nse_field.bf_capillaries),1);
    aux_vec_4 = zeros(length(nse_field.dh_capillaries),1);
    for i = 1 : length(nse_field.bf_capillaries)
    plot_vec_1(i) = mean(abs(nse_field.bf_capillaries{i}(roi_ind_2)));
    aux_vec_1(i) = mean(abs(nse_field.bf_capillaries{i}(roi_ind_3)));
  aux_vec_2(i) = mean(abs(nse_field.bf_capillaries{i}(roi_ind_2)));
    [aux_vec_3] = abs(nse_field.bf_capillaries{i}(roi_ind_3));
    aux_vec_3 = cumsum(aux_vec_3);
    aux_vec_3 = aux_vec_3./max(aux_vec_3);
    aux_vec_4(i) = (length(roi_ind_1) - find(aux_vec_3 < 0.01, 1, 'last'))/length(roi_ind_1);
    end
%plot_vec_1 = (aux_val_3*plot_vec_1/max(plot_vec_1)) - aux_val_4+1;
scale_val = max(abs(aux_vec_1-aux_vec_1(end)))/max(abs(aux_vec_2-aux_vec_2(end)));
scale_val = scale_val./(ref_val_1*aux_vec_4);
plot_vec_1 = scale_val.*(plot_vec_1-plot_vec_1(end));
plot_vec_1(1) = 0;
scale_val = 1/abs(min(-1,min(plot_vec_1)));
plot_vec_1 = scale_val*plot_vec_1;

plot_vec_2 = zeros(length(nse_field.dh_capillaries),1);
aux_vec_1 = zeros(length(nse_field.dh_capillaries),1);
aux_vec_2 = zeros(length(nse_field.dh_capillaries),1);
aux_vec_4 = zeros(length(nse_field.dh_capillaries),1);
for i = 1 : length(nse_field.dh_capillaries)
    plot_vec_2(i) = mean(abs(nse_field.dh_capillaries{i}(roi_ind_2)));
    aux_vec_1(i) = mean(abs(nse_field.dh_capillaries{i}(roi_ind_3)));
    aux_vec_2(i) = mean(abs(nse_field.dh_capillaries{i}(roi_ind_2)));
    [aux_vec_3] = abs(nse_field.dh_capillaries{i}(roi_ind_3));
    aux_vec_3 = cumsum(aux_vec_3);
    aux_vec_3 = aux_vec_3./max(aux_vec_3);
    aux_vec_4(i) = (length(roi_ind_1) - find(aux_vec_3 < 0.01, 1, 'last'))/length(roi_ind_1);
end

scale_val = max(abs(aux_vec_1-aux_vec_1(end)))/max(abs(aux_vec_2-aux_vec_2(end)));
scale_val = scale_val./(ref_val_2*aux_vec_4);
plot_vec_2 = scale_val.*(plot_vec_2-plot_vec_2(end));
plot_vec_2(1) = 0;
scale_val = 1/abs(min(-1,min(plot_vec_2)));
plot_vec_2 = scale_val*plot_vec_2;
%plot_vec_1 = zeros(size(plot_vec_2));


plot_vec_2b = -1+(1+plot_vec_2)*(ref_val_1 + ref_val_2)./(ref_val_2 + (plot_vec_1+1)*ref_val_1);
plot_vec_1b = -1+(1+plot_vec_1)*(ref_val_2 + ref_val_1)./(ref_val_1 + (plot_vec_2+1)*ref_val_2);

zef_nse_plot_full(zef,zef.nse_field,[plot_vec_2b plot_vec_1b] ,'Oxy/deoxy hemoglobin (relative)');
end

if zef.nse_field.graph_type == 23
   
    [roi_ind_1] = zef_nse_roi_ind(zef, nse_field);

    ref_val_1 = nse_field.relative_blood_oxygenation*mean(nse_field.bf_capillaries_background{1}(roi_ind_1));
    ref_val_2 = (1-nse_field.relative_blood_oxygenation)*mean(nse_field.bf_capillaries_background{1}(roi_ind_1));
    plot_vec_1 = zeros(length(nse_field.bf_capillaries),1);
    for i = 1 : length(nse_field.bf_capillaries)
    aux_val = abs(abs(nse_field.bf_capillaries{i}(roi_ind_1))-abs(nse_field.bf_capillaries{1}(roi_ind_1)));
plot_vec_1(i) = nse_field.roi_radius*(length(find(aux_val > ref_val_1))/length(roi_ind_1)).^(1/3);
    end
    %plot_vec_1 = plot_vec_1-plot_vec_1(end);

 plot_vec_2 = zeros(length(nse_field.dh_capillaries),1); 
 for i = 1 : length(nse_field.dh_capillaries)
    aux_val = abs(abs(nse_field.dh_capillaries{i}(roi_ind_1))-abs(nse_field.dh_capillaries{1}(roi_ind_1)));
plot_vec_2(i) = nse_field.roi_radius*(length(find(aux_val > ref_val_2 ))/length(roi_ind_1)).^(1/3);
 end
    %plot_vec_2 = plot_vec_2-plot_vec_2(end);

zef_nse_plot_full(zef,zef.nse_field,[plot_vec_2 plot_vec_1] ,'Oxy/deoxy hemoglobin peak radius (mm)');
end


end
