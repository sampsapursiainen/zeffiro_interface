function zef_segmentation_tool_toggle(zef,h_button)

if isequal(h_button.UserData,1)
h_button.UserData = 0; 
position_vec = zef.h_zeffiro_window_main.Position; 
position_vec(3) = 0.505*position_vec(3);
else 
h_button.UserData = 1; 
position_vec = zef.h_zeffiro_window_main.Position; 
position_vec(3) = position_vec(3)/0.505;
end

warning off
zef.h_zeffiro_window_main.SizeChangedFcn = '';
zef.h_zeffiro_window_main.Position = position_vec;
zef_set_size_change_function(zef.h_zeffiro_window_main);
warning on

end