function zef = zef_update_fig_details(zef)
%ZEF_UPDATE_FIG_DETAILS  Refresh Figure-tool **Compartments:** / **Sensors:** / **Details:** lists.
%
%   Zeffiro Interface.
%   Copyright © 2018- Sampsa Pursiainen & ZI Development Team
%   See: https://github.com/sampsapursiainen/zeffiro_interface
%   Licensed under the GNU General Public License v3.0 (see LICENSE).
%
%   Function. Called at the end of zef_figure_tool and after Visualize
%   volume/surfaces. Does not redraw axes1.
%
%   **Sensors:** list (Tag='sensor_visible_color') — one row per sensor in
%   the current set. Visibility flags affect 3-D drawing, not this list.
%
%   **Compartments:** list (Tag='compartment_visible_color') — swatches
%   for tags with *_on and *_visible, reversed to match Segmentation-tool
%   row order. Click → zef_set_compartment_color.
%
%   **Details:** list (Tag='system_information') — node/tetra counts and
%   visualization settings as plain text.
%
%   nargout==0 → assignin('base','zef',zef).
%
%   See also zef_figure_tool, zef_colored_list, zef_sensor_list_items.
if nargin == 0
    zef = evalin('base','zef');
end

% Segmentation text such as '0.5000 0 1.0000' is 1-by-15. eval of that
% text is the 1-by-3 row the compartment list assigns below.
zef = local_eval_color_fields(zef);

[sensor_names, sensor_colors, n_sensors] = zef_sensor_list_items(zef);
if isfield(zef, 'h_sensor_visible_color') && isvalid(zef.h_sensor_visible_color)
    zef_colored_list('set', zef.h_sensor_visible_color, sensor_names, sensor_colors);
end

comp_names = {};
comp_colors = zeros(0, 3);
n_compartments = 0;
if isfield(zef, 'compartment_tags') && iscell(zef.compartment_tags)
    n_compartments = numel(zef.compartment_tags);
    tagged = {};
    tagged_rgb = zeros(0, 3);
    for i = numel(zef.compartment_tags):-1:1
        tag = zef.compartment_tags{i};
        nm = tag;
        if isfield(zef, [tag '_name'])
            nm = char(string(zef.([tag '_name'])));
        end
        rgb = [0.7 0.7 0.7];
        if isfield(zef, [tag '_color'])
            rgb = zef.([tag '_color']);
        end
        tagged{end+1} = nm; %#ok<AGROW>
        tagged_rgb(end+1, :) = rgb; %#ok<AGROW>
    end
    comp_names = tagged;
    comp_colors = tagged_rgb;
end
if isfield(zef, 'h_compartment_visible_color') && isvalid(zef.h_compartment_visible_color)
    zef_colored_list('set', zef.h_compartment_visible_color, comp_names, comp_colors);
end

zef.aux_field = {['Nodes: ' num2str(local_count_rows(zef, 'nodes'))], ...
    ['Tetrahedra: ' num2str(local_count_rows(zef, 'tetra'))], ...
    };

on_screen = local_scalar(zef, 'on_screen', 0);
if on_screen == 0
    zef.aux_field = [zef.aux_field, {'Visualization: '}];
end
if on_screen == 1
    zef.aux_field = [zef.aux_field, {'Visualization: Volume'}];
end
if on_screen == 2
    zef.aux_field = [zef.aux_field, {'Visualization: Surfaces'}];
end
inv_scale = local_scalar(zef, 'inv_scale', 2);
if inv_scale == 1
    zef.aux_field = [zef.aux_field, {'Scale: Logarithmic'}];
end
if inv_scale == 2
    zef.aux_field = [zef.aux_field, {'Scale: Linear'}];
end
if inv_scale == 3
    zef.aux_field = [zef.aux_field, {'Scale: Square root'}];
end
src_dir = local_scalar(zef, 'source_direction_mode', 1);
if src_dir == 1
    zef.aux_field = [zef.aux_field, {'Field basis: Cartesian'}];
end
if src_dir == 2
    zef.aux_field = [zef.aux_field, {'Field basis: Normal'}];
end
if src_dir == 3
    zef.aux_field = [zef.aux_field, {'Field basis: Mesh'}];
end
rec_type = local_scalar(zef, 'reconstruction_type', 1);
if rec_type == 1
    zef.aux_field = [zef.aux_field, {'Field: Amplitude'}];
end
if rec_type == 2
    zef.aux_field = [zef.aux_field, {'Field: Normal'}];
end
if rec_type == 3
    zef.aux_field = [zef.aux_field, {'Field: Tangential'}];
end
if rec_type == 4
    zef.aux_field = [zef.aux_field, {'Field: Normal (+)'}];
end
if rec_type == 5
    zef.aux_field = [zef.aux_field, {'Field: Normal (-)'}];
end
if rec_type == 6
    zef.aux_field = [zef.aux_field, {'Field: Value'}];
end
if rec_type == 7
    zef.aux_field = [zef.aux_field, {'Field: Amplitude smoothed'}];
end

if isfield(zef, 'h_system_information') && isvalid(zef.h_system_information)
    zef_colored_list('set', zef.h_system_information, zef.aux_field, []);
    try
        if local_in_figure_lists(zef.h_system_information)
            local_hide_system_information_handle(zef.h_system_information);
        end
    catch
    end
end

try
    h_fig = [];
    if isfield(zef, 'h_zeffiro') && isvalid(zef.h_zeffiro)
        h_fig = zef.h_zeffiro;
    end
    if ~isempty(h_fig)
        unified = false;
        try
            unified = zef_ui_is_unified(h_fig);
        catch
        end
        cc = findall(h_fig, 'Tag', 'status_compartments_count');
        if ~isempty(cc) && isvalid(cc(1))
            set(cc(1), 'String', num2str(n_compartments), 'Visible', 'on');
        end
        sc = findall(h_fig, 'Tag', 'status_sensors_count');
        if ~isempty(sc) && isvalid(sc(1))
            set(sc(1), 'String', num2str(n_sensors), 'Visible', 'on');
        end
        icc = findall(h_fig, 'Tag', 'status_comp_icon');
        if ~isempty(icc) && isvalid(icc(1))
            if unified && n_compartments > 0
                set(icc(1), 'Visible', 'off');
            end
        end
        ics = findall(h_fig, 'Tag', 'status_sens_icon');
        if ~isempty(ics) && isvalid(ics(1))
            if unified && n_sensors > 0
                set(ics(1), 'Visible', 'off');
            end
        end
        rd = findall(h_fig, 'Tag', 'status_ready');
        if ~isempty(rd) && isvalid(rd(1))
            set(rd(1), 'String', 'Ready', 'Visible', 'on');
        end
        dt = findall(h_fig, 'Tag', 'status_details_text');
        vis = '-';
        if isfield(zef, 'on_screen')
            if zef.on_screen == 1
                vis = 'Volume';
            elseif zef.on_screen == 2
                vis = 'Surfaces';
            end
        end
        scn = 'Linear';
        if isfield(zef, 'inv_scale')
            if zef.inv_scale == 1
                scn = 'Logarithmic';
            elseif zef.inv_scale == 3
                scn = 'Square root';
            end
        end
        detail_rows = { ...
            sprintf('Nodes: %s', local_group_int(local_count_rows(zef, 'nodes'))); ...
            sprintf('Tetrahedra: %s', local_group_int(local_count_rows(zef, 'tetra'))); ...
            sprintf('Visualization: %s', vis); ...
            sprintf('Scale: %s', scn)};
        if ~isempty(dt) && isvalid(dt(1))
            set(dt(1), 'String', detail_rows, 'Visible', 'off');
            try
                dt(1).Position = [1, 1, 1, 1];
            catch
            end
        end
        if unified || ~isempty(dt)
            local_hide_system_information(h_fig);
            local_sync_detail_rows(h_fig, detail_rows);
        end
        local_show_status_lists(h_fig, n_compartments, n_sensors);
    end
catch
end
try
    zef = rmfield(zef,'aux_field');
catch
end

if nargout == 0
    assignin('base','zef',zef);
end

end

function zef = local_eval_color_fields(zef)

if ~isstruct(zef)
    return
end
tags = {};
if isfield(zef, 'compartment_tags') && iscell(zef.compartment_tags)
    tags = [tags, zef.compartment_tags(:)'];
end
if isfield(zef, 'sensor_tags') && iscell(zef.sensor_tags)
    tags = [tags, zef.sensor_tags(:)'];
end
if isfield(zef, 'current_sensors') && ~isempty(zef.current_sensors)
    tags = [tags, {char(string(zef.current_sensors))}];
end
for i = 1:numel(tags)
    tag = tags{i};
    if isstring(tag)
        tag = char(tag);
    end
    if ~ischar(tag) || isempty(tag)
        continue
    end
    field = [strtrim(tag) '_color'];
    if ~isfield(zef, field)
        continue
    end
    rgb = zef.(field);
    if ischar(rgb) || isstring(rgb)
        try
            rgb = eval(['[' char(string(rgb)) ']']);
        catch
            rgb = [0.7 0.7 0.7];
        end
    end
    if isnumeric(rgb) && numel(rgb) >= 3
        rgb = double(rgb(:))';
        zef.(field) = rgb(1:3);
    else
        zef.(field) = [0.7 0.7 0.7];
    end
end

end

function tf = local_in_figure_lists(h)

tf = false;
p = h;
for k = 1:8
    if isempty(p) || ~isgraphics(p) || ~isvalid(p)
        return
    end
    try
        if isprop(p, 'Tag') && strcmp(char(p.Tag), 'figure_lists')
            tf = true;
            return
        end
    catch
    end
    try
        p = p.Parent;
    catch
        return
    end
end

end

function local_hide_system_information(h_fig)

lst = findall(h_fig, 'Tag', 'system_information');
if isempty(lst) || ~isvalid(lst(1))
    return
end
local_hide_system_information_handle(lst(1));

end

function local_hide_system_information_handle(lst)

if isempty(lst) || ~isvalid(lst)
    return
end
try
    lst.Visible = 'off';
catch
end
try
    p = lst.Parent;
    if isgraphics(p) && isvalid(p) && isprop(p, 'Tag')
        ptag = char(p.Tag);
        if contains(ptag, 'system_information') || strcmpi(char(p.Type), 'uipanel')
            if ~strcmp(char(p.Tag), 'figure_lists')
                p.Visible = 'off';
            end
        end
    end
catch
end

end

function local_sync_detail_rows(h_fig, rows)

if ~iscell(rows)
    rows = cellstr(string(rows));
end
for i = 1:4
    lab = findall(h_fig, 'Tag', sprintf('status_dlab_%d', i));
    val = findall(h_fig, 'Tag', sprintf('status_dval_%d', i));
    if isempty(lab) || isempty(val)
        continue
    end
    s = '';
    if i <= numel(rows)
        s = strtrim(char(string(rows{i})));
    end
    k = find(s == ':', 1, 'first');
    if isempty(k)
        lab_s = s;
        val_s = '';
    else
        lab_s = strtrim(s(1:k-1));
        val_s = strtrim(s(k+1:end));
    end
    try
        lab(1).String = lab_s;
        lab(1).Visible = 'on';
        val(1).String = val_s;
        val(1).Visible = 'on';
    catch
    end
end

end

function local_show_status_lists(h_fig, n_comp, n_sens)

if isempty(h_fig) || ~isvalid(h_fig)
    return
end
try
    unified = zef_ui_is_unified(h_fig);
catch
    unified = false;
end
if ~unified
    return
end
pairs = { ...
    'compartment_visible_color', n_comp; ...
    'sensor_visible_color', n_sens};
for i = 1:size(pairs, 1)
    lst = findall(h_fig, 'Tag', pairs{i, 1});
    if isempty(lst) || ~isvalid(lst(1))
        continue
    end
    host = lst(1);
    try
        if strcmpi(char(lst(1).Type), 'uihtml') && ~isempty(lst(1).Parent)
            host = lst(1).Parent;
        end
    catch
    end
    n = pairs{i, 2};
    try
        if n > 0
            host.Visible = 'on';
            if isprop(lst(1), 'Visible')
                lst(1).Visible = 'on';
            end
        end
    catch
    end
end

end

function s = local_group_int(n)

s = '0';
try
    n = round(double(n(1)));
catch
    return
end
if ~isfinite(n)
    return
end
sign_c = '';
if n < 0
    sign_c = '-';
    n = -n;
end
s = sprintf('%d', n);
out = '';
while numel(s) > 3
    out = [',' s(end-2:end) out]; %#ok<AGROW>
    s = s(1:end-3);
end
s = [sign_c s out];

end

function n = local_count_rows(zef, field)

n = 0;
try
    if isstruct(zef) && isfield(zef, field) && ~isempty(zef.(field))
        n = size(zef.(field), 1);
    end
catch
end

end

function v = local_scalar(zef, field, default)

v = default;
try
    if isstruct(zef) && isfield(zef, field) && ~isempty(zef.(field))
        v = zef.(field);
    end
catch
end

end
