
function  zef_nse_plot_signal_pulse(zef, nse_field)

h_axes = zef.h_axes1;
axes(h_axes);
c_map = lines(1);
c_map = c_map + 0.1; 
c_map = c_map/max(c_map(:));

mmhg_conversion = 101325/760;

plot_data_time =  [0:nse_field.time_step_length:nse_field.cycle_length];
plot_vec = zef_nse_signal_pulse(plot_data_time,nse_field)/mmhg_conversion;

    h_plot = plot(h_axes,plot_data_time, plot_vec);
    h_plot.Color = c_map(1,:);
    h_plot.LineWidth = 2;

%h_axes.FontSize = 18;
h_axes.XGrid = 'on';
h_axes.YGrid = 'on';
xlabel('Time (s)');
ylabel('Pressure (mmHg)');
set(h_axes,'xlim',[plot_data_time(1) plot_data_time(end)])
set(h_axes,'ylim',[min(plot_vec(:)) 1.05*max(plot_vec(:))])
set(h_axes,'FontSize',zef.font_size);
pbaspect([2 1 1]);

end
