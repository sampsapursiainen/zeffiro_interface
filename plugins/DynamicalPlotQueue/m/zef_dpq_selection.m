function zef_dpq_selection(hObject,eventdata,handles)

functions_selected = eventdata.Indices(:,1)';
evalin('base',['zef.dpq_selected = [' num2str(functions_selected) ']'';']);


end
