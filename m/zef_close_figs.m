%Copyright © 2018- Sampsa Pursiainen & ZI Development Team
%See: https://github.com/sampsapursiainen/zeffiro_interface
if isvalid(zef.h_zeffiro)
    zef.h_zeffiro.DeleteFcn = '';
end
zef.h_fig_aux = findall(groot, 'Type','figure','-regexp','Name','ZEFFIRO Interface: Figure tool*');
%zef.h_fig_aux = findall(groot, '-property','ZefFig');
zef.h_fig_aux = zef.h_fig_aux(find(isvalid(zef.h_fig_aux)));
delete(zef.h_fig_aux);
zef = rmfield(zef,'h_fig_aux');
zef_figure_tool;
