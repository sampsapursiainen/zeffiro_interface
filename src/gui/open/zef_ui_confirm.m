function [choice, fig] = zef_ui_confirm(question, varargin)
%ZEF_UI_CONFIRM  Themed Yes/No dialog (replaces MATLAB questdlg).
%
%   Zeffiro Interface.
%   Copyright © 2018- Sampsa Pursiainen & ZI Development Team
%   See: https://github.com/sampsapursiainen/zeffiro_interface
%   Licensed under the GNU General Public License v3.0 (see LICENSE).
%
%   Drop-in for the project's historical
%   questdlg(question,'Yes','No') callbacks: extra Yes/No/Cancel
%   arguments are ignored, and the return value is 'Yes' or 'No'.
%
%   choice = zef_ui_confirm(question)
%   choice = zef_ui_confirm(question, 'Yes', 'No')
%   [choice, fig] = zef_ui_confirm(question, 'Wait', false)
%
%   See also zef_about_dialog, zef_ui_theme.

if nargin < 1 || isempty(question)
    question = 'Continue?';
end
try
    question = char(string(question));
catch
    question = 'Continue?';
end

wait_for = true;
title = 'ZEFFIRO Interface';
i = 1;
while i <= numel(varargin)
    arg = varargin{i};
    if ischar(arg) || isstring(arg)
        tok = char(arg);
        if strcmpi(tok, 'Wait') && i < numel(varargin)
            wait_for = logical(varargin{i + 1});
            i = i + 2;
            continue
        end
        if any(strcmpi(tok, {'Yes', 'No', 'Cancel'}))
            i = i + 1;
            continue
        end
        if ~isempty(strtrim(tok))
            title = tok;
        end
    end
    i = i + 1;
end

theme = zef_ui_theme();
style = 'modal';
if ~wait_for
    style = 'normal';
end
fig = uifigure( ...
    'Name', 'ZEFFIRO Interface: Confirm', ...
    'Tag', 'zef_confirm', ...
    'WindowStyle', style, ...
    'Resize', 'on', ...
    'Color', theme.color.bg, ...
    'Position', [160 160 420 176], ...
    'Visible', 'off');
try
    zef_window_manager('standalone', fig);
catch
end

gl = uigridlayout(fig, [3 4]);
gl.Tag = 'zef_ui_root';
gl.RowHeight = {26, '1x', 36};
gl.ColumnWidth = {'1x', 96, 96, '1x'};
gl.Padding = [22 16 22 16];
gl.RowSpacing = 10;
gl.ColumnSpacing = 8;
gl.BackgroundColor = theme.color.bg;

title_lab = uilabel(gl, 'Text', title, ...
    'FontWeight', 'bold', 'FontSize', theme.font.sizeTitle, ...
    'FontColor', theme.color.text, 'HorizontalAlignment', 'left');
title_lab.Layout.Row = 1;
title_lab.Layout.Column = [1 4];
q_lab = uilabel(gl, 'Text', question, ...
    'FontColor', theme.color.text, 'WordWrap', 'on', ...
    'HorizontalAlignment', 'left');
q_lab.Layout.Row = 2;
q_lab.Layout.Column = [1 4];
no_btn = uibutton(gl, 'Text', 'No', 'Tag', 'zef_confirm_no', ...
    'ButtonPushedFcn', @(src, ~) local_finish(src, 'No'));
no_btn.Layout.Row = 3;
no_btn.Layout.Column = 2;
yes = uibutton(gl, 'Text', 'Yes', 'Tag', 'zef_confirm_yes', ...
    'ButtonPushedFcn', @(src, ~) local_finish(src, 'Yes'));
yes.Layout.Row = 3;
yes.Layout.Column = 3;

fig.CloseRequestFcn = @(src, ~) local_finish(src, 'No');
setappdata(fig, 'ZefConfirmChoice', 'No');

try
    zef_ui_apply_theme(fig, theme);
    zef_ui_polish_window(fig, theme);
catch
end
try
    yes.BackgroundColor = theme.color.primary;
    yes.FontColor = theme.color.primaryText;
catch
end
try
    setappdata(fig, 'ZefUiThemed', true);
catch
end

choice = 'No';
try
    zef_ui_bind_min_size(fig, 360, 148);
catch
end
try
    fig.WindowKeyPressFcn = @(src, evt) local_key(src, evt);
catch
end
try
    zef_ui_place_window(fig);
catch
end
fig.Visible = 'on';
try
    zef_window_manager('raise', fig);
catch
end
if wait_for
    try
        if isvalid(fig) && ~strcmpi(char(fig.WindowStyle), 'modal')
            fig.WindowStyle = 'modal';
        end
    catch
    end
    uiwait(fig);
    if isgraphics(fig) && isvalid(fig)
        delete(fig);
    end
    fig = gobjects(0);
end

    function local_finish(src, value)
        % Shared with the caller. Must be set before uiresume, because
        % the figure may close before uiwait returns.
        choice = value;
        fig_h = ancestor(src, 'figure');
        if isempty(fig_h) || ~isvalid(fig_h)
            fig_h = src;
        end
        if isempty(fig_h) || ~isvalid(fig_h)
            return
        end
        try
            setappdata(fig_h, 'ZefConfirmChoice', value);
        catch
        end
        try
            uiresume(fig_h);
        catch
        end
        if ~wait_for
            try
                delete(fig_h);
            catch
            end
        end
    end

    function local_key(src, evt)
        key = '';
        try
            if isstruct(evt) && isfield(evt, 'Key')
                key = char(evt.Key);
            end
        catch
        end
        if any(strcmpi(key, {'escape', 'n'}))
            local_finish(src, 'No');
        elseif any(strcmpi(key, {'return', 'y', 'space'}))
            local_finish(src, 'Yes');
        end
    end

end
