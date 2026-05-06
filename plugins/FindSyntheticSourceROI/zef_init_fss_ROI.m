%Copyright © 2018- Sampsa Pursiainen & ZI Development Team
%See: https://github.com/sampsapursiainen/zeffiro_interface
if not(isfield(zef,'synth_source_ROI'));
    zef.synth_source_ROI = [1 0 0 0 1 1 0 0 0 0 0 1 1 0 0 10 0 1 1 3];
    
end

set(zef.h_synth_source_ROI_style,'value',zef.synth_source_ROI(1,1));
set(zef.h_synth_source_ROI_radius,'string',num2str(zef.synth_source_ROI(:,2)'));
set(zef.h_synth_source_ROI_width,'string',num2str(zef.synth_source_ROI(:,3)'));
set(zef.h_synth_source_ROI_curvature,'string',num2str(zef.synth_source_ROI(:,4)'));
set(zef.h_synth_source_ROI_ori_settings,'value',zef.synth_source_ROI(1,5));
set(zef.h_synth_source_ROI_ori_x,'string',num2str(zef.synth_source_ROI(:,6)'));
set(zef.h_synth_source_ROI_ori_y,'string',num2str(zef.synth_source_ROI(:,7)'));
set(zef.h_synth_source_ROI_ori_z,'string',num2str(zef.synth_source_ROI(:,8)'));
set(zef.h_synth_source_ROI_x,'string',num2str(zef.synth_source_ROI(:,9)'));
set(zef.h_synth_source_ROI_y,'string',num2str(zef.synth_source_ROI(:,10)'));
set(zef.h_synth_source_ROI_z,'string',num2str(zef.synth_source_ROI(:,11)'));
set(zef.h_synth_source_ROI_dipOri_style,'value',zef.synth_source_ROI(1,12));
set(zef.h_synth_source_ROI_dipOri_x,'string',num2str(zef.synth_source_ROI(:,13)'));
set(zef.h_synth_source_ROI_dipOri_y,'string',num2str(zef.synth_source_ROI(:,14)'));
set(zef.h_synth_source_ROI_dipOri_z,'string',num2str(zef.synth_source_ROI(:,15)'));
set(zef.h_synth_source_ROI_amp,'string',num2str(zef.synth_source_ROI(:,16)'));
set(zef.h_synth_source_ROI_noise,'string',num2str(zef.synth_source_ROI(1,17)'));
set(zef.h_synth_source_ROI_plot_style,'value',zef.synth_source_ROI(1,18));
set(zef.h_synth_source_ROI_color,'value',zef.synth_source_ROI(1,19));
set(zef.h_synth_source_ROI_length,'string',num2str(zef.synth_source_ROI(1,20)'));