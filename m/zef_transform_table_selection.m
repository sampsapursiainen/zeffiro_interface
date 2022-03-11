function zef_transform_table_selection(hObject,eventdata,handles)

transform_selected = eventdata.Indices(1);

evalin('base', ['zef.current_transform = ' num2str(transform_selected) ';']);
evalin('base','run(''zef_init_transform_parameters'')');

transforms_selected = eventdata.Indices(:,1);
transforms_selected = unique(transforms_selected);
transforms_selected = transforms_selected(:)';
evalin('base',['zef.transforms_selected =[' num2str(transforms_selected) '];']);

end
