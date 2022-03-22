function zef_compartment_table_selection(hObject,eventdata,handles)

compartment_selected = eventdata.Indices(1);
compartment_tags = evalin('base','zef.compartment_tags');
compartment_tag_ind = evalin('base','length(zef.compartment_tags)') - compartment_selected + 1;

evalin('base', ['zef.current_compartment = ''' compartment_tags{compartment_tag_ind} ''';']);
evalin('base', ['zef.current_tag = ''' compartment_tags{compartment_tag_ind} ''';']);
evalin('base','run(''zef_init_transform'')');
evalin('base','zef.h_parameters_table.Data = [];');
compartments_selected = eventdata.Indices(:,1);
compartments_selected = unique(compartments_selected);
compartments_selected = compartments_selected(:)';
evalin('base',['zef.compartments_selected =[' num2str(compartments_selected) '];']);

end
