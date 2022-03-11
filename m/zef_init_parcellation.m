%Copyright © 2018- Sampsa Pursiainen & ZI Development Team
%See: https://github.com/sampsapursiainen/zeffiro_interface
if not(isfield(zef,'parcellation_name'));
    zef.parcellation_name = '';
end;

if not(isfield(zef,'parcellation_plot_type'));
    zef.parcellation_plot_type = 1;
end;

if not(isfield(zef,'parcellation_colortable'));
    zef.parcellation_colortable = cell(0);
end;

if not(isfield(zef,'parcellation_segment'));
    zef.parcellation_segment = 'LH';
end;

if not(isfield(zef,'parcellation_plot_type'));
    zef.parcellation_plot_type = 1;
end;

if not(isfield(zef,'parcellation_points'));
    zef.parcellation_points = cell(0);
end;

if not(isfield(zef,'parcellation_merge'));
    zef.parcellation_merge = 1;
end;

if not(isfield(zef,'use_parcellation'));
    zef.use_parcellation = 0;
end;

zef.time_series_tools_dir = which('zef_init_parcellation.m');
zef.time_series_tools_dir = [fileparts(zef.time_series_tools_dir) '/' 'time_series_tools/*.m'];

zef.time_series_tools_name_list = cell(0);
zef.time_series_tools_file_list = cell(0);

zef.aux_field = dir(zef.time_series_tools_dir);
for zef_i = 1 : length(zef.aux_field)
[~, zef.time_series_tools_file_list{zef_i}] = fileparts(zef.aux_field(zef_i).name);
end
for zef_i = 1 : length(zef.time_series_tools_file_list)
zef.aux_field = help(zef.time_series_tools_file_list{zef_i});
zef.aux_field = zef.aux_field(strfind(zef.aux_field,'Description:'):end);
zef.time_series_tools_name_list{zef_i} = strtrim(zef.aux_field(13:end-1));
end
[zef.time_series_tools_name_list zef.aux_field] = sort(zef.time_series_tools_name_list);
zef.time_series_tools_file_list = zef.time_series_tools_file_list(zef.aux_field);

if not(isempty(zef.time_series_tools_name_list))
set(zef.h_time_series_tools_list,'string',zef.time_series_tools_name_list,'Value',1);
end

zef_update_parcellation;
