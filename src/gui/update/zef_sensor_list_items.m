function [names, colors, n] = zef_sensor_list_items(zef)
%ZEF_SENSOR_LIST_ITEMS  Names and colours for the Figure-tool sensor list.
%
%   Zeffiro Interface.
%   Copyright © 2018- Sampsa Pursiainen & ZI Development Team
%   See: https://github.com/sampsapursiainen/zeffiro_interface
%   Licensed under the GNU General Public License v3.0 (see LICENSE).
%
%   Lists every sensor in the current set (or every sensor set when no
%   point table exists). The returned count is always numel(names), so the
%   status label and the scrollable list cannot diverge.
%
%   [names, colors, n] = zef_sensor_list_items(zef)
%
%   Electrode sets are labeled by zef_sensor_contact_presentation
%   ("Electrode N"), not by the stored set name.
%
%   See also zef_sensor_contact_presentation, zef_update_fig_details.

names = {};
colors = zeros(0, 3);
n = 0;
if nargin < 1 || ~isstruct(zef)
    return
end

if isfield(zef, 'current_sensors') && ~isempty(zef.current_sensors) ...
        && isfield(zef, [zef.current_sensors '_points'])
    points = zef.([zef.current_sensors '_points']);
    n_pts = size(points, 1);
    color_table = [];
    if isfield(zef, [zef.current_sensors '_color_table'])
        color_table = zef.([zef.current_sensors '_color_table']);
    end
    set_color = [0.7 0.7 0.7];
    if isfield(zef, [zef.current_sensors '_color'])
        try
            set_color = zef.([zef.current_sensors '_color']);
        catch
        end
    end
    names = zef_sensor_contact_presentation(zef, zef.current_sensors, n_pts);
    colors = zeros(n_pts, 3);
    for i = 1:n_pts
        rgb = set_color;
        if size(color_table, 1) >= i && size(color_table, 2) >= 3
            rgb = color_table(i, 1:3);
        end
        colors(i, :) = rgb;
    end
    n = n_pts;
    return
end

if isfield(zef, 'sensor_tags') && iscell(zef.sensor_tags)
    n = numel(zef.sensor_tags);
    names = cell(1, n);
    colors = zeros(n, 3);
    for i = 1:n
        tag = zef.sensor_tags{i};
        nm = tag;
        if isfield(zef, [tag '_name'])
            nm = char(string(zef.([tag '_name'])));
        end
        rgb = [0.7 0.7 0.7];
        if isfield(zef, [tag '_color'])
            rgb = zef.([tag '_color']);
        end
        names{i} = nm;
        colors(i, :) = rgb;
    end
end

end
