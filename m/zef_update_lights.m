function lights_vec = zef_update_lights(varargin)

if not(isempty(varargin))
    h_1 = varargin{1};
else
    h_1 = evalin('base','findobj(get(gcf,''Children''),''Tag'',''axes1'');');
end

h_2 = evalin('base','findobj(get(gcf,''Children''),''Tag'',''lightsselection'');');
h_3 = findobj(h_1.Children,'Type','Light');

if h_2.Value == 1

delete(h_3);
    
light(h_1,'Position',[0 0 1],'Style','infinite');
light(h_1,'Position',[0 0 -1],'Style','infinite');

   
elseif h_2.Value == 2

delete(h_3);

elseif h_2.Value == 3

light(h_1,'Position',[1 0 0],'Style','infinite');
light(h_1,'Position',[-1 0 0 ],'Style','infinite');

elseif h_2.Value == 4

light(h_1,'Position',[0 1 0],'Style','infinite');
light(h_1,'Position',[0 -1 0 ],'Style','infinite');

elseif h_2.Value == 5

light(h_1,'Position',[0 0 1],'Style','infinite');
light(h_1,'Position',[0 0 -1 ],'Style','infinite');

elseif h_2.Value == 6

camlight(h_1,'headlight')
    
end

end