%Copyright © 2018- Sampsa Pursiainen & ZI Development Team
%See: https://github.com/sampsapursiainen/zeffiro_interface
if isequal(zef.use_display,1)
zef = zeffiro_interface('restart');
else
zef = zeffiro_interface('restart','start_mode','nodisplay');
end

zef = zef_delete_all_compartments(zef);
