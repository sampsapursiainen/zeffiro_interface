function theme = zef_ui_theme(zef)
%ZEF_UI_THEME  Shared visual tokens for every Zeffiro window.
%
%   Zeffiro Interface.
%   Copyright © 2018- Sampsa Pursiainen & ZI Development Team
%   See: https://github.com/sampsapursiainen/zeffiro_interface
%   Licensed under the GNU General Public License v3.0 (see LICENSE).
%
%   Cool-gray surfaces and a restrained teal accent. This is the single
%   canonical visual system. Legacy zef.ui_color_mode is ignored. Font
%   size is at least 11 px even when the INI still says 8. Shell geometry
%   (nav/header/footer) lives in theme.space.* so every window can share
%   the same proportions.
%
%   theme = zef_ui_theme
%   theme = zef_ui_theme(zef)
%
%   See also zef_ui_apply_theme, zef_waitbar.

persistent theme_cache
if nargin < 1
    zef = struct();
    try
        zef = evalin('base', 'zef');
    catch
    end
end

font_size = 12;
if isstruct(zef) && isfield(zef, 'font_size') && ~isempty(zef.font_size)
    font_size = max(11, double(zef.font_size));
end

if ~isempty(theme_cache) && isstruct(theme_cache) ...
        && isfield(theme_cache, 'font_size') && theme_cache.font_size == font_size ...
        && isfield(theme_cache, 'theme')
    theme = theme_cache.theme;
    return
end

theme = struct();
theme.mode = 'light';
theme.color.bg = [0.965 0.970 0.974];
theme.color.panel = [1.000 1.000 1.000];
theme.color.panelAlt = [0.955 0.962 0.966];
theme.color.text = [0.145 0.175 0.210];
theme.color.textMuted = [0.380 0.425 0.460];
theme.color.accent = [0.120 0.520 0.550];
theme.color.accentSoft = [0.820 0.870 0.880];
theme.color.button = [1.000 1.000 1.000];
theme.color.buttonText = [0.145 0.175 0.210];
theme.color.primary = [0.120 0.520 0.550];
theme.color.primaryText = [1.000 1.000 1.000];
theme.color.border = [0.820 0.848 0.858];
theme.color.buttonBorder = [0.680 0.720 0.750];
theme.color.buttonBorderPrimary = 0.78 * theme.color.primary;
theme.color.inputBg = [1.000 1.000 1.000];
theme.color.axesBg = [1.000 1.000 1.000];
theme.color.header = [0.120 0.520 0.550];
theme.color.slider = [0.120 0.520 0.550];
theme.color.navBg = [1.000 1.000 1.000];
theme.color.headerBg = [1.000 1.000 1.000];
theme.color.footerBg = [0.965 0.970 0.974];
theme.color.navHover = [0.820 0.870 0.880];
theme.color.navActive = [0.820 0.870 0.880];
theme.color.navIcon = [0.220 0.420 0.450];
theme.color.ready = [0.180 0.620 0.360];
theme.color.readyBg = [0.890 0.980 0.925];
theme.color.readyText = [0.200 0.550 0.340];
theme.color.badge = [0.925 0.941 0.988];
theme.color.badgeText = [0.545 0.592 0.678];
theme.color.rowSel = [0.910 0.933 0.988];
theme.color.check = [0.290 0.435 0.960];
theme.color.checkBorder = [0.780 0.812 0.845];
theme.color.hairline = [0.933 0.937 0.945];
theme.color.cardEdge = [0.860 0.918 0.922];
theme.color.workspace = [1.000 1.000 1.000];
theme.color.disabled = [0.720 0.745 0.760];
theme.color.tableRow = [1.000 1.000 1.000];
theme.color.tableAlt = [0.948 0.956 0.960];
theme.color.tableHeader = [0.955 0.962 0.966];
theme.color.selection = [0.820 0.870 0.880];
theme.color.hover = [0.910 0.930 0.932];
theme.color.warning = [0.780 0.520 0.120];
theme.color.danger = [0.720 0.220 0.220];
theme.color.surface = theme.color.panel;
theme.color.surfaceSecondary = theme.color.panelAlt;
theme.color.surfaceRaised = theme.color.panel;
theme.color.textPrimary = theme.color.text;
theme.color.textSecondary = theme.color.textMuted;
theme.color.borderSubtle = theme.color.hairline;
theme.color.error = theme.color.danger;
theme.color.success = theme.color.ready;
theme.color.accentHover = [0.100 0.460 0.490];
theme.color.accentPressed = [0.080 0.380 0.410];

theme.font.name = local_font_name();
theme.font.size = font_size;
theme.font.sizeSmall = max(10, font_size - 1);
theme.font.sizeTitle = font_size + 1;
theme.font.weight = 'normal';

theme.space.pad = 10;
theme.space.gap = 8;
theme.space.row = 22;
theme.space.btnH = 26;
% Java uicontrol sliders on macOS paint arrow buttons that clip when the
% Position height is below 16 px. Taller values only stretch the track.
theme.space.sliderH = 16;
theme.space.sliderGap = 3;
theme.space.popupH = 22;
theme.space.rowGap = 4;
theme.space.labelW = 110;
theme.space.sectionGap = 8;
theme.space.sidebarW = 240;
theme.space.bottomH = 168;
% Figure-tool inspector card. Fixed for empty and loaded projects.
theme.space.statusH = 125;
theme.space.editW = 48;
theme.space.tableRow = 28;
theme.space.minWinW = 720;
theme.space.minWinH = 540;
theme.space.navW = 168;
theme.space.navWCompact = 52;
theme.space.headerH = 40;
theme.space.footerH = 22;
theme.space.tabH = 28;
theme.space.toolbarH = 36;
theme.space.navItemH = 32;
theme.space.cardGap = 12;
% Base band between the header and the three workspace cards. Layout
% scales this with window size so compact windows stay tight.
theme.space.headerGap = 12;
theme.space.cardRadius = 12;
theme.space.btnRadius = 6;
theme.space.btnStroke = 1;
theme.space.flyoutW = 268;
theme.space.shellMinW = 980;
theme.space.shellMinH = 620;
theme.space.shellDefW = 1000;
theme.space.shellDefH = 646;

theme_cache = struct('font_size', font_size, 'theme', theme);

end

function name = local_font_name()

persistent cached
if ~isempty(cached)
    name = cached;
    return
end
% listfonts enumerates every installed face and costs ~1 s on macOS.
% These system UI fonts are present on the platforms Zeffiro ships on.
if ismac
    name = 'Helvetica Neue';
elseif ispc
    name = 'Segoe UI';
else
    name = 'Helvetica';
end
cached = name;

end
