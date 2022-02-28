%Copyright © 2018- Sampsa Pursiainen & ZI Development Team
%See: https://github.com/sampsapursiainen/zeffiro_interface

zef.filter_pipeline =  zef.filter_pipeline([zef.filter_pipeline_selected setdiff([1:length(zef.filter_pipeline)],zef.filter_pipeline_selected)]);
zef_update_filter_tool;