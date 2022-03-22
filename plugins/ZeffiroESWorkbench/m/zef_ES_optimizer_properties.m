zef_data = zef_ES_optimizer_properties_app;

zef.h_ES_optimizer_properties       = zef_data.h_ES_optimizer_properties;
zef.h_ES_optimizer_properties_table = zef_data.h_ES_optimizer_properties_table;

set(findobj(zef.h_ES_optimizer_properties.Children,'-property','FontUnits'),'FontUnits','pixels')
set(findobj(zef.h_ES_optimizer_properties.Children,'-property','FontSize'),'FontSize',zef.font_size);

%% Autoresize
set(zef.h_ES_optimizer_properties,'Name','ZEFFIRO Interface: ES optimizer properties');
set(zef.h_ES_optimizer_properties,'AutoResizeChildren','off');
zef.h_ES_optimizer_properties_current_size = get(zef.h_ES_optimizer_properties,'Position');
set(zef.h_ES_optimizer_properties,'SizeChangedFcn', 'zef.h_ES_optimizer_properties_current_size = zef_change_size_function(zef.h_ES_optimizer_properties, zef.h_ES_optimizer_properties_current_size);');
