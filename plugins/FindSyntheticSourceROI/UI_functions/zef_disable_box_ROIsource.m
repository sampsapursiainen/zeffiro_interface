function zef = zef_disable_box_ROIsource(zef)

shapeValue =  zef.h_synth_source_ROI_style.Value; 
Ori_style = zef.h_synth_source_ROI_dipOri_style;
Ori_options ={  'Custom','Max SVD direction','Min SVD direction','Normal to cortex','Normal to patch surface'};


switch shapeValue
    case 1 %flat
        set(zef.h_synth_source_ROI_width, 'Enable', 'on');
        set(zef.h_synth_source_ROI_curvature, 'Enable', 'on');
        set(zef.h_synth_source_ROI_ori_x, 'Enable', 'on');
        set(zef.h_synth_source_ROI_ori_y, 'Enable', 'on');
        set(zef.h_synth_source_ROI_ori_z, 'Enable', 'on');
        set(zef.h_synth_source_ROI_ori_settings, 'Enable', 'on');
        
        set(Ori_style, 'String', Ori_options);

            
    case  2  % spherical
        set(zef.h_synth_source_ROI_width, 'Enable', 'off');
        set(zef.h_synth_source_ROI_curvature, 'Enable', 'off');
        set(zef.h_synth_source_ROI_ori_x, 'Enable', 'off');
        set(zef.h_synth_source_ROI_ori_y, 'Enable', 'off');
        set(zef.h_synth_source_ROI_ori_z, 'Enable', 'off');
        set(zef.h_synth_source_ROI_ori_settings, 'Enable', 'off');

        if Ori_style.Value == 5 
            set(Ori_style, 'Value', 1);
        end
        
        set(Ori_style, 'String', Ori_options(1:end-1));
           
    case 3 %ellipsoid
        
        set(zef.h_synth_source_ROI_width, 'Enable', 'on');
        set(zef.h_synth_source_ROI_curvature, 'Enable', 'off');
        set(zef.h_synth_source_ROI_ori_x, 'Enable', 'on');
        set(zef.h_synth_source_ROI_ori_y, 'Enable', 'on');
        set(zef.h_synth_source_ROI_ori_z, 'Enable', 'on');
        set(zef.h_synth_source_ROI_ori_settings, 'Enable', 'on');
        
        set(Ori_style, 'String', Ori_options); 

end


oriValue = zef.h_synth_source_ROI_ori_settings.Value;

if ismember(oriValue, [1 4]) && shapeValue~=2 % custom ROI orientation
       set(zef.h_synth_source_ROI_ori_x, 'Enable', 'on');
       set(zef.h_synth_source_ROI_ori_y, 'Enable', 'on');
       set(zef.h_synth_source_ROI_ori_z, 'Enable', 'on');
else
       set(zef.h_synth_source_ROI_ori_x, 'Enable', 'off');
       set(zef.h_synth_source_ROI_ori_y, 'Enable', 'off');
       set(zef.h_synth_source_ROI_ori_z, 'Enable', 'off');
end
      

dipOriValue = zef.h_synth_source_ROI_dipOri_style.Value;

if ismember(dipOriValue, [1 4])%custom dipole orientation
    set(zef.h_synth_source_ROI_dipOri_x, 'Enable', 'on');
    set(zef.h_synth_source_ROI_dipOri_y, 'Enable', 'on');
    set(zef.h_synth_source_ROI_dipOri_z, 'Enable', 'on');
else
    set(zef.h_synth_source_ROI_dipOri_x, 'Enable', 'off');
    set(zef.h_synth_source_ROI_dipOri_y, 'Enable', 'off');
    set(zef.h_synth_source_ROI_dipOri_z, 'Enable', 'off');

end


plotValue = zef.h_synth_source_ROI_plot_style.Value;

if plotValue == 2
    set(zef.h_synth_source_ROI_length,'Enable','on');
else
    set(zef.h_synth_source_ROI_length,'Enable','off');
end

end