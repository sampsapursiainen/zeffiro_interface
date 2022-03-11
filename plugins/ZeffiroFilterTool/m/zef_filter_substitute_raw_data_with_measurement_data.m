[zef.yesno] = questdlg('Substitute raw data with measurement data?','Yes','No');
if isequal(zef.yesno,'Yes');

if zef.filter_data_segment > 0
    if not(iscell(zef.measurements))
        zef.measurements = cell(0);
    end
zef.raw_data = zef.measurements{zef.filter_data_segment};
else
zef.raw_data = zef.measurements;
end

end;
