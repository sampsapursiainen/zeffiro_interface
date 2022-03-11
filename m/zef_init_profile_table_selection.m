function zef_init_profile_table_selection(hObject,eventdata,handles)

init_profile_selected = eventdata.Indices(:,1);
init_profile_selected = unique(init_profile_selected);
init_profile_selected = init_profile_selected(:)';
evalin('base',['zef.init_profile_selected =[' num2str(init_profile_selected) '];']);
end
