%Copyright © 2018- Sampsa Pursiainen & ZI Development Team
%See: https://github.com/sampsapursiainen/zeffiro_interface

zef.filter_pipeline_selected = get(zef.h_filter_pipeline_list,'value');
zef.aux_field = cell(0);

zef_j = 0;
zef_k = 0;
for zef_i = 1 : length(zef.filter_pipeline_list)
    if not(ismember(zef.filter_pipeline_list{zef_i},zef.filter_pipeline_selected))
        zef_j = zef_j + 1;
zef.aux_field{zef_j} =  zef.filter_pipeline{zef_i};
    else
        zef_k = zef_k + 1;
        zef.aux_field{length(zef.filter_pipeline_list)-length(zef.filter_pipeline_selected)+zef_k} = zef.filter_pipeline{zef_i};
    end
end

zef.filter_pipeline = zef.aux_field;


clear zef_i zef_j zef_k;

zef_update_filter_tool;