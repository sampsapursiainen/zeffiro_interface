function zef = zef_normalize_colors(zef)
%ZEF_NORMALIZE_COLORS  Store compartment and sensor colors as 1-by-3 RGB.
%
%   Zeffiro Interface.
%   Copyright © 2018- Sampsa Pursiainen & ZI Development Team
%   See: https://github.com/sampsapursiainen/zeffiro_interface
%   Licensed under the GNU General Public License v3.0 (see LICENSE).
%
%   Rewrites zef.<tag>_color for every compartment and sensor tag, and
%   zef.<tag>_color_table for sensor tags, through zef_rgb_row. A value
%   that is already a finite 1-by-3 (or N-by-3 table) in [0,1] is left
%   in place. Text such as '0.5000 0 1.0000' becomes [0.5 0 1].
%
%   zef = zef_normalize_colors(zef)
%   zef_normalize_colors          % reads and writes zef in the base workspace
%
%   See also zef_rgb_row, zef_load, zef_update, zef_update_fig_details.

if nargin == 0
    zef = evalin('base', 'zef');
end

if ~isstruct(zef)
    if nargout == 0
        assignin('base', 'zef', zef);
    end
    return
end

zef = local_tags(zef, 'compartment_tags', false);
zef = local_tags(zef, 'sensor_tags', true);
if isfield(zef, 'current_sensors') && ~isempty(zef.current_sensors)
    zef = local_one(zef, zef.current_sensors, true);
end

if nargout == 0
    assignin('base', 'zef', zef);
end

end

function zef = local_tags(zef, list_field, is_sensor)

if ~isfield(zef, list_field) || ~iscell(zef.(list_field))
    return
end
tags = zef.(list_field);
for i = 1:numel(tags)
    zef = local_one(zef, tags{i}, is_sensor);
end

end

function zef = local_one(zef, tag, is_sensor)

tag = local_tag(tag);
if isempty(tag)
    return
end
zef = local_fix_color(zef, tag);
if is_sensor
    zef = local_fix_table(zef, tag);
end

end

function tag = local_tag(tag)

if isstring(tag)
    if numel(tag) ~= 1
        tag = '';
        return
    end
    tag = char(tag);
end
if ~ischar(tag)
    tag = '';
    return
end
tag = strtrim(reshape(tag, 1, []));

end

function zef = local_fix_color(zef, tag)

field = [tag '_color'];
if ~isfield(zef, field)
    return
end
raw = zef.(field);
rgb = zef_rgb_row(raw);
if local_same_row(raw, rgb)
    return
end
zef.(field) = rgb;

end

function zef = local_fix_table(zef, tag)

field = [tag '_color_table'];
if ~isfield(zef, field)
    return
end
raw = zef.(field);
if isempty(raw)
    return
end
rgb = local_table(raw);
if isempty(rgb)
    return
end
if local_same_table(raw, rgb)
    return
end
zef.(field) = rgb;

end

function rgb = local_table(raw)

rgb = [];
if isstring(raw)
    raw = char(raw);
end
if ischar(raw)
    rgb = zeros(size(raw, 1), 3);
    for i = 1:size(raw, 1)
        rgb(i, :) = zef_rgb_row(raw(i, :));
    end
    return
end
if iscell(raw)
    rgb = zeros(numel(raw), 3);
    for i = 1:numel(raw)
        rgb(i, :) = zef_rgb_row(raw{i});
    end
    return
end
if ~isnumeric(raw)
    return
end
raw = local_gather(raw);
if ndims(raw) > 2 || size(raw, 1) < 1 || size(raw, 2) < 1
    return
end
rgb = zeros(size(raw, 1), 3);
for i = 1:size(raw, 1)
    rgb(i, :) = zef_rgb_row(raw(i, :));
end

end

function tf = local_same_row(raw, rgb)

tf = false;
raw = local_gather(raw);
if ~isnumeric(raw) || ~isequal(size(raw), [1 3])
    return
end
tf = isequaln(double(raw), rgb);

end

function tf = local_same_table(raw, rgb)

tf = false;
raw = local_gather(raw);
if ~isnumeric(raw) || ndims(raw) > 2 || ~isequal(size(raw), size(rgb))
    return
end
tf = isequaln(double(raw), rgb);

end

function value = local_gather(value)

if isa(value, 'gpuArray')
    try
        value = gather(value);
    catch
    end
end

end
