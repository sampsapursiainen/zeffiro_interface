[zef.yesno] = questdlg('Substitute raw data with processed data?','Yes','No');
if isequal(zef.yesno,'Yes');
zef_filter_raw_data;

zef.raw_data = zef.processed_data;

end;