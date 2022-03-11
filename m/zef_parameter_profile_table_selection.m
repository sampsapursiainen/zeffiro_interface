function zef_parameter_profile_table_selection(hObject,eventdata,handles)

parameter_profile_selected = eventdata.Indices(:,1);
parameter_profile_selected = unique(parameter_profile_selected);
parameter_profile_selected = parameter_profile_selected(:)';
evalin('base',['zef.parameter_profile_selected =[' num2str(parameter_profile_selected) '];']);

end
