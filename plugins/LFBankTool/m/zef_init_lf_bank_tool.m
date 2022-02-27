%Copyright © 2018- Sampsa Pursiainen & ZI Development Team
%See: https://github.com/sampsapursiainen/zeffiro_interface

if not(isfield(zef,'lf_bank_scaling_factor'));
   zef.lf_bank_scaling_factor = 1;
end;

if not(isfield(zef,'lf_item_type'));
   zef.lf_item_type = '';
end;

if not(isfield(zef,'lf_tag'));
   zef.lf_tag = 'EEG';
end;

if not(isfield(zef,'lf_normalization'));
   zef.lf_normalization = 1;
end;

if not(isfield(zef,'lf_bank_storage'));
   zef.lf_bank_storage = cell(0);
end;

if not(isfield(zef,'lf_bank_storage'));
zef.lf_item_list = cell(0);
end;

if not(isfield(zef,'lf_item_selected'));
   zef.lf_item_selected = [];
end;

zef.lf_normalization_functions_dir = which('zef_init_lf_bank_tool.m');
zef.lf_normalization_functions_dir = [fileparts(zef.lf_normalization_functions_dir) '/' 'lead_field_normalization_functions/*.m'];

zef.lf_normalization_functions_name_list = cell(0);
zef.lf_normalization_functions_file_list = cell(0);

zef.aux_field = dir(zef.lf_normalization_functions_dir);
for zef_i = 1 : length(zef.aux_field)
[~, zef.lf_normalization_functions_file_list{zef_i}] = fileparts(zef.aux_field(zef_i).name);
end
for zef_i = 1 : length(zef.lf_normalization_functions_file_list)
zef.aux_field = help(zef.lf_normalization_functions_file_list{zef_i});
zef.aux_field = zef.aux_field(strfind(zef.aux_field,'Description:'):end);
zef.lf_normalization_functions_name_list{zef_i} = strtrim(zef.aux_field(13:end-1));
end
[zef.lf_normalization_functions_name_list zef.aux_field] = sort(zef.lf_normalization_functions_name_list);
zef.lf_normalization_functions_file_list = zef.lf_normalization_functions_file_list(zef.aux_field);

if not(isempty(zef.lf_normalization_functions_name_list))
set(zef.h_lf_normalization,'items',zef.lf_normalization_functions_name_list);
end

if isfield(zef,'h_lf_bank_tool')
    if isvalid(zef.h_lf_bank_tool)
set(zef.h_lf_tag,'Value',zef.lf_tag);
set(zef.h_lf_bank_scaling_factor,'Value',num2str(zef.lf_bank_scaling_factor));
zef.aux_field = get(zef.h_lf_normalization,'items');
set(zef.h_lf_normalization,'Value',zef.aux_field(zef.lf_normalization));
    end
end

zef_update_lf_bank_tool;
