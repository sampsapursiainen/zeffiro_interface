function zef = zef_ES_optimizer_properties(zef)
if nargin == 0
    zef = evalin('base','zef');
end

zef_data = zef_ES_optimizer_properties_app;

zef.h_ES_optimizer_properties_copy_all  = zef_data.h_ES_optimizer_properties_copy_all;
zef.h_ES_optimizer_properties           = zef_data.h_ES_optimizer_properties;
zef.h_ES_optimizer_properties_table     = zef_data.h_ES_optimizer_properties_table;

zef.h_ES_optimizer_properties.Position(3)       = 1.5*zef.h_ES_optimizer_properties.Position(3);
zef.h_ES_optimizer_properties_table.Position(3) = 1.54*zef.h_ES_optimizer_properties_table.Position(3);
zef.h_ES_optimizer_properties_table.ColumnName  = {'Parameter name','Value','Average deviation','Maximum deviation'};

set(findobj(zef.h_ES_optimizer_properties.Children,'-property','FontUnits'),'FontUnits','pixels');
set(findobj(zef.h_ES_optimizer_properties.Children,'-property','FontSize'),'FontSize',zef.font_size);

zef.h_ES_optimizer_properties_copy_all.MenuSelectedFcn = 'zef.ES_temp = zef.h_ES_optimizer_properties_table.Data''; clipboard(''copy'',sprintf(''%s\t%5.10g\n'', zef.ES_temp{:})); zef = rmfield(zef,''ES_temp'');';
%% Autoresize
set(zef.h_ES_optimizer_properties,'Name',['ZEFFIRO Interface: ES optimizer properties ' num2str(1+length(findall(groot,'-regexp','Name','ZEFFIRO Interface: ES optimizer properties*')))]);
set(zef.h_ES_optimizer_properties,'AutoResizeChildren','off');
zef.h_ES_optimizer_properties_current_size = get(zef.h_ES_optimizer_properties,'Position');
set(zef.h_ES_optimizer_properties,'SizeChangedFcn', 'zef.h_ES_optimizer_properties_current_size = zef_change_size_function(zef.h_ES_optimizer_properties, zef.h_ES_optimizer_properties_current_size);');

if nargout == 0
    assignin('base','zef',zef);
end

end