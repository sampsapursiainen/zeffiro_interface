function zef_set_sensor_color

color_vec = uisetcolor;
item_ind = evalin('base','zef.h_sensor_visible_color.Value');
current_sensors = evalin('base','zef.current_sensors');
visible_list = evalin('base',['zef.' current_sensors '_visible_list']);

zef_j = 0;
for zef_i = 1 : length(visible_list)
if visible_list(zef_i) 
zef_j = zef_j + 1;
if zef_j == item_ind
item_ind = zef_i;
break;
end
end
end

item_ind

evalin('base',['zef.' current_sensors '_color_table(' num2str(item_ind) ',:) = [' num2str(color_vec) '];']);

end