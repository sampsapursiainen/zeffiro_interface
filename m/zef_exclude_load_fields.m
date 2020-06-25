%Copyright © 2018- Sampsa Pursiainen & ZI Development Team
%See: https://github.com/sampsapursiainen/zeffiro_interface

% These are parameters from the initialization file.

if isfield(zef_data,'font_size')
zef_data = rmfield(zef_data,'font_size');
end

if isfield(zef_data,'matlab_release')
zef_data = rmfield(zef_data,'matlab_release');
end

if isfield(zef_data,'code_path')
zef_data = rmfield(zef_data,'code_path');
end

if isfield(zef_data,'program_path')
zef_data = rmfield(zef_data,'program_path');
end

if isfield(zef_data,'save_file_path')
zef_data = rmfield(zef_data,'save_file_path');
end

if isfield(zef_data,'save_file')
zef_data = rmfield(zef_data,'save_file');
end

if isfield(zef_data,'video_codec')
zef_data = rmfield(zef_data,'video_codec');
end

if isfield(zef_data,'use_gpu')
zef_data = rmfield(zef_data,'use_gpu');
end

if isfield(zef_data,'gpu_num')
zef_data = rmfield(zef_data,'gpu_num');
end

if isfield(zef_data,'parallel_vectors')
zef_data = rmfield(zef_data,'parallel_vectors');
end

if isfield(zef_data,'snapshot_vertical_resolution')
zef_data = rmfield(zef_data,'snapshot_vertical_resolution');
end

if isfield(zef_data,'snapshot_horizontal_resolution')
zef_data = rmfield(zef_data,'snapshot_horizontal_resolution');
end

if isfield(zef_data,'movie_fps')
zef_data = rmfield(zef_data,'movie_fps');
end

if isfield(zef_data,'mlapp')
zef_data = rmfield(zef_data,'mlapp');
end

% Other version specific parameters.
if isfield(zef_data,'imaging_method_cell')
zef_data = rmfield(zef_data,'imaging_method_cell');
end
