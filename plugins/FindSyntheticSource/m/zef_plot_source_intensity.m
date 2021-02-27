%This function plot intensity as curves or histograms depending on is the
%ground truth setted or not.
function zef_plot_source_intensity

%Get needed variables
if str2num(evalin('base','zef.find_synth_source.h_plot_switch.Value')) == 1
    name_label = evalin('base','zef.find_synth_source.h_source_list.Data(zef.find_synth_source.selected_source)');
    if size(evalin('base','zef.time_sequence'),1) > length(evalin('base','zef.find_synth_source.selected_source'))
    y_vals = evalin('base','zef.time_sequence(zef.find_synth_source.selected_source,:)');
    else
    y_vals = evalin('base','zef.time_sequence');
    end
else
    name_label = evalin('base','zef.find_synth_source.h_source_list.Data');
    y_vals = evalin('base','zef.time_sequence');
end
s_amp = evalin('base','zef.inv_synth_source(:,7)');
t_vals = evalin('base','zef.time_variable');
%representation of intensity:
if evalin('base','zef.find_synth_source.intensity_direction')
    y_vals = s_amp.*y_vals;
else
    y_vals = abs(s_amp.*y_vals);
end
zef_temp_axis = evalin('base','zef.h_axes1');
axes(zef_temp_axis);
cla(zef_temp_axis);
hold(zef_temp_axis,'off');
set(zef_temp_axis,'visible','on')
set(zef_temp_axis,'CLim',[0 1])
set(zef_temp_axis,'CameraUpVector', [0 1 0])
set(zef_temp_axis,'CameraViewAngle', 6.6086)
set(zef_temp_axis,'DataAspectRatio', [1 67.6694 14.4928])
set(zef_temp_axis,'DataAspectRatioMode', 'auto')
set(zef_temp_axis,'TickDir','in')
set(zef_temp_axis,'View',[0 90])
set(zef_temp_axis.Colorbar,'visible','off')
rotate3d(zef_temp_axis,'off')

%Available colors
colors = [1,0,0;0,1,0;0,0,1;1,0,1;0.4,0.8,0.4;0.4,0.4,1;1,0.4,0.7;1,0.5,0];
colors = [colors;0.5*colors];
%Available line styles
line_style_cell = {'-','--','-.',':','o-','o--','o-.','o:','s-','s--','s-.','s:','d-','d--','d-.','d:','*-','*--','*-.','*:'};
line_style_ind = 0;
%Check if ground truth is setted and then do a plot loop that plot
%line/bars for every color and then change line style to another if there 
%is more sources than colors.
if isempty(evalin('base','zef.fss_time_val'))
for i = 1 : length(s_amp)
    if mod(i,size(colors,1)) == 1
        line_style_ind = line_style_ind + 1;
    end
    h_plot = plot(t_vals,y_vals(i,:),line_style_cell{line_style_ind});
    set(h_plot, 'color',colors(mod(i-1,size(colors,1)-1)+1,:),'linewidth',2);
if i == 1
hold(zef_temp_axis,'on');
end
end

%Set figure visualization options
set(zef_temp_axis,'ticklength',[0.01 0.025]);
%Set a nice looking 9 tick x axis.
Xtick_interval = (t_vals(end)-t_vals(1))/8;
Xtick_scale = abs(min(floor(log10(mean(abs(t_vals)))),2));
Xtick = round(t_vals(1):Xtick_interval:t_vals(end),Xtick_scale);
if std(diff(Xtick))/mean(diff(Xtick))>0.05
    Xtick = round(t_vals(1):Xtick_interval:t_vals(end),Xtick_scale+1);
end

set(zef_temp_axis,'xtick',Xtick)
set(zef_temp_axis,'xticklabels',num2cell(Xtick))
set(zef_temp_axis,'xlim',[t_vals(1) t_vals(end)]);
if evalin('base','zef.find_synth_source.intensity_direction')
    set(zef_temp_axis,'ylim',[(1-0.05*sign(min(y_vals(:))))*min(y_vals(:)), 1.05*max(y_vals(:))]);
else
    set(zef_temp_axis,'ylim',[0 1.05*max(y_vals(:))]);
end
set(zef_temp_axis,'ygrid','on');
legend(name_label,'location','eastoutside')
hold(zef_temp_axis,'off');
else
    y_vals = y_vals(:,length(t_vals(t_vals<=evalin('base','zef.fss_time_val'))));
for i = 1 : length(s_amp)
    if mod(i,size(colors,1)) == 1
        line_style_ind = line_style_ind + 1;
    end
    bar(i,y_vals(i),0.7,'facecolor',colors(mod(i-1,size(colors,1)-1)+1,:));
    if i == 1
        hold(zef_temp_axis,'on');
    end
end
%Set source names from UItable to labels of x axis
set(zef_temp_axis,'xticklabel',name_label);
%Set a tick for every source
xticks(zef_temp_axis,1:length(s_amp));
set(zef_temp_axis,'xlim',[-0.15, (1.15+length(s_amp))]);
if evalin('base','zef.find_synth_source.intensity_direction')
    set(zef_temp_axis,'ylim',[(1-0.05*sign(min(y_vals(:))))*min(y_vals(:)), 1.05*max(y_vals(:))]);
else
    set(zef_temp_axis,'ylim',[0 1.05*max(y_vals(:))]);
end
set(zef_temp_axis,'ygrid','on');
%Angle of source names on x axis
xtickangle(zef_temp_axis,0);
set(zef_temp_axis,'ticklength',[0.01 0.025]);
legend(name_label,'location','eastoutside')
hold(zef_temp_axis,'off');
end

clear zef_temp_axis
end