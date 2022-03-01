%Copyright © 2018- Sampsa Pursiainen & ZI Development Team
%See: https://github.com/sampsapursiainen/zeffiro_interface
zef.h_tools_aux = findall(groot, 'Type','figure','-regexp','Name','ZEFFIRO Interface:*');
zef.h_tools_aux = setdiff(zef.h_tools_aux, findall(groot, 'Type','figure','-regexp','Name','ZEFFIRO Interface: Segmentation tool*'));
zef.h_tools_aux = setdiff(zef.h_tools_aux, findall(groot, 'Type','figure','-regexp','Name','ZEFFIRO Interface: Figure tool*'));
zef.h_tools_aux = zef.h_tools_aux(find(isvalid(zef.h_tools_aux)));
close(zef.h_tools_aux);
rmfield(zef,'h_tools_aux');
