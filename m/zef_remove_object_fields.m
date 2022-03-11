zef_data.fieldnames = fieldnames(zef_data);
zef_data.remove_fieldnames = cell(0);
zef_j = 0;
for zef_i = 1 : length(zef_data.fieldnames)
    if isobject(evalin('base',['zef_data.' zef_data.fieldnames{zef_i}]))
    zef_j = zef_j + 1;
    zef_data.remove_fieldnames{zef_j} = zef_data.fieldnames{zef_i};
    end
end
zef_data = rmfield(zef_data,zef_data.remove_fieldnames);
zef_data = rmfield(zef_data,{'remove_fieldnames','fieldnames'});
clear zef_i zef_j
