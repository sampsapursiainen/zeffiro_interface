%Copyright © 2018- Sampsa Pursiainen & ZI Development Team
%See: https://github.com/sampsapursiainen/zeffiro_interface
set(zef.h_filter_pipeline_list,'Value',cell(0),'Items',cell(0),'Multiselect','on');


for zef_i = 1 : length(zef.filter_pipeline) 
zef.filter_pipeline_list{zef_i} = ['Tag: ' zef.filter_pipeline{zef_i}.filter_tag  ', Type: ' zef.filter_pipeline{zef_i}.name ];
end
 
if not(isempty(zef_i))
    if isempty(zef.filter_pipeline_selected) 
 zef.filter_pipeline_selected = zef.filter_pipeline_list{end};
    end
    if isstr(zef.filter_pipeline_selected)
    zef.filter_pipeline_selected = {zef.filter_pipeline_selected};
end
set(zef.h_filter_parameter_list,'data',zef.filter_pipeline{find(ismember(zef.filter_pipeline_list,zef.filter_pipeline_selected),1)}.parameters);
set(zef.h_filter_pipeline_list,'items',zef.filter_pipeline_list,'value',zef.filter_pipeline_selected,'multiselect','on');
else
    set(zef.h_filter_parameter_list,'data',cell(1,2));
end


clear zef_i;

zef.filter_tag = get(zef.h_filter_tag,'value');
zef.filter_data_segment = get(zef.h_filter_data_segment,'value');
zef.filter_sampling_rate = str2num(get(zef.h_filter_sampling_rate,'value'));
zef.filter_zoom = 100/str2num(get(zef.h_filter_zoom,'value'));
