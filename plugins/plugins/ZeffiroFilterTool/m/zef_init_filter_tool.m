%Copyright © 2018- Sampsa Pursiainen & ZI Development Team
%See: https://github.com/sampsapursiainen/zeffiro_interface

zef.filter_name_list = cell(0);
zef.filter_file_list = cell(0);
zef.filter_parameter_list = cell(0);

if not(isfield(zef,'filter_zoom'));
    zef.filter_zoom = 1;
end

if not(isfield(zef,'filter_epoch_points'));
    zef.filter_epoch_points = [];
end

if not(isfield(zef,'filter_save_file_path'));
    zef.filter_save_file_path = './data';
end

if not(isfield(zef,'filter_save_file'));
    zef.filter_save_file = '';
end

if not(isfield(zef,'filter_list_selected'));
    zef.filter_list_selected = cell(0);
end

if not(isfield(zef,'filter_sampling_rate'));
    zef.filter_sampling_rate = zef.inv_sampling_frequency;
end

if not(isfield(zef,'filter_tag'));
   zef.filter_tag = 'Default tag';
end;

if not(isfield(zef,'filter_data_segment'));
   zef.filter_data_segment = '0';
end;

if not(isfield(zef,'filter_pipeline'));
   zef.filter_pipeline = cell(0);
end;

if not(isfield(zef,'filter_pipeline_list'));
zef.filter_pipeline_list = cell(0);
end;

if not(isfield(zef,'filter_pipeline_selected'));
   zef.filter_pipeline_selected = cell(0);
end;

set(zef.h_filter_tag,'Value',zef.filter_tag);
set(zef.h_filter_data_segment,'Value',num2str(zef.filter_data_segment));
set(zef.h_filter_sampling_rate,'Value',num2str(zef.filter_sampling_rate));
set(zef.h_filter_zoom,'Value',num2str(round(100/zef.filter_zoom)));

zef.filter_dir = which('zef_init_filter_tool.m');
zef.filter_dir = [fileparts(zef.filter_dir) '/' 'filter_bank/*.m'];

zef.aux_field = dir(zef.filter_dir);
for zef_i = 1 : length(zef.aux_field)
[~, zef.filter_file_list{zef_i}] = fileparts(zef.aux_field(zef_i).name);
end
for zef_i = 1 : length(zef.filter_file_list)
zef.aux_field = help(zef.filter_file_list{zef_i});
zef.aux_field = zef.aux_field(strfind(zef.aux_field,'Description:'):strfind(zef.aux_field,'Input:'));
zef.filter_name_list{zef_i} = strtrim(zef.aux_field(13:end-1));
end
[zef.filter_name_list zef.aux_field] = sort(zef.filter_name_list);
zef.filter_file_list = zef.filter_file_list(zef.aux_field);

if isempty(zef.filter_list_selected)
zef.filter_list_selected = length(zef.filter_name_list);
end
set(zef.h_filter_list,'Items',zef.filter_name_list,'ItemsData',[1:length(zef.filter_name_list)],'Value',zef.filter_list_selected,'Multiselect','off');
set(zef.h_filter_pipeline_list,'Multiselect','on');

if not(isempty(zef.filter_pipeline_selected))
zef.aux_field = help(zef.filter_pipeline{zef.filter_pipeline_selected(1)}.file);
zef.aux_field = zef.aux_field(strfind(zef.aux_field,'Input:'):strfind(zef.aux_field,'Output:'));
zef.filter_parameter_list(:,1) = textscan(zef.aux_field,'%s','Delimiter',',');
zef.aux_field = zef.filter_pipeline{zef.filter_pipeline_selected(1)}.parameters;
end

set(zef.h_filter_parameter_list,'columneditable',[false true]);

clear zef_i
zef_update_filter_tool;
