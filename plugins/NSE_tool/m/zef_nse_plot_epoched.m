
function  zef_nse_plot_epoched(zef, nse_field, plot_vec, y_label)

h_axes = zef.h_axes1;
axes(h_axes);

plot_colors = {'c', 'c'};
plot_quantiles = [ 0.25 0.5 0.75];
plot_linestyle = {'--','-','--'};
n_time = length(plot_vec);
time_step_length_aux = (nse_field.time_length - nse_field.start_time)/(n_time-1);
time_vec_aux = [nse_field.start_time:time_step_length_aux:nse_field.time_length];
n_epoch =  find(time_vec_aux-nse_field.start_time >= nse_field.cycle_length,1,'first')-1;

epoch_data = zeros(n_epoch,ceil(n_time/n_epoch));

for i = 1 : ceil(n_time/n_epoch)
start_ind = n_epoch*(i-1)+1;
end_ind =  min(n_time,n_epoch*i);
epoch_data(1:end_ind-start_ind+1,i) = plot_vec(start_ind:end_ind); 
end

plot_data = zeros(n_epoch,length(plot_quantiles));

for i = 1 : length(plot_quantiles)

plot_data(:,i) = quantile(epoch_data,plot_quantiles(i),2);

end

[~,index_shift] = max(plot_data(:,length(plot_quantiles)-1)/2);
index_shift = index_shift + floor(size(plot_data,1)/2);
p_vec_aux = round(mod(index_shift+1:n_epoch+index_shift,n_epoch+0.1));

plot_data_time = time_vec_aux(1:n_epoch)-zef.nse_field.start_time;

for i = 1:length(plot_quantiles)-1

h_fill = fill(h_axes, [plot_data_time fliplr(plot_data_time)],[plot_data(p_vec_aux,i)' fliplr(plot_data(p_vec_aux,i+1)')],plot_colors{i});
h_fill.FaceAlpha = 0.5;

if i == 1
    hold on
end

end

for i = 1:length(plot_quantiles)

    h_plot = plot(h_axes,plot_data_time, plot_data(p_vec_aux,i),plot_linestyle{i});
    h_plot.Color = 'k';
    h_plot.LineWidth = 2;

end
hold off;

%h_axes.FontSize = 18;
h_axes.XGrid = 'on';
h_axes.YGrid = 'on';
xlabel('Time (s)');
ylabel(y_label);
set(h_axes,'xlim',[plot_data_time(1) plot_data_time(end)])
set(h_axes,'ylim',[min(plot_data(:)) max(plot_data(:))])
set(h_axes,'FontSize',zef.font_size);
pbaspect([2 1 1]);
delete(h_axes.Legend);

end