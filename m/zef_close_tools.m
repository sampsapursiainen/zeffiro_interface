%Copyright © 2018- Sampsa Pursiainen & ZI Development Team
%See: https://github.com/sampsapursiainen/zeffiro_interface
zef.h_tools_aux = findall(groot, 'Type','figure','-regexp','Name','ZEFFIRO Interface:*');
zef.h_tools_aux = setdiff(zef.h_tools_aux, findall(groot, 'Type','figure','-regexp','Name','ZEFFIRO Interface: Segmentation tool*'));
zef.h_tools_aux = setdiff(zef.h_tools_aux, findall(groot, 'Type','figure','-regexp','Name','ZEFFIRO Interface: Figure tool*'));
zef.h_tools_aux = setdiff(zef.h_tools_aux, findall(groot, 'Type','figure','-regexp','Name','ZEFFIRO Interface: Menu tool*'));
%zef.h_tools_aux = findall(groot,'-property','ZefTool','-not','ZefTool','zef_segmentation_tool','-not','ZefTool','zef_menu_tool');
zef.h_tools_aux = zef.h_tools_aux(find(isvalid(zef.h_tools_aux)));
delete(zef.h_tools_aux);
zef = rmfield(zef,'h_tools_aux');
