%Copyright © 2018- Sampsa Pursiainen & ZI Development Team
%See: https://github.com/sampsapursiainen/zeffiro_interface
function zef_make_butterfly_plot(zef)

    zef.inv_sampling_frequency = zef.bf_sampling_frequency;
    zef.inv_low_cut_frequency = zef.bf_low_cut_frequency;
    zef.inv_high_cut_frequency = zef.bf_high_cut_frequency;
    zef.inv_data_segment = zef.bf_data_segment;
    zef.inv_time_1 = zef.bf_time_1;
    zef.inv_time_2 = zef.bf_time_2;
    zef.inv_normalize_data = zef.bf_normalize_data; 
    
f = zef_getFilteredData(zef);
zef.inv_time_interval_averaging = 0;
[f,t] = zef_getTimeStep(f,1,zef); 

axes(eval('zef.h_axes1'));
cla(eval('zef.h_axes1'),'reset');
hold(eval('zef.h_axes1'),'off');
h_plot = plot(t',f');
set(h_plot,'linewidth',0.5);
set(zef.h_axes1,'xlim',[t(1) t(end)]);
f_range = max(f(:))-min(f(:));
set(gca,'ylim',[min(f(:))-0.05*f_range max(f(:))+0.05*f_range]);
set(eval('zef.h_axes1'),'ygrid','on');
set(eval('zef.h_axes1'),'xgrid','on');
set(eval('zef.h_axes1'),'fontsize',zef.font_size);
set(eval('zef.h_axes1'),'linewidth',0.5);
set(zef.h_axes1,'box','on');
end
