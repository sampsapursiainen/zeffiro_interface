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
%Figure visualization setups
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
colors = [1,0,0;0,1,0;0,0,1;
          1,0.5,0;0,1,1;1,0,1;
          0.8,0.8,0;0,0.8,0.4;0.5,0,1];
colors = [colors;0.5*colors];
%Available line styles
line_style_cell = {'-','--','-.',':','o-','o--','o-.','o:','s-','s--','s-.','s:','d-','d--','d-.','d:','*-','*--','*-.','*:'};
line_style_ind = 0;
%Check if ground truth is setted and then do a plot loop that plot
%line/bars for every color and then change line style to another if there
%is more sources than colors.
%_ Curve plot _
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

%Set figure ticks
set(zef_temp_axis,'ticklength',[0.01 0.025]);
%Set a nice looking ticks on x axis.
Xtick_scale = min(floor(log10(abs(t_vals(end)))),2);
Interval_reminder = ceil((t_vals(end)-t_vals(1))*10^(-Xtick_scale)/2);
Xtick_interval = 0.25*Interval_reminder*10^Xtick_scale;
if mod(Interval_reminder,4)==0
    Xtick_scale = abs(min(floor(log10(Xtick_interval)),2));
elseif mod(Interval_reminder,4)==2
    Xtick_scale = abs(min(floor(log10(Xtick_interval)),2))+1;
else
    Xtick_scale = abs(min(floor(log10(Xtick_interval)),2))+2;
end
Xtick = round((t_vals(1)-mod(t_vals(1),Xtick_interval)):Xtick_interval:t_vals(end),Xtick_scale);

set(zef_temp_axis,'xtick',Xtick)
set(zef_temp_axis,'xticklabels',num2cell(Xtick))
set(zef_temp_axis,'xlim',[t_vals(1) t_vals(end)]);
set(zef_temp_axis,'xgrid','off');
if evalin('base','zef.find_synth_source.intensity_direction')
    set(zef_temp_axis,'ylim',[(1-0.05*sign(min(y_vals(:))))*min(y_vals(:)), 1.05*max(y_vals(:))]);
else
    set(zef_temp_axis,'ylim',[0 1.05*max(y_vals(:))]);
end
y_scale = 10^floor(log10(max(abs(zef_temp_axis.YLim))));
if floor(max(abs(zef_temp_axis.YLim))/y_scale)<2
    y_scale = 0.1*y_scale;
end
zef_temp_axis.YAxis.TickValues = zef_temp_axis.YLim(1):y_scale:zef_temp_axis.YLim(2);
zef_temp_axis.YAxis.TickLabels = num2cell(zef_temp_axis.YAxis.TickValues);

set(zef_temp_axis,'ygrid','on');
xtickangle(zef_temp_axis,0);
%Set Legend
legend(name_label,'location','eastoutside')
%Change plot to proper size
window_ratio = evalin('base','zef.h_zeffiro.Position(3:4)./[0.239, 0.5134];');
screen_resolution = get(0,'screensize');
screen_resolution = screen_resolution(3:4);
zef_temp_axis.Position(3:4)=[0.1325,0.2821].*window_ratio.*screen_resolution;
zef_temp_axis.Position(1:2)=[0.0125,0.2215*window_ratio(2)].*screen_resolution;
hold(zef_temp_axis,'off');

%_ Bar plot for one time value _
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
xtickangle(zef_temp_axis,30);
set(zef_temp_axis,'ticklength',[0.01 0.025]);
legend(name_label,'location','eastoutside')
%Change plot to proper size
window_ratio = evalin('base','zef.h_zeffiro.Position(3:4)./[0.239, 0.5134];');
screen_resolution = get(0,'screensize');
screen_resolution = screen_resolution(3:4);
zef_temp_axis.Position(3:4)=window_ratio.*[0.1325, 0.281].*screen_resolution;
zef_temp_axis.Position(4)=0.9*zef_temp_axis.Position(4);
zef_temp_axis.Position(2)=window_ratio(2)*0.25*screen_resolution(2);
hold(zef_temp_axis,'off');
end

clear zef_temp_axis
end