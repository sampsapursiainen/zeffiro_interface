%Copyright © 2018- Sampsa Pursiainen & ZI Development Team
%See: https://github.com/sampsapursiainen/zeffiro_interface
function zef = zef_parcellation_tool_open(zef)

zef_init_parcellation;

zef = zef_parcellation_tool_window(zef);
set(zef.h_parcellation_tool,'Name','ZEFFIRO Interface: Parcellation tool');
set(findobj(zef.h_parcellation_tool.Children,'-property','FontUnits'),'FontUnits','pixels')
set(findobj(zef.h_parcellation_tool.Children,'-property','FontSize'),'FontSize',zef.font_size);


if not(isempty(zef.time_series_tools_name_list))
    set(zef.h_time_series_tools_list,'string',zef.time_series_tools_name_list,'Value',1);
end

zef = zef_update_parcellation(zef);

end
