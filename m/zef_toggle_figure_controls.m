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
        toggle_scale = 83/68;
        set(h(i),'Position',[toggle_scale*h(i).Position(1) h(i).Position(2:4) ])
    else
        toggle_scale = 68/83;
         set(h(i),'Position',[toggle_scale*h(i).Position(1) h(i).Position(2:4)])
    end
    set(h(i),'units','pixels');
end
end

set(h_axes,'units','normalized');
h_colorbar = findobj(h,'Tag','rightColorbar');
set(h_colorbar,'units','normalized');
if toggle_status == 1
    toggle_scale = 83/68;
    set(h_axes,'Position',[toggle_scale*h_axes.Position(1) h_axes.Position(2:4) ]);
    h_colorbar = findobj(h,'Tag','rightColorbar');
    if not(isempty(h_colorbar))
        set(h_colorbar,'Position',[toggle_scale*h_colorbar.Position(1) h_colorbar.Position(2:4) ]);
    end
else
    toggle_scale = 68/83;
    set(h_axes,'Position',[toggle_scale*h_axes.Position(1) h_axes.Position(2:4) ])
        h_colorbar = findobj(h,'Tag','rightColorbar');
    if not(isempty(h_colorbar))
        set(h_colorbar,'Position',[toggle_scale*h_colorbar.Position(1) h_colorbar.Position(2:4) ]);
    end
end

 set(h_axes,'units','pixels');

end

