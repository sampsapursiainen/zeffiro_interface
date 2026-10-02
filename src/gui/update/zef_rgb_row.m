function rgb = zef_rgb_row(value, fallback)
%ZEF_RGB_ROW  Coerce a compartment or sensor color to a 1-by-3 double in [0,1].
%
%   Zeffiro Interface.
%   Copyright © 2018- Sampsa Pursiainen & ZI Development Team
%   See: https://github.com/sampsapursiainen/zeffiro_interface
%   Licensed under the GNU General Public License v3.0 (see LICENSE).
%
%   Saved projects sometimes store zef.<tag>_color as the segmentation
%   text (for example '0.5000 0 1.0000', size 1-by-15) instead of a
%   numeric triplet. Figure-tool lists and FaceColor need 1-by-3.
%
%   rgb = zef_rgb_row(value)
%   rgb = zef_rgb_row(value, fallback)
%
%   Text is scanned as numbers, then as a MATLAB color name. A numeric
%   row longer than three keeps the first three entries. Components
%   above 1 are treated as 0–255. Unusable input returns fallback,
%   default [0.7 0.7 0.7].
%
%   See also zef_normalize_colors, zef_update_fig_details.

if nargin < 2 || isempty(fallback)
    fallback = [0.7 0.7 0.7];
end
fallback = local_fallback(fallback);
parsed = local_parse(value);
if isempty(parsed)
    rgb = fallback;
else
    rgb = parsed;
end

end

function rgb = local_fallback(value)

rgb = [0.7 0.7 0.7];
if isa(value, 'gpuArray')
    try
        value = gather(value);
    catch
        return
    end
end
if ~isnumeric(value)
    return
end
value = double(value(:))';
if numel(value) < 3 || any(~isfinite(value(1:3)))
    return
end
rgb = min(1, max(0, value(1:3)));

end

function rgb = local_parse(value)

rgb = [];
if isa(value, 'gpuArray')
    try
        value = gather(value);
    catch
        return
    end
end
if isstring(value)
    if numel(value) ~= 1
        return
    end
    value = char(value);
end
if iscell(value)
    if numel(value) == 1
        rgb = local_parse(value{1});
    end
    return
end
if ischar(value)
    text = strtrim(reshape(value, 1, []));
    if isempty(text)
        return
    end
    numeric = local_scan(text);
    if ~isempty(numeric)
        rgb = local_from_numeric(numeric);
        return
    end
    try
        named = validatecolor(text);
        rgb = double(named(1, 1:3));
    catch
    end
    return
end
if isnumeric(value)
    rgb = local_from_numeric(value);
end

end

function nums = local_scan(text)

text = strrep(text, '[', ' ');
text = strrep(text, ']', ' ');
text = strrep(text, ',', ' ');
text = strrep(text, ';', ' ');
nums = sscanf(text, '%f')';

end

function rgb = local_from_numeric(value)

rgb = [];
value = double(value(:))';
value = value(isfinite(value));
if numel(value) < 3
    return
end
rgb = value(1:3);
if max(rgb) > 1
    rgb = rgb ./ 255;
end
rgb = min(1, max(0, rgb));

end
