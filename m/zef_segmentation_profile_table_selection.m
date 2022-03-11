function zef_segmentation_profile_table_selection(hObject,eventdata,handles)

segmentation_profile_row_selected = eventdata.Indices(:,1);
segmentation_profile_column_selected = unique(eventdata.Indices(:,2));
segmentation_profile_row_selected = unique(segmentation_profile_row_selected);
segmentation_profile_row_selected = segmentation_profile_row_selected(:)';
segmentation_profile_column_selected = segmentation_profile_column_selected(:)';
evalin('base',['zef.segmentation_profile_row_selected =[' num2str(segmentation_profile_row_selected) '];']);
evalin('base',['zef.segmentation_profile_column_selected =[' num2str(segmentation_profile_column_selected) '];']);

end
