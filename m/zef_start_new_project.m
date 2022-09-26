%Copyright © 2018- Sampsa Pursiainen & ZI Development Team
%See: https://github.com/sampsapursiainen/zeffiro_interface
if zef.use_display
zef = zeffiro_interface('restart');
else
zef = zeffiro_interface('restart','start_mode','nodisplay');
end

zef = zef_delete_all_compartments(zef);
