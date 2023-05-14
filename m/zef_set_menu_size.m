function zef_set_menu_size(zef,status)

if isequal(status,'expanded')

    if isequal(zef.h_zeffiro_menu.Position(4),0)

        zef.h_menu_logo.ImageClickedFcn = 'zef_set_menu_size(zef,''minimized'');';
        zef.h_zeffiro_menu.Position(4) = zef.menu_expanded_size;
        zef.h_zeffiro_menu.Position(2) = zef.h_zeffiro_menu.Position(2) - zef.menu_expanded_size;
        zef.h_menu_logo.Position(1) = 0.1*zef.h_zeffiro_menu.Position(3);
        zef.h_menu_logo.Position(2) = 0.1*zef.h_zeffiro_menu.Position(4);
        zef.h_menu_logo.Position(3) = 0.8*zef.h_zeffiro_menu.Position(3);
        zef.h_menu_logo.Position(4) = 0.8*zef.h_zeffiro_menu.Position(4);

    end

elseif isequal(status,'minimized')

    if zef.h_zeffiro_menu.Position(4) > 0

        zef.h_zeffiro_menu.Position(4) = 0;
        zef.h_zeffiro_menu.Position(2) = zef.h_zeffiro_menu.Position(2) + zef.menu_expanded_size;

    end

end

end
