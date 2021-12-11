function zef_toggle_figure_controls

toggle_mode = 'unlocked';
current_figure = gcf; 
tgb = findobj(get(gcf,'Children'),'Tag','togglecontrolsbutton');
toggle_status = tgb.UserData;
if isempty(toggle_status) 
toggle_status = 1;
tgb.UserData = 2;
elseif isequal(toggle_status,1)
    tgb.UserData = 2; 
elseif isequal(toggle_status,2)
    tgb.UserData = 1;
end

h_figure = evalin('base','gcf');
h_axes = evalin('base','get(gcf, ''CurrentAxes'');');
h = get(h_figure,'children');

for i = 1 : length(h)

if contains(get(h(i),'Tag'),{'slidertext','slider','toggleedgesbutton'})
if get(h(i),'Visible') 
    set(h(i),'Visible','off')
else
    set(h(i),'Visible','on')
end
end

if isequal(get(h(i),'Tag'),'togglecontrolsbutton')
    h_togglecontrolsbutton = h(i);
    set(h(i),'units','normalized');
    togglecontrolsbuttonposition = get(h(i),'position');
    if toggle_status == 1 
        set(h(i),'Position',[0.83 0.95 0.14 0.05])
    else
         set(h(i),'Position',[0.68 0.95 0.14 0.05])
    end
    set(h(i),'units','pixels');    
end
end

set(h_axes,'units','normalize');
axes_position = get(h_axes,'position');
if toggle_status == 1 
    set(h_axes,'Position',[0.05 0.34 0.9 0.6]);
    h_colorbar = findobj(h,'Tag','rightColorbar');
    if not(isempty(h_colorbar))
        set(h_colorbar,'Position',[0.8769 0.647 0.01 0.29]);
    end
else
    set(h_axes,'Position',[0.05 0.34 0.6 0.6])
        h_colorbar = findobj(h,'Tag','rightColorbar');
    if not(isempty(h_colorbar))
        set(h_colorbar,'Position',[0.6 0.647 0.01 0.29]);
    end
end

 set(h_axes,'units','pixels');
 

end

