%Copyright © 2018- Sampsa Pursiainen & ZI Development Team
%See: https://github.com/sampsapursiainen/zeffiro_interface
function zef_plot_parcellation_time_series(void)

void = [];

time_series = evalin('base','zef.parcellation_time_series');
plot_type = evalin('base','zef.parcellation_plot_type');
selected_list = evalin('base','zef.parcellation_selected');
parcellation_colortable = evalin('base','zef.parcellation_colortable');
parcellation_colormap = evalin('base','zef.parcellation_colormap');
y_string = get(evalin('base','zef.h_parcellation_plot_type'),'string');
y_string = y_string{plot_type};

if size(parcellation_colortable,1) > 0
zef_k = 0;
parcellation_list = cell(0);
for zef_j = 1 : length(parcellation_colortable)
for zef_i = 1 : size(parcellation_colortable{zef_j}{2},1)
    zef_k = zef_k + 1;
    parcellation_list{zef_k} = [parcellation_colortable{zef_j}{1}  ' ' num2str(zef_i,'%03d') ];
end
end
end

plot_type = get(evalin('base','zef.h_time_series_tools_list'),'value');
function_name = str2func(evalin('base',['zef.time_series_tools_file_list{' num2str(plot_type) '}']));
[y_vals, plot_mode] = function_name(time_series);

if plot_mode == 1
x_vals = [1:length(selected_list)]+0.5;
axes(evalin('base','zef.h_axes1'));
cla(evalin('base','zef.h_axes1'));
hold(evalin('base','zef.h_axes1'),'off');
for i = 1 : length(selected_list)
bar(x_vals(i),y_vals(i),0.7,'facecolor',2*parcellation_colormap(selected_list(i)+1,:),'Parent',evalin('base','zef.h_axes1'));
if i == 1
hold(evalin('base','zef.h_axes1'),'on');
end
end
set(evalin('base','zef.h_axes1'),'xticklabel',[]);
set(evalin('base','zef.h_axes1'),'ticklength',[0 0]);
set(evalin('base','zef.h_axes1'),'xlim',[1 length(selected_list)+1]);
set(evalin('base','zef.h_axes1'),'ylim',[0 1.05*max(y_vals)]);
set(evalin('base','zef.h_axes1'),'ygrid','on');
x_labels = text(x_vals-0.25,-0.01*max(y_vals)*ones(size(x_vals)),parcellation_list(selected_list),'Parent',evalin('base','zef.h_axes1'));
y_label = text(1.01*(length(x_vals)+1),1.05*max(y_vals)/2,y_string,'Parent',evalin('base','zef.h_axes1'));
set(x_labels,'HorizontalAlignment','right','VerticalAlignment','top', 'Rotation',90, 'Fontsize', 8);
hold(evalin('base','zef.h_axes1'),'off');
set(x_labels,'HorizontalAlignment','right','VerticalAlignment','top', 'Rotation',90, 'Fontsize', 8);
set(y_label,'HorizontalAlignment','right','VerticalAlignment','top', 'Rotation',90, 'Fontsize', 8);

end

if plot_mode == 2

colormap_size = 4096;
colortune_param = evalin('base','zef.colortune_param');
colormap_cell = evalin('base','zef.colormap_cell');
set(evalin('base','zef.h_zeffiro'),'colormap', evalin('base',[colormap_cell{evalin('base','zef.inv_colormap')} '(' num2str(colortune_param) ',' num2str(colormap_size) ')']));

x_vals = [1:length(selected_list)];
axes(evalin('base','zef.h_axes1'));
cla(evalin('base','zef.h_axes1'));
hold(evalin('base','zef.h_axes1'),'off');
imagesc(y_vals,'Parent',evalin('base','zef.h_axes1'));
set(evalin('base','zef.h_axes1'),'visible','off');
colorbar(evalin('base','zef.h_axes1'),'fontsize',8);
hold(evalin('base','zef.h_axes1'),'on');
set(evalin('base','zef.h_axes1'),'xticklabel',[]);
set(evalin('base','zef.h_axes1'),'ticklength',[0 0]);
x_labels = text(x_vals-0.5,(1.01*(size(y_vals,1)+1)-0.5)*ones(size(x_vals)),parcellation_list(selected_list),'Parent',evalin('base','zef.h_axes1'));
set(x_labels,'HorizontalAlignment','right','VerticalAlignment','top', 'Rotation',90, 'Fontsize', 8);
y_labels = text((-0.05*(length(x_vals)+1)+0.5)*ones(1,length(x_vals(1:2:end))),x_vals(1:2:end)-0.5,parcellation_list(selected_list(1:2:end)),'Parent',evalin('base','zef.h_axes1'));
set(y_labels,'HorizontalAlignment','right','VerticalAlignment','top', 'Rotation',0, 'Fontsize', 8);
hold(evalin('base','zef.h_axes1'),'off');
y_labels = text((-0.01*(length(x_vals)+1)+0.5)*ones(1,length(x_vals(2:2:end))),x_vals(2:2:end)-0.5,parcellation_list(selected_list(2:2:end)),'Parent',evalin('base','zef.h_axes1'));
set(y_labels,'HorizontalAlignment','right','VerticalAlignment','top', 'Rotation',0, 'Fontsize', 8);
set(evalin('base','zef.h_axes1'),'xlim',[0 length(x_vals)+1]);
set(evalin('base','zef.h_axes1'),'ylim',[0 length(x_vals)+1]);
y_label = text((length(x_vals)+1)/2,-0.03*(length(x_vals)+1),y_string,'Parent',evalin('base','zef.h_axes1'));
set(y_label,'HorizontalAlignment','right','VerticalAlignment','top', 'Rotation',0, 'Fontsize', 8);
hold(evalin('base','zef.h_axes1'),'off');

end

if plot_mode == 3

if iscell(evalin('base','zef.reconstruction'))
length_reconstruction_cell = length(evalin('base','zef.reconstruction'));
frame_start = evalin('base','zef.frame_start');
frame_stop = evalin('base','zef.frame_stop');
frame_step = evalin('base','zef.frame_step');
if frame_start == 0
frame_start = 1;
end
if frame_stop == 0
frame_stop = length_reconstruction_cell;
end
frame_start = max(frame_start,1);
frame_start = min(length_reconstruction_cell,frame_start);
frame_stop = max(frame_stop,1);
frame_stop = min(length_reconstruction_cell,frame_stop);
number_of_frames = length([frame_start : frame_step : frame_stop]);
f_ind = [frame_start : frame_step : frame_stop];
x_vals = evalin('base','zef.inv_time_1') + evalin('base','zef.inv_time_2')/2 + frame_step*(f_ind - 1)*evalin('base','zef.inv_time_3');
axes(evalin('base','zef.h_axes1'));
cla(evalin('base','zef.h_axes1'));
hold(evalin('base','zef.h_axes1'),'off');
[color_sort, color_perm] = sortrows(2*parcellation_colormap(selected_list+1,:));
y_vals = y_vals(color_perm,:);

[~,~,color_unique] = unique(color_sort,'rows');
line_style_cell = {'-','--','-.',':','o-','o--','o-.','o:','s-','s--','s-.','s:','d-','d--','d-.','d:','*-','*--','*-.','*:'};
color_unique = [1;color_unique];
line_ind = 0;
for i = 1 : length(selected_list)
if color_unique(i+1) == color_unique(i)
  line_ind = line_ind + 1;
else
    line_ind = 1;
end
  line_ind = min(line_ind,length(line_style_cell));
  line_ind = max(line_ind,1);
h_plot = plot(x_vals,y_vals(i,:),line_style_cell{line_ind});
set(h_plot, 'color',color_sort(i,:),'linewidth',2);
if i == 1
hold(evalin('base','zef.h_axes1'),'on');
end
end
%set(evalin('base','zef.h_axes1'),'xticklabel',[]);
set(evalin('base','zef.h_axes1'),'ticklength',[0 0]);
set(evalin('base','zef.h_axes1'),'xlim',[x_vals(1) x_vals(end)]);
set(evalin('base','zef.h_axes1'),'ylim',[0 1.05*max(y_vals(:))]);
set(evalin('base','zef.h_axes1'),'ygrid','on');
legend(parcellation_list(selected_list(color_perm)))
%x_labels = text(x_vals-0.25,-0.01*max(y_vals)*ones(size(x_vals)),parcellation_list(selected_list),'Parent',evalin('base','zef.h_axes1'));
%y_label = text(1.01*(length(x_vals)+1),1.05*max(y_vals)/2,y_string,'Parent',evalin('base','zef.h_axes1'));
%set(x_labels,'HorizontalAlignment','right','VerticalAlignment','top', 'Rotation',90, 'Fontsize', 8);
hold(evalin('base','zef.h_axes1'),'off');
%set(x_labels,'HorizontalAlignment','right','VerticalAlignment','top', 'Rotation',90, 'Fontsize', 8);
%set(y_label,'HorizontalAlignment','right','VerticalAlignment','top', 'Rotation',90, 'Fontsize', 8);

end

end
