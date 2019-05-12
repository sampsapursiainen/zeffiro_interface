%Copyright © 2018- Sampsa Pursiainen & ZI Development Team
%See: https://github.com/sampsapursiainen/zeffiro_interface
zef.h_fig_aux = findall(groot, 'Type','figure','Name','ZEFFIRO Interface: Figure tool');
close(zef.h_fig_aux); 
rmfield(zef,'h_fig_aux');