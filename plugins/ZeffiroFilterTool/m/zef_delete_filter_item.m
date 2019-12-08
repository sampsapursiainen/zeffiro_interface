%Copyright © 2018- Sampsa Pursiainen & ZI Development Team
%See: https://github.com/sampsapursiainen/zeffiro_interface

zef.filter_pipeline_selected = get(zef.h_filter_pipeline_list,'value');

zef_j = 0;
for zef_i = 1 : length(zef.filter_pipeline_list)
    if not(ismember(zef.filter_pipeline_list{zef_i},zef.filter_pipeline_selected))
zef_j = zef_j + 1;
zef.filter_pipeline{zef_j} =  zef.filter_pipeline{zef_i};
zef.filter_pipeline_list{zef_j} = zef.filter_pipeline_list{zef_i};
    end
end

zef.filter_pipeline(zef_j+1:zef_i) = [];
zef.filter_pipeline_list(zef_j+1:zef_i) = [];

zef.filter_pipeline_selected = cell(0);

clear zef_i zef_j;

zef_update_filter_tool;