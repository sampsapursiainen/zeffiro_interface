%Copyright © 2018- Sampsa Pursiainen & ZI Development Team
%See: https://github.com/sampsapursiainen/zeffiro_interface

zef_i = length(zef.filter_pipeline_list)+1;
zef.filter_pipeline{zef_i}.name = zef.filter_name_list{find(ismember(zef.filter_name_list,zef.filter_list_selected),1)};
zef.filter_pipeline{zef_i}.file = zef.filter_file_list{find(ismember(zef.filter_name_list,zef.filter_list_selected),1)};
zef.filter_pipeline{zef_i}.filter_tag = zef.filter_tag;

zef.aux_field = help(zef.filter_file_list{find(ismember(zef.filter_name_list,zef.filter_list_selected),1)});
zef.aux_field = zef.aux_field(strfind(zef.aux_field,'Input:')+6:strfind(zef.aux_field,'Output:')-1);
zef.aux_field = textscan(zef.aux_field,'%s','Delimiter',',');
zef.aux_field = zef.aux_field{:};
zef.filter_parameter_list = cell(size(zef.aux_field,1),2);
for zef_j = 1 : size(zef.aux_field,1)
zef.filter_parameter_list{zef_j,1} = strtrim(zef.aux_field{zef_j}(1:strfind(zef.aux_field{zef_j},'[Default:')-1));
zef.filter_parameter_list{zef_j,2} = strtrim(zef.aux_field{zef_j}(strfind(zef.aux_field{zef_j},'[Default:')+9:strfind(zef.aux_field{zef_j},']')-1));
if isfield(zef,zef.filter_parameter_list{zef_j,2})
    zef.filter_parameter_list{zef_j,2} = evalin('base',['zef.' zef.filter_parameter_list{zef_j,2}]);
 if isnumeric(zef.filter_parameter_list{zef_j,2})
     zef.filter_parameter_list{zef_j,2} = num2str(zef.filter_parameter_list{zef_j,2});
 end
end
end

zef.filter_pipeline{zef_i}.parameters = zef.filter_parameter_list;

zef.filter_pipeline_selected = cell(0);

clear zef_i zef_j;

zef_update_filter_tool;

