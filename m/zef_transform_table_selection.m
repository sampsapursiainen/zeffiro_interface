function zef_transform_table_selection(hObject,eventdata,handles)

transform_selected = eventdata.Indices(1);

evalin('base', ['zef.current_transform = ' num2str(transform_selected) ';']);
evalin('base','run(''zef_init_transform_parameters'')');

end