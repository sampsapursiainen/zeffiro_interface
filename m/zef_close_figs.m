%Copyright © 2018- Sampsa Pursiainen & ZI Development Team
%See: https://github.com/sampsapursiainen/zeffiro_interface
zef.h_fig_aux = findall(groot, 'Type','figure','-regexp','Name','ZEFFIRO Interface: Figure tool*');
zef.h_fig_aux = zef.h_fig_aux(find(isvalid(zef.h_fig_aux)));
delete(zef.h_fig_aux);
rmfield(zef,'h_fig_aux');