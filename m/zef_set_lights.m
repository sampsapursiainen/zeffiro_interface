function zef_set_lights(lights_vec)

h_1 = evalin('base','zef.h_axes1');
delete(findobj(h_1.Children,'Type','Light'));

for i = 1 : length(lights_vec)
    
aux_val = lights_vec(i);

if aux_val == 1

light(h_1,'Position',[0 0 1],'Style','infinite');
light(h_1,'Position',[0 0 -1],'Style','infinite');

elseif aux_val == 3

light(h_1,'Position',[1 0 0],'Style','infinite');
light(h_1,'Position',[-1 0 0 ],'Style','infinite');

elseif aux_val == 4

light(h_1,'Position',[0 1 0],'Style','infinite');
light(h_1,'Position',[0 -1 0 ],'Style','infinite');

elseif aux_val == 5

light(h_1,'Position',[0 0 1],'Style','infinite');
light(h_1,'Position',[0 0 -1 ],'Style','infinite');

elseif aux_val == 6

camlight(h_1,'headlight')

end

end