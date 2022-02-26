function zef_delete_transform

if not(evalin('base','zef.lock_transforms_on'))

table_data = evalin('base','zef.h_transform_table.Data');
transforms_selected = evalin('base','zef.transforms_selected');

for i = 1 : length(transforms_selected)

    evalin('base',['zef.h_transform_table.Data{' num2str(table_data{transforms_selected(i),1}) '} = NaN;'])

end

evalin('base','run(''zef_update_transform'')');

end

end