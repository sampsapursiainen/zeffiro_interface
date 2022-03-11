[zef.yesno] = questdlg('Substitute measurement data with processed data?','Yes','No');
if isequal(zef.yesno,'Yes');
zef_filter_raw_data;

if zef.filter_data_segment > 0
    if not(iscell(zef.measurements))
        zef.measurements = cell(0);
    end
zef.measurements{zef.filter_data_segment} = zef.processed_data;
else
zef.measurements = zef.processed_data;
end

end;
