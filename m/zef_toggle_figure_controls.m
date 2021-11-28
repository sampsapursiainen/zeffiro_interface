function zef_toggle_figure_controls(varargin)

toggle_mode = 'unlocked';
toggle_status = evalin('base','zef.toggle_figure_control_status');

if not(isempty(varargin))
toggle_mode = varargin{1};
end

h_zeffiro = evalin('base','zef.h_zeffiro');
h_axes1 = evalin('base','zef.h_axes1');
h = get(h_zeffiro,'children');

for i = 1 : length(h)

if ismember(get(h(i),'Tag'),{'slidertext','slider','colormapselection','colormapselectiontext'})
if get(h(i),'Visible') || isequal(toggle_mode,'finalize')
    set(h(i),'Visible','off')
else
    set(h(i),'Visible','on')
end
end

if isequal(get(h(i),'Tag'),'togglecontrolsbutton')
    h_togglecontrolsbutton = h(i);
    set(h(i),'units','normalized');
togglecontrolsbuttonposition = get(h(i),'position');
    if toggle_status == 1; 
        set(h(i),'Position',[0.8 0.95 0.15 0.05])
    else
         set(h(i),'Position',[0.5 0.95 0.15 0.05])
    end
    set(h(i),'units','pixels');    
end


end


 set(h_axes1,'units','normalize');
 axes_position = get(h_axes1,'position');
if toggle_status == 1 || isequal(toggle_mode,'finalize')
    set(h_axes1,'Position',[0.05 0.34 0.9 0.6]);
    h_colorbar = findobj(h,'Tag','rightcolorbar');
    if not(isempty(h_colorbar))
        set(h_colorbar,'Position',[0.8769 0.647 0.01 0.29]);
    end
else
    set(h_axes1,'Position',[0.05 0.34 0.6 0.6])
        h_colorbar = findobj(h,'Tag','rightcolorbar');
    if not(isempty(h_colorbar))
        set(h_colorbar,'Position',[0.6 0.647 0.01 0.29]);
    end
end

 set(h_axes1,'units','pixels');
 
 if isequal(toggle_mode,'finalize')
      set(h_togglecontrolsbutton,'Visible','off')
 end
 
 if toggle_status == 2 || isequal(toggle_mode,'finalize')
     evalin('base','zef.toggle_figure_control_status = 1;');
 else
     evalin('base','zef.toggle_figure_control_status = 2;');
 end

end

