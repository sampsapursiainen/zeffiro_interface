
function zef_filter_plot_data

f = evalin('base','zef.processed_data');
sampling_freq = evalin('base','zef.filter_sampling_rate');

if size(f,2) > 1
t_vec = double([1:size(f,2)]-1)./sampling_freq;
end

axes(evalin('base','zef.h_axes1'));
cla(evalin('base','zef.h_axes1'));
hold(evalin('base','zef.h_axes1'),'off');
h_plot = plot(t_vec',f');
set(h_plot,'linewidth',1.5);
set(gca,'xlim',[t_vec(1) t_vec(end)]);
f_range = max(f(:))-min(f(:));
set(gca,'ylim',[min(f(:))-0.05*f_range max(f(:))+0.05*f_range]);
set(evalin('base','zef.h_axes1'),'ygrid','on');
set(evalin('base','zef.h_axes1'),'xgrid','on');
set(evalin('base','zef.h_axes1'),'fontsize',14);
set(evalin('base','zef.h_axes1'),'linewidth',2);

set(evalin('base','zef.h_axes1'),'xlim',get(evalin('base','zef.h_axes1'),'xlim')*evalin('base','zef.filter_zoom'));

end
