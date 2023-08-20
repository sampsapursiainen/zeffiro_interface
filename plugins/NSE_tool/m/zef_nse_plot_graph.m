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
    zef_nse_plot_epoched(zef,zef.nse_field,plot_vec,'Pressure (mmHg)');
end

if zef.nse_field.graph_type == 3
    [forward_wave, backward_wave] = zef_nse_separate_waves_roi(zef, nse_field);
    plot_vec = [forward_wave(:) backward_wave(:)];
    zef_nse_plot_full(zef,zef.nse_field,plot_vec,'Pressure (mmHg)',{'Forward','Backward'});
end

if zef.nse_field.graph_type == 4
    [plot_vec] = zef_nse_separate_waves_roi(zef, nse_field);
    zef_nse_plot_epoched(zef,zef.nse_field,plot_vec,'Pressure (mmHg)');
end

if zef.nse_field.graph_type == 5
    [~, plot_vec] = zef_nse_separate_waves_roi(zef, nse_field);
    zef_nse_plot_epoched(zef,zef.nse_field,plot_vec,'Pressure (mmHg)');
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
    plot_vec = zeros(length(nse_field.bv_vessels_1),1);
    for i = 1 : length(nse_field.bv_vessels_1)
    plot_vec(i) = dir_aux(1).*mean(nse_field.bv_vessels_1{i}(roi_ind))+dir_aux(2).*mean(nse_field.bv_vessels_2{i}(roi_ind))+dir_aux(3).*mean(nse_field.bv_vessels_3{i}(roi_ind));    
    end
    zef_nse_plot_full(zef,zef.nse_field,plot_vec,'Velocity (m/s)');
end

if zef.nse_field.graph_type == 8
    roi_ind = zef_nse_roi_ind(zef, nse_field);
    [~, dir_aux] = zef_nse_mean_velocity_roi(zef,nse_field);
    plot_vec = zeros(length(nse_field.bv_vessels_1),1);
    for i = 1 : length(nse_field.bv_vessels_1)
    plot_vec(i) = dir_aux(1).*mean(nse_field.bv_vessels_1{i}(roi_ind))+dir_aux(2).*mean(nse_field.bv_vessels_2{i}(roi_ind))+dir_aux(3).*mean(nse_field.bv_vessels_3{i}(roi_ind));    
    end
    zef_nse_plot_epoched(zef,zef.nse_field,plot_vec,'Velocity (m/s)');
end

if zef.nse_field.graph_type == 9
    [~, ~,forward_wave, backward_wave] = zef_nse_separate_waves_roi(zef, nse_field);
    plot_vec = [forward_wave(:) backward_wave(:)];
    zef_nse_plot_full(zef,zef.nse_field,plot_vec,'Velocity (m/s)',{'Forward','Backward'});
end

if zef.nse_field.graph_type == 10
    [~, ~,plot_vec] = zef_nse_separate_waves_roi(zef, nse_field);
    zef_nse_plot_epoched(zef,zef.nse_field,plot_vec,'Velocity (m/s)');
end

if zef.nse_field.graph_type == 11
    [~, ~,~, plot_vec] = zef_nse_separate_waves_roi(zef, nse_field);
    zef_nse_plot_epoched(zef,zef.nse_field,plot_vec,'Velocity (m/s)');
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
    zef_nse_plot_epoched(zef,zef.nse_field,plot_vec,'Viscosity (Pa s)');
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
    zef_nse_plot_signal_pulse(zef, zef.nse_field);
end

if zef.nse_field.graph_type == 17
    mmhg_conversion = 101325/760;
    plot_vec = zef_nse_signal_pulse([0:zef.nse_field.time_step_length:zef.nse_field.cycle_length],zef.nse_field)/mmhg_conversion;
     zef_nse_plot_histogram(zef,plot_vec(:),'Pressure (mmHg)');
end


end
