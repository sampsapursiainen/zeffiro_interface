
function  zef_nse_plot_epoched(zef, nse_field, plot_vec, y_label, plot_vec_ref)

h_axes = zef.h_axes1;
axes(h_axes);

perform_shift = true;

if nargin < 5
plot_vec_ref = [];
elseif isempty(plot_vec_ref)
    perform_shift = false;
end

plot_colors = {'c', 'c'};
plot_quantiles = [ 0.0 0.5 1]; 
plot_linestyle = {'--','-','--'};
n_time = length(plot_vec);
time_step_length_aux = (nse_field.time_length - nse_field.start_time)/(n_time-1);
time_vec_aux = [nse_field.start_time:time_step_length_aux:nse_field.time_length];
n_epoch =  find(time_vec_aux-nse_field.start_time >= nse_field.cycle_length,1,'first')-1;

epoch_data = zeros(n_epoch,ceil(n_time/n_epoch));
if not(isempty(plot_vec_ref))
    epoch_data_2 = epoch_data;
end

for i = 1 : ceil(n_time/n_epoch)
start_ind = n_epoch*(i-1)+1;
end_ind =  min(n_time,n_epoch*i);
epoch_data(1:end_ind-start_ind+1,i) = plot_vec(start_ind:end_ind); 
if not(isempty(plot_vec_ref))
epoch_data_2(1:end_ind-start_ind+1,i) = plot_vec_ref(start_ind:end_ind); 
end
end

plot_data = zeros(n_epoch,length(plot_quantiles));
if not(isempty(plot_vec_ref))
plot_data_2 = plot_data;
end

if end_ind-start_ind+1 < size(epoch_data,1)
    epoch_data(end_ind-start_ind+2:end,end) = mean(epoch_data(end_ind-start_ind+2:end,1:end-1),2);
if not(isempty(plot_vec_ref))
epoch_data_2(end_ind-start_ind+2:end,end) = mean(epoch_data_2(end_ind-start_ind+2:end,1:end-1),2);
end
end

for i = 1 : length(plot_quantiles)
% if plot_quantiles(i)==0.5
% plot_data(:,i) = 0.5*(quantile(epoch_data,0,2)+quantile(epoch_data,1,2));
% else
aux_plot_vec = repmat(quantile(epoch_data,plot_quantiles(i),2),3,1);
aux_plot_vec = reshape(movmean(aux_plot_vec, ceil(0.05*size(epoch_data,1))),size(epoch_data,1),3);
aux_plot_vec = aux_plot_vec(:,2);
plot_data(:,i) = aux_plot_vec;
if not(isempty(plot_vec_ref))
aux_plot_vec = repmat(quantile(epoch_data_2,plot_quantiles(i),2),3,1);
aux_plot_vec = reshape(movmean(aux_plot_vec, ceil(0.05*size(epoch_data,1))),size(epoch_data,1),3);
aux_plot_vec = aux_plot_vec(:,2);
plot_data_2(:,i) = aux_plot_vec;
end

%end
end


if not(isempty(plot_vec_ref))
    [~, index_shift] = max(plot_data_2(:,length(plot_quantiles)-1)/2);
else
    if perform_shift 
[~, index_shift] = max(plot_data(:,length(plot_quantiles)-1)/2);
    else
        index_shift = 0;
    end
end

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