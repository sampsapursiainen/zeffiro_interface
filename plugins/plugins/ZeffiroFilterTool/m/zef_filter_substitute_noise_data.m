[zef.yesno] = questdlg('Substitute noise data with processed data?','Yes','No');
if isequal(zef.yesno,'Yes');
zef_filter_raw_data;

zef.noise_data = zef.processed_data;
end
