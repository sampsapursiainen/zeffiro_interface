function zef_set_menu_size(zef,status)

if isequal(status,'expanded') 
    
if isequal(zef.h_zeffiro_menu.Position(4),0)
   
zef.h_zeffiro_menu.Position(4) = zef.menu_expanded_size;
zef.h_zeffiro_menu.Position(2) = zef.h_zeffiro_menu.Position(2) - zef.menu_expanded_size;

end

elseif isequal(status,'minimized') 

if zef.h_zeffiro_menu.Position(4) > 0 
    
zef.h_zeffiro_menu.Position(4) = 0;
zef.h_zeffiro_menu.Position(2) = zef.h_zeffiro_menu.Position(2) + zef.menu_expanded_size;

end    

end
    
end