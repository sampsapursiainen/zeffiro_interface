function h_source = zef_plot_dipoles_in_ROI(zef,roi_source_pos,s_o,dip_amp)
    %since we are not outputting zef, we can safely change some fields
    %used by the FindSytheticSourceLegacy plugin and then just use the zef_plot_source function
    zef.inv_synth_source = zeros(size(roi_source_pos,1), 10);


    %length
    zef.inv_synth_source(1,9) = zef.synth_source_ROI(1,20);
    %color
    zef.inv_synth_source(1,10) = zef.synth_source_ROI(1,19);
    %now we use all the sources 
    zef.inv_synth_source(:,1:3) = roi_source_pos;
    

    %flip orientation for negative amplitudes
    s_o(dip_amp<0,:)= -s_o(dip_amp<0,:);
    dip_amp = abs(dip_amp);
    zef.inv_synth_source(:,4:6) = s_o;

    zef.inv_synth_source(:,7) = dip_amp;
    
    h_source = zef_plot_source_legacy(zef, 1);
        
end