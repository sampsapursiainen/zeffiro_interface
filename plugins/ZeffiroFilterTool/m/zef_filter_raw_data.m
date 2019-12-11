zef_update_filter_tool;
zef.processed_data = zef.raw_data;
if isstr(zef.filter_pipeline_selected)
    zef.filter_pipeline_selected = {zef.filter_pipeline_selected};
end
for zef_i = 1 : length(zef.filter_pipeline_selected)
    zef_j = find(ismember(zef.filter_pipeline_list,zef.filter_pipeline_selected{zef_i}),1);
    zef.aux_field = str2func(zef.filter_pipeline{zef_j}.file);
    zef.filter_parameters = zef.filter_pipeline{zef_j}.parameters(:,2);
    zef.processed_data = zef.aux_field(zef.processed_data, zef.filter_parameters{:});
end

clear zef_i zef_j