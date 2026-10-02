function zef_layout_strip_tool(fig)
%ZEF_LAYOUT_STRIP_TOOL  Compact card layout for the Strip tool.
%
%   Zeffiro Interface.
%   Copyright © 2018- Sampsa Pursiainen & ZI Development Team
%   See: https://github.com/sampsapursiainen/zeffiro_interface
%   Licensed under the GNU General Public License v3.0 (see LICENSE).
%
%   Probe and encapsulation fields share one rounded card. The strip
%   list takes the leftover height. Action buttons stay a fixed size;
%   Plot sits at the trailing edge.
%
%   See also zef_strip_tool_window, zef_ui_ready.

if nargin < 1 || isempty(fig) || ~isgraphics(fig) || ~isvalid(fig)
    return
end

theme = zef_ui_theme();
try
    fig.Color = theme.color.bg;
    fig.Resize = 'on';
    fig.AutoResizeChildren = 'off';
    fig.Units = 'pixels';
catch
end

if isappdata(fig, 'ZefStripLayout')
    local_place(fig, theme);
    return
end

zef_ui_apply_size(fig, 680, 404, 640, 388);
fig.SizeChangedFcn = @(src, ~) local_place(src, theme);
setappdata(fig, 'ZefPixelResize', @(src) local_place(src, theme));
local_place(fig, theme);
zef_ui_bind_min_size(fig, 640, 388);
setappdata(fig, 'ZefStripLayout', true);

end

function local_place(fig, theme)

if ~isgraphics(fig) || ~isvalid(fig)
    return
end
st = local_strip();
try
    fig.Units = 'pixels';
    fig.Color = theme.color.bg;
catch
end
p = fig.Position;
W = p(3);
H = p(4);

pad = 12;
gap = 10;
row_h = 24;
row_gap = 6;
btn_h = 28;
inset = 14;
card_w = max(360, W - 2 * pad);
card_h = local_card_height(row_h, row_gap, inset);
card_x = pad;
card_y = H - pad - card_h;

panel = local_card_panel(fig, theme);
panel.Position = [card_x, card_y, card_w, card_h];

cols = local_columns(card_w, inset);
fs = theme.font.size;
y = card_h - inset - 16;
local_title(fig, panel, 'section_strip_probe', 'Probe', inset, y, card_w - 2 * inset, 16, theme);

y = y - 8 - row_h;
local_vector_row(fig, panel, st, cols, y, row_h, theme, fs, ...
    'Strip tip point (mm):', 'zef_strip_lab_tip', 'Tip point (mm)', 'h_tip_point', ...
    'Length (mm):', 'zef_strip_lab_len', 'Length (mm)', 'h_strip_length', ...
    'Roll (rad):', '', 'Roll (rad)', 'h_strip_angle');
y = y - row_gap - row_h;
local_vector_row(fig, panel, st, cols, y, row_h, theme, fs, ...
    'Strip orientation:', 'zef_strip_lab_ori', 'Orientation', 'h_orientation_axis', ...
    'Number of sectors:', 'zef_strip_lab_sec', 'Sectors', 'h_strip_n_sectors', ...
    'Tag:', '', 'Tag', 'h_strip_tag');
y = y - row_gap - row_h;
local_label(fig, panel, 'Model:', '', 'Model', cols.x1, y, cols.lab1, row_h, theme, fs);
local_field(fig, panel, st, 'h_strip_model', cols.x1f, y, cols.xyz_w, row_h, theme, fs, '');
local_label(fig, panel, 'Impedance (Ohm):', '', 'Impedance', cols.x2, y, cols.lab2, row_h, theme, fs);
local_field(fig, panel, st, 'h_strip_impedance', cols.x2f, y, cols.fld, row_h, theme, fs, 'center');
local_label(fig, panel, 'Conductivity (S/m):', 'zef_strip_lab_cond', 'Conductivity', cols.x3, y, cols.lab3, row_h, theme, fs);
local_field(fig, panel, st, 'h_strip_conductivity', cols.x3f, y, cols.fld3, row_h, theme, fs, 'center');

rule = local_rule(fig, panel);
rule.Position = [inset, y - 11, max(20, card_w - 2 * inset), 1];
y = y - 10 - 1 - 8 - 16;
local_title(fig, panel, 'section_strip_encap', 'Encapsulation', inset, y, card_w - 2 * inset, 16, theme);

y = y - 8 - row_h;
local_vector_row(fig, panel, st, cols, y, row_h, theme, fs, ...
    'Encapsulation shift (mm):', 'zef_strip_lab_esh', 'Shift (mm)', 'h_encapsulation_shift', ...
    'Thickness (mm):', '', 'Thickness', 'h_encapsulation_thickness', ...
    'Encapsulation length (mm):', 'zef_strip_lab_el', 'Length (mm)', 'h_encapsulation_length');
y = y - row_gap - row_h;
local_label(fig, panel, 'Encapsulation orientation:', 'zef_strip_lab_eo', 'Orientation', cols.x1, y, cols.lab1, row_h, theme, fs);
local_xyz(fig, panel, st, 'h_encapsulation_orientation_axis', cols.x1f, y, cols.box, cols.box_gap, row_h, theme, fs);
local_label(fig, panel, 'Encapsulation conductivity (S/m):', 'zef_strip_lab_ec', 'Conductivity', cols.x2, y, cols.lab2, row_h, theme, fs);
local_field(fig, panel, st, 'h_encapsulation_conductivity', cols.x2f, y, cols.fld, row_h, theme, fs, 'center');
local_include(fig, panel, st, cols.x3, y, cols.lab3 + cols.gap + cols.fld3, row_h, theme, fs);
local_hide_stray_labels(fig);

list_top = card_y - gap;
lab_h = 18;
lab_y = list_top - lab_h;
local_title(fig, fig, 'section_strip_list', 'Strips', pad, lab_y, 120, lab_h, theme);
btn_y = pad;
list_y = btn_y + btn_h + gap;
list_h = max(72, lab_y - 6 - list_y);
local_list(fig, st, pad, list_y, card_w, list_h);

local_actions(fig, theme, pad, btn_y, card_w, btn_h);

if isappdata(fig, 'ZefStripLayout')
    try
        zef_ui_card(panel, theme);
    catch
    end
    local_paint_card_text(panel, theme);
end

end

function h = local_card_height(row_h, row_gap, inset)

title_h = 16;
title_gap = 8;
h = inset + title_h + title_gap ...
    + 3 * row_h + 2 * row_gap ...
    + 10 + 1 + 8 + title_h + title_gap ...
    + 2 * row_h + row_gap ...
    + inset;

end

function cols = local_columns(card_w, inset)

cols.lab1 = 100;
cols.lab2 = 96;
cols.lab3 = 84;
cols.gap = 6;
cols.box = 44;
cols.box_gap = 4;
cols.xyz_w = 3 * cols.box + 2 * cols.box_gap;
cols.fld = 60;
cols.col_gap = 12;
inner = card_w - 2 * inset;
used = cols.lab1 + cols.gap + cols.xyz_w + cols.col_gap ...
    + cols.lab2 + cols.gap + cols.fld + cols.col_gap ...
    + cols.lab3 + cols.gap + 64;
extra = max(0, inner - used);
cols.fld3 = cols.fld;
cols.col_gap = cols.col_gap + floor(extra / 2);
cols.x1 = inset;
cols.x1f = cols.x1 + cols.lab1 + cols.gap;
cols.x2 = cols.x1f + cols.xyz_w + cols.col_gap;
cols.x2f = cols.x2 + cols.lab2 + cols.gap;
cols.x3 = cols.x2f + cols.fld + cols.col_gap;
cols.x3f = cols.x3 + cols.lab3 + cols.gap;

end

function y = local_vector_row(fig, panel, st, cols, y, row_h, theme, fs, ...
    s1, tag1, short1, xyz_prefix, s2, tag2, short2, field2, s3, tag3, short3, field3)

local_label(fig, panel, s1, tag1, short1, cols.x1, y, cols.lab1, row_h, theme, fs);
if contains(xyz_prefix, 'axis') || contains(xyz_prefix, 'point') || contains(xyz_prefix, 'shift')
    local_xyz(fig, panel, st, xyz_prefix, cols.x1f, y, cols.box, cols.box_gap, row_h, theme, fs);
else
    local_field(fig, panel, st, xyz_prefix, cols.x1f, y, cols.xyz_w, row_h, theme, fs, 'center');
end
local_label(fig, panel, s2, tag2, short2, cols.x2, y, cols.lab2, row_h, theme, fs);
local_field(fig, panel, st, field2, cols.x2f, y, cols.fld, row_h, theme, fs, 'center');
local_label(fig, panel, s3, tag3, short3, cols.x3, y, cols.lab3, row_h, theme, fs);
align3 = 'center';
if strcmp(field3, 'h_strip_tag')
    align3 = 'left';
end
local_field(fig, panel, st, field3, cols.x3f, y, cols.fld3, row_h, theme, fs, align3);

end

function local_include(fig, panel, st, x, y, w, h, theme, fs)

lab = local_label(fig, panel, 'Include encapsulation:', 'zef_strip_lab_inc', 'Include:', 0, 0, 1, 1, theme, fs);
if ~isempty(lab) && isgraphics(lab)
    lab.Visible = 'off';
end
hnd = local_handle(fig, st, 'h_encapsulation_on');
if isempty(hnd)
    return
end
local_into(panel, hnd);
hnd.Style = 'checkbox';
hnd.String = 'Include';
hnd.Units = 'pixels';
hnd.Position = [x, y, max(88, w), h];
hnd.FontUnits = 'pixels';
hnd.FontName = theme.font.name;
hnd.FontSize = fs;
hnd.BackgroundColor = theme.color.panel;
hnd.ForegroundColor = theme.color.text;
hnd.HorizontalAlignment = 'left';
hnd.Visible = 'on';

end

function local_actions(fig, theme, x, y, w, h)

gap = 8;
specs = { ...
    'Add', 68, false; ...
    'Embed', 76, false; ...
    'Add contacts', 118, false; ...
    'Delete', 76, false};
bx = x;
for i = 1:size(specs, 1)
    local_button(fig, specs{i, 1}, bx, y, specs{i, 2}, h, theme, specs{i, 3});
    bx = bx + specs{i, 2} + gap;
end
plot_w = 76;
local_button(fig, 'Plot', x + w - plot_w, y, plot_w, h, theme, true);

end

function panel = local_card_panel(fig, theme)

panel = findall(fig, 'Type', 'uipanel', 'Tag', 'zef_strip_card');
if isempty(panel)
    panel = uipanel(fig, 'Units', 'pixels', 'Tag', 'zef_strip_card', ...
        'BorderType', 'none', 'Title', '', 'BackgroundColor', theme.color.panel);
else
    panel = panel(1);
end
try
    panel.BorderType = 'none';
    panel.Title = '';
    panel.BackgroundColor = theme.color.panel;
    panel.Units = 'pixels';
    panel.Visible = 'on';
catch
end
try
    uistack(panel, 'bottom');
catch
end

end

function rule = local_rule(fig, panel)

rule = findall(fig, 'Tag', 'zef_card_e_strip');
if isempty(rule)
    rule = uicontrol(panel, 'Style', 'text', 'Tag', 'zef_card_e_strip', ...
        'String', '', 'Enable', 'inactive', 'Units', 'pixels');
else
    rule = rule(1);
    local_into(panel, rule);
end
try
    rule.BackgroundColor = theme_edge();
catch
end

end

function c = theme_edge()

c = [0.860 0.918 0.922];
try
    th = zef_ui_theme();
    c = th.color.cardEdge;
catch
end

end

function local_title(fig, parent, tag, str, x, y, w, h, theme)

lab = findall(fig, 'Tag', tag);
if isempty(lab)
    lab = uicontrol(parent, 'Style', 'text', 'Tag', tag, 'Units', 'pixels', ...
        'HorizontalAlignment', 'left', 'HitTest', 'off', 'String', str);
else
    lab = lab(1);
    local_into(parent, lab);
end
lab.String = str;
lab.Units = 'pixels';
lab.Position = [x, y, max(40, w), h];
lab.HorizontalAlignment = 'left';
lab.Visible = 'on';
try
    lab.FontUnits = 'pixels';
    lab.FontName = theme.font.name;
    lab.FontSize = theme.font.size;
    lab.FontWeight = 'bold';
    lab.ForegroundColor = theme.color.header;
    if isprop(parent, 'BackgroundColor')
        lab.BackgroundColor = parent.BackgroundColor;
    else
        lab.BackgroundColor = theme.color.bg;
    end
catch
end

end

function lab = local_label(fig, parent, str, tag, short, x, y, w, h, theme, fs)

if nargin < 4 || isempty(tag)
    tag = '';
end
if nargin < 5
    short = '';
end
lab = gobjects(0);
if ~isempty(tag)
    lab = findall(fig, 'Tag', tag);
end
if isempty(lab)
    lab = findall(fig, 'Style', 'text', 'String', str);
end
if isempty(lab) && ~isempty(short)
    lab = findall(fig, 'Style', 'text', 'String', short);
end
if isempty(lab)
    lab = gobjects(0);
    return
end
lab = lab(1);
try
    tg = char(lab.Tag);
    if strncmp(tg, 'section_', 8) || strcmp(tg, 'zef_card_e_strip')
        lab = gobjects(0);
        return
    end
catch
end
if ~isempty(tag)
    try
        lab.Tag = tag;
    catch
    end
end
if ~isempty(short)
    try
        lab.String = short;
    catch
    end
end
local_into(parent, lab);
lab.Units = 'pixels';
lab.Position = [x, y, max(18, w), h];
lab.HorizontalAlignment = 'right';
lab.Visible = 'on';
try
    lab.FontUnits = 'pixels';
    lab.FontName = theme.font.name;
    lab.FontSize = fs;
    lab.FontWeight = 'normal';
    lab.ForegroundColor = theme.color.text;
    lab.BackgroundColor = theme.color.panel;
catch
end

end

function local_xyz(fig, parent, st, prefix, x, y, xyz, gap, h, theme, fs)

for i = 1:3
    name = sprintf('%s_%d', prefix, i);
    local_field(fig, parent, st, name, x + (i - 1) * (xyz + gap), y, xyz, h, theme, fs, 'center');
end

end

function local_field(fig, parent, st, name, x, y, w, h, theme, fs, align)

hnd = local_handle(fig, st, name);
if isempty(hnd)
    return
end
local_into(parent, hnd);
try
    hnd.Units = 'pixels';
    hnd.Position = [x, y, max(18, w), h];
    hnd.Visible = 'on';
    if isprop(hnd, 'FontUnits')
        hnd.FontUnits = 'pixels';
        hnd.FontName = theme.font.name;
        hnd.FontSize = fs;
    end
    if isprop(hnd, 'BackgroundColor') && ~strcmpi(char(hnd.Style), 'checkbox')
        hnd.BackgroundColor = theme.color.inputBg;
    end
    if isprop(hnd, 'ForegroundColor')
        hnd.ForegroundColor = theme.color.text;
    end
    if ~isempty(align) && isprop(hnd, 'HorizontalAlignment') ...
            && ~strcmpi(char(hnd.Style), 'popupmenu')
        hnd.HorizontalAlignment = align;
    end
catch
end

end

function hnd = local_handle(fig, st, name)

hnd = gobjects(0);
if isstruct(st) && isfield(st, name)
    hnd = st.(name);
end
if isempty(hnd) || ~(isgraphics(hnd(1)) && isvalid(hnd(1)))
    hnd = findall(fig, 'Tag', name);
end
if isempty(hnd) || ~(isgraphics(hnd(1)) && isvalid(hnd(1)))
    hnd = gobjects(0);
    return
end
hnd = hnd(1);

end

function local_into(parent, h)

if isempty(h) || ~isgraphics(h) || ~isvalid(h)
    return
end
try
    if h.Parent ~= parent
        h.Parent = parent;
    end
    h.Units = 'pixels';
catch
end

end

function local_list(fig, st, x, y, w, h)

hnd = gobjects(0);
if isstruct(st) && isfield(st, 'h_strip_list')
    hnd = st.h_strip_list;
end
if isempty(hnd) || ~(isgraphics(hnd(1)) && isvalid(hnd(1)))
    hnd = findall(fig, 'Tag', 'h_strip_list');
end
if isempty(hnd)
    hnd = findall(fig, 'Tag', 'strip_list');
end
if isempty(hnd) || ~(isgraphics(hnd(1)) && isvalid(hnd(1)))
    return
end
host = hnd(1);
try
    if strcmpi(char(host.Type), 'uihtml') && ~isempty(host.Parent) ...
            && host.Parent ~= fig
        host = host.Parent;
    end
catch
end
try
    if host.Parent ~= fig
        host.Parent = fig;
    end
catch
end
try
    if isprop(host, 'Units')
        host.Units = 'pixels';
    end
    host.Position = [x, y, max(80, w), max(64, h)];
    host.Visible = 'on';
catch
end
try
    uistack(host, 'top');
catch
end

end

function local_button(fig, label, x, y, w, h, theme, is_primary)

btn = local_find_button(fig, label);
if isempty(btn)
    return
end
try
    if btn.Parent ~= fig
        btn.Parent = fig;
    end
    btn.Units = 'pixels';
    btn.Position = [x, y, w, h];
    btn.FontUnits = 'pixels';
    btn.FontName = theme.font.name;
    btn.FontSize = theme.font.size;
    btn.Visible = 'on';
catch
end
try
    zef_ui_round_button(btn, theme, is_primary);
catch
end

end

function btn = local_find_button(fig, label)

btn = gobjects(0);
found = findall(fig, 'Type', 'uicontrol', 'Style', 'pushbutton');
for i = 1:numel(found)
    lab = '';
    try
        lab = strtrim(char(string(found(i).String)));
    catch
    end
    if isempty(lab)
        try
            lab = strtrim(char(string(getappdata(found(i), 'ZefButtonLabel'))));
        catch
        end
    end
    if strcmp(lab, label)
        btn = found(i);
        return
    end
end

end

function local_hide_stray_labels(fig)

kids = findall(fig, 'Type', 'uicontrol', 'Style', 'text');
for i = 1:numel(kids)
    h = kids(i);
    try
        if h.Parent ~= fig
            continue
        end
    catch
        continue
    end
    tag = '';
    try
        tag = char(h.Tag);
    catch
    end
    if strncmp(tag, 'section_', 8) || endsWith(tag, '_cap')
        continue
    end
    h.Visible = 'off';
end

end

function local_paint_card_text(panel, theme)

kids = findall(panel, 'Type', 'uicontrol', 'Style', 'text');
for i = 1:numel(kids)
    tag = '';
    try
        tag = char(kids(i).Tag);
    catch
    end
    if strcmp(tag, 'zef_card_e_strip')
        kids(i).BackgroundColor = theme.color.cardEdge;
        continue
    end
    kids(i).BackgroundColor = theme.color.panel;
    if strncmp(tag, 'section_', 8)
        kids(i).ForegroundColor = theme.color.header;
        kids(i).FontWeight = 'bold';
    end
end
boxes = findall(panel, 'Type', 'uicontrol', 'Style', 'checkbox');
for i = 1:numel(boxes)
    try
        boxes(i).BackgroundColor = theme.color.panel;
    catch
    end
end

end

function st = local_strip()

st = struct();
try
    zef = evalin('base', 'zef');
    if isstruct(zef) && isfield(zef, 'strip_tool')
        st = zef.strip_tool;
    end
catch
end

end
