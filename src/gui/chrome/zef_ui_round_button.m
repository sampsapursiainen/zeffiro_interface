function zef_ui_round_button(h, theme, is_primary)
%ZEF_UI_ROUND_BUTTON  Sample-style rounded CData on a traditional button.
%
%   Zeffiro Interface.
%   Copyright © 2018- Sampsa Pursiainen & ZI Development Team
%   See: https://github.com/sampsapursiainen/zeffiro_interface
%   Licensed under the GNU General Public License v3.0 (see LICENSE).
%
%   MATLAB cannot show CData and String together, so a sibling caption
%   (Tag <buttonTag>_cap) is the visible label. The wording is stored in
%   appdata ZefButtonLabel; h.String is cleared so CData can paint. Call
%   after Position is set.
%
%   zef_ui_round_button(h)
%   zef_ui_round_button(h, theme)
%   zef_ui_round_button(h, theme, is_primary)
%
%   See also zef_ui_roundrect, zef_ui_theme.

if nargin < 1 || isempty(h) || ~isgraphics(h) || ~isvalid(h)
    return
end
if nargin < 2 || isempty(theme)
    theme = zef_ui_theme();
end
if nargin < 3 || isempty(is_primary)
    is_primary = false;
    try
        is_primary = strcmpi(strtrim(char(h.String)), 'Play') ...
            || strcmp(char(h.Tag), 'playbutton');
    catch
    end
end

try
    h.Units = 'pixels';
catch
end
p = h.Position;
w = max(8, round(p(3)));
ht = max(8, round(p(4)));
r = 6;
try
    r = theme.space.btnRadius;
catch
end
fillc = theme.color.button;
fg = theme.color.buttonText;
if is_primary
    fillc = theme.color.primary;
    fg = theme.color.primaryText;
end
outer = theme.color.panel;
try
    ptag = '';
    if isprop(h.Parent, 'Tag')
        ptag = char(h.Parent.Tag);
    end
    if any(strcmp(ptag, {'figure_sidebar', 'figure_toggle_host', 'figure_lists'}))
        outer = theme.color.panel;
    end
catch
end
try
    h.BusyAction = 'cancel';
catch
end
try
    [borderc, stroke] = local_edge(theme, is_primary);
    bkey = [w, ht, double(is_primary), round(fillc * 1000), ...
        round(borderc * 1000), round(stroke * 100)];
    prev = getappdata(h, 'ZefRoundKey');
    if ~isequal(prev, bkey)
        h.CData = zef_ui_roundrect(w, ht, min(r, floor(min(w, ht) / 2) - 1), ...
            fillc, borderc, outer, stroke);
        h.BackgroundColor = outer;
        h.ForegroundColor = fg;
        setappdata(h, 'ZefRoundKey', bkey);
        setappdata(h, 'ZefRoundIdle', h.CData);
        setappdata(h, 'ZefRoundFill', fillc);
        setappdata(h, 'ZefRoundOuter', outer);
        setappdata(h, 'ZefRoundBorder', borderc);
        setappdata(h, 'ZefRoundStroke', stroke);
        setappdata(h, 'ZefRoundPrimary', is_primary);
        setappdata(h, 'ZefRoundRadius', r);
        try
            rmappdata(h, 'ZefRoundHover');
            rmappdata(h, 'ZefRoundHoverFill');
            rmappdata(h, 'ZefRoundPress');
            rmappdata(h, 'ZefRoundPressFill');
        catch
        end
    end
catch
end

lab = '';
try
    lab = char(h.String);
catch
end
if isempty(strtrim(lab))
    try
        lab = char(getappdata(h, 'ZefButtonLabel'));
    catch
    end
end
if isempty(strtrim(lab))
    return
end
try
    setappdata(h, 'ZefButtonLabel', lab);
    h.String = '';
catch
end
tag = 'zef_btn_cap';
try
    tag = [char(h.Tag) '_cap'];
catch
end
cap = [];
try
    cap = findall(h.Parent, 'Tag', tag, 'Type', 'uicontrol');
    if ~isempty(cap)
        cap = cap(1);
    end
catch
end
% The caption is an opaque rectangle. Keep it inside the stroke so it
% does not cover the border or square off the rounded corners.
inset = max(3, min(5, r - 1));
cap_pos = [p(1) + inset, p(2) + inset, ...
    max(8, w - 2 * inset), max(10, ht - 2 * inset)];
if ~isempty(cap) && isvalid(cap)
    cap.String = lab;
    cap.ForegroundColor = fg;
    cap.BackgroundColor = fillc;
    cap.Enable = 'inactive';
    cap.Visible = 'on';
    cap.UserData = h;
    cap.ButtonDownFcn = @local_fire;
    cap.Callback = [];
    if isequal(round(cap.Position), round(cap_pos))
        return
    end
end
if isempty(cap) || ~isvalid(cap)
    cap = uicontrol('Style', 'text', 'Parent', h.Parent, 'Units', 'pixels', ...
        'Tag', tag, 'Enable', 'inactive', 'HorizontalAlignment', 'center', ...
        'FontName', theme.font.name);
end
cap.String = lab;
cap.Position = cap_pos;
cap.ForegroundColor = fg;
cap.BackgroundColor = fillc;
cap.Visible = 'on';
cap.FontWeight = 'normal';
if is_primary
    cap.FontWeight = 'bold';
end
cap.Enable = 'inactive';
cap.UserData = h;
cap.ButtonDownFcn = @local_fire;
cap.Callback = [];
try
    cap.FontUnits = 'pixels';
    cap.FontSize = min(theme.font.size, max(9, ht - 10));
catch
end
try
    uistack(cap, 'top');
catch
end

end

function [borderc, stroke] = local_edge(theme, is_primary)

borderc = [0.680 0.720 0.750];
stroke = 1;
try
    borderc = theme.color.buttonBorder;
catch
end
if is_primary
    try
        borderc = theme.color.buttonBorderPrimary;
    catch
    end
end
try
    stroke = theme.space.btnStroke;
catch
end
borderc = double(borderc(1:3));
stroke = max(0.5, double(stroke(1)));

end

function local_fire(src, ~)

btn = [];
try
    btn = src.UserData;
catch
end
if isempty(btn) || ~isvalid(btn)
    return
end
try
    if strcmpi(char(btn.Enable), 'off')
        return
    end
catch
end
try
    zef_ui_interact(btn, 'paint', 'press');
catch
end
cb = [];
try
    cb = btn.Callback;
catch
end
try
    if ischar(cb) || isstring(cb)
        evalin('base', char(cb));
    elseif isa(cb, 'function_handle')
        cb(btn, []);
    elseif iscell(cb) && ~isempty(cb)
        feval(cb{:});
    end
catch
end
try
    zef_ui_interact(btn, 'paint', 'hover');
catch
end

end
