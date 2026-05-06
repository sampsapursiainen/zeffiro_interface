function zef = zef_plot_source_ROI(zef)

%easiest way to get all information, but overkill if we just want to plot a
%sphere
[~,roi_source_pos,s_o,dip_amp,n_multiple_sources,roi_specs_all] = zef_find_source_ROI(zef);
h_axes1 = zef.h_axes1;
hold(h_axes1,'on');
axes(h_axes1)

%using the same handle as regular source tool
if isfield(zef,'h_synth_source')
        h_source = zef.h_synth_source;
        if ishandle(h_source)
            delete(h_source)
        end
end



if zef.h_synth_source_ROI_plot_style.Value == 2 % classic dipoles

     
       h_source = zef_plot_dipoles_in_ROI(zef,roi_source_pos,s_o,dip_amp);
       set(h_source,'Tag','additional: synthetic source');
else
   

    color_cell = {'k','r','g','b','y','m','c'};
    source_color = color_cell{zef.synth_source_ROI(1,19)};

    h_source = zeros(size(n_multiple_sources,1),1);
   



    roi_names = fieldnames(roi_specs_all);

    for i=1:length(roi_names)
        roi_specs = roi_specs_all.(roi_names{i});
        switch roi_specs.shape
            case 1 %disk
                h_source(i) = zef_plot_disk(roi_specs.roi_center,roi_specs.radius,roi_specs.width, roi_specs.ori,roi_specs.curvature,source_color);
            case 2 %sphere
               h_source(i) = zef_plot_sphere(roi_specs.roi_center,roi_specs.radius,source_color);
            case 3 %ellipsoid        
                h_source(i) = zef_plot_ellipsoid(roi_specs.roi_center,roi_specs.radius,roi_specs.radius,roi_specs.width,roi_specs.ori,source_color);
        end
        set(h_source(i),'Tag','additional: synthetic source')
    end

end
    
    
    
  hold(h_axes1,'off');
  zef.h_synth_source = h_source;
       
end
