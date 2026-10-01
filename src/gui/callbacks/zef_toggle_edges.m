function zef_toggle_edges
%ZEF_TOGGLE_EDGES  Flip mesh edges on the current Figure-tool axes.
%
%   Zeffiro Interface.
%   Copyright © 2018- Sampsa Pursiainen & ZI Development Team
%   See: https://github.com/sampsapursiainen/zeffiro_interface
%   Licensed under the GNU General Public License v3.0 (see LICENSE).
%
%   Figure tool button Toggle edges (Tag toggleedgesbutton; Callback
%   "zef_toggle_edges;") and the toolbar button Tag zef_tool_edges.
%   Function with no arguments.
%
%   A patch, and a sensor surface, never get EdgeColor. On a uiaxes that
%   property extends each segment across the plot, which is the grid of
%   lines past the head. Those objects are drawn as a line strip of their
%   edges. A surface fine enough to cover the view (the scalp is hundreds
%   of thousands of millimetre edges) is drawn from a coarser lattice on
%   the same vertices, so the wireframe stays on the head and the faces
%   still show. Any other surface keeps the original contract: 'none'
%   becomes the theme text color, and theme text or legacy white [1 1 1]
%   goes back to 'none'. A second press deletes the strips. Faces, CData,
%   and the camera stay as they were.
%
%   See also zef_toggle_figure_controls, zef_figure_tool.

h = zef_ui_axes();
if isempty(h)
    return
end
ax = h(1);
on_color = [0.145 0.175 0.210];
try
    th = zef_ui_theme();
    on_color = th.color.text;
catch
end
cam = local_cam_snapshot(ax);
kids = get(ax, 'Children');
for i = 1 : numel(kids)
    obj = kids(i);
    if ~isgraphics(obj) || ~isvalid(obj) || local_is_overlay(obj)
        continue
    end
    kind = char(string(obj.Type));
    if ~strcmpi(kind, 'patch') && ~strcmpi(kind, 'surface')
        continue
    end
    if ~isprop(obj, 'EdgeColor')
        continue
    end
    if local_edges_are_on(obj, on_color)
        local_edges_off(obj);
    else
        local_edges_on(obj, on_color);
    end
end
local_cam_restore(ax, cam);

end

function tf = local_edges_are_on(obj, on_color)

tf = false;
ec = obj.EdgeColor;
if isequal(ec, on_color) || isequal(ec, [1 1 1])
    tf = true;
    return
end
tf = local_has_overlay(obj);

end

function local_edges_off(obj)

set(obj, 'EdgeColor', 'none');
if isappdata(obj, 'ZefEdgeOverlay')
    ln = getappdata(obj, 'ZefEdgeOverlay');
    try
        rmappdata(obj, 'ZefEdgeOverlay');
    catch
    end
    if isgraphics(ln)
        delete(ln);
    end
end

end

function local_edges_on(obj, on_color)

% EdgeColor on a patch or a sensor sphere in these axes extends
% segments past the mesh. An untagged surface (the figure-tool contract
% test) still uses that property.
kind = char(string(obj.Type));
if strcmpi(kind, 'patch') && isprop(obj, 'Faces') ...
        && isprop(obj, 'Vertices') && size(obj.Faces, 1) > 0 ...
        && size(obj.Faces, 2) >= 2
    local_edges_off(obj);
    ln = local_wire_overlay(obj, on_color);
    if isgraphics(ln)
        setappdata(obj, 'ZefEdgeOverlay', ln);
    end
    return
end
if strcmpi(kind, 'surface') && strcmpi(char(string(obj.Tag)), 'sensor')
    local_edges_off(obj);
    ln = local_sensor_overlay(obj, on_color);
    if isgraphics(ln)
        setappdata(obj, 'ZefEdgeOverlay', ln);
    end
    return
end
set(obj, 'EdgeColor', on_color);

end

function ln = local_wire_overlay(obj, color)

ln = gobjects(0);
F = obj.Faces;
V = obj.Vertices;
if isempty(F) || isempty(V) || ~isnumeric(F) || ~isnumeric(V)
    return
end
if max(F(:)) <= double(intmax('uint32'))
    F = uint32(F);
end
nf = size(F, 1);
n = size(F, 2);
E = zeros(nf * n, 2, 'like', F);
for k = 1 : n
    k2 = k + 1;
    if k2 > n
        k2 = 1;
    end
    rows = (k - 1) * nf + (1 : nf);
    E(rows, 1) = F(:, k);
    E(rows, 2) = F(:, k2);
end
E = sort(E, 2);
E = E(E(:, 1) ~= E(:, 2) & E(:, 1) >= 1 & E(:, 2) >= 1, :);
if isempty(E)
    return
end
E = unique(E, 'rows');
used = unique(E(:));
if numel(used) < size(V, 1)
    map = zeros(double(max(used)), 1, 'uint32');
    map(used) = uint32(1 : numel(used)).';
    E = map(E);
    V = V(double(used), :);
end
[E, V] = local_coarsen_wire(E, V, obj.Parent);
if isempty(E)
    return
end
nedge = size(E, 1);
P = zeros(3, 2 * nedge, 'single');
P(:, 1:2:end) = single(V(double(E(:, 1)), :)).';
P(:, 2:2:end) = single(V(double(E(:, 2)), :)).';
ln = local_segment_strip(obj.Parent, P, color);

end

function [E, V] = local_coarsen_wire(E, V, parent)

% A full edge set of a dense scalp is one short segment per pixel, so the
% strip paints a solid silhouette. Quantize vertices in world units until
% the strip is a few thousand segments on the same surface.
if size(E, 1) <= 6000
    return
end
V = double(V);
ext = max(V, [], 1) - min(V, [], 1);
span = max(ext);
if ~(isfinite(span) && span > 0)
    return
end
cell = local_edge_cell(parent, span);
for pass = 1:5
    key = round(V / cell);
    [~, ia, ic] = unique(key, 'rows');
    Vc = V(ia, :);
    Ec = ic(double(E));
    Ec = sort(Ec, 2);
    Ec = Ec(Ec(:, 1) ~= Ec(:, 2), :);
    if isempty(Ec)
        E = Ec;
        V = Vc;
        return
    end
    Ec = unique(Ec, 'rows');
    E = Ec;
    V = Vc;
    if size(E, 1) <= 8000 || cell >= span / 20
        return
    end
    cell = min(span / 20, cell * 1.7);
    if pass == 5
        return
    end
end

end

function cell = local_edge_cell(ax, span)

cell = span / 48;
if ~isgraphics(ax) || ~isprop(ax, 'CameraPosition')
    return
end
try
    dist = norm(ax.CameraPosition - ax.CameraTarget);
    va = double(ax.CameraViewAngle);
    wh = getpixelposition(ax, false);
    minor = max(1, min(wh(3), wh(4)));
    world_per_px = (2 * dist * tand(va / 2)) / minor;
    if isfinite(world_per_px) && world_per_px > 0
        cell = 4 * world_per_px;
    end
catch
end
cell = min(max(cell, span / 160), span / 28);

end

function ln = local_sensor_overlay(obj, color)

ln = gobjects(0);
try
    X = double(obj.XData);
    Y = double(obj.YData);
    Z = double(obj.ZData);
catch
    return
end
if ~ismatrix(X) || ~isequal(size(X), size(Y)) || ~isequal(size(X), size(Z))
    return
end
[m, n] = size(X);
if m < 2 || n < 2
    return
end
A = [reshape(X(:, 1:end-1), [], 1); reshape(X(1:end-1, :), [], 1)];
B = [reshape(X(:, 2:end), [], 1); reshape(X(2:end, :), [], 1)];
Ay = [reshape(Y(:, 1:end-1), [], 1); reshape(Y(1:end-1, :), [], 1)];
By = [reshape(Y(:, 2:end), [], 1); reshape(Y(2:end, :), [], 1)];
Az = [reshape(Z(:, 1:end-1), [], 1); reshape(Z(1:end-1, :), [], 1)];
Bz = [reshape(Z(:, 2:end), [], 1); reshape(Z(2:end, :), [], 1)];
keep = isfinite(A) & isfinite(B) & isfinite(Ay) & isfinite(By) ...
    & isfinite(Az) & isfinite(Bz);
if ~any(keep(:))
    return
end
P = zeros(3, 2 * nnz(keep), 'single');
P(1, 1:2:end) = single(A(keep)).';
P(2, 1:2:end) = single(Ay(keep)).';
P(3, 1:2:end) = single(Az(keep)).';
P(1, 2:2:end) = single(B(keep)).';
P(2, 2:2:end) = single(By(keep)).';
P(3, 2:2:end) = single(Bz(keep)).';
ln = local_segment_strip(obj.Parent, P, color);

end

function ln = local_segment_strip(parent, P, color)

% Two vertices per edge. Patch EdgeColor extends those segments across
% the axes; this strip keeps each one finite.
ln = gobjects(0);
if isempty(P)
    return
end
rgb = uint8(round(double(color(:)) * 255));
if numel(rgb) < 3
    rgb = uint8([37; 45; 54]);
end
nedge = size(P, 2) / 2;
ln = matlab.graphics.primitive.world.LineStrip('Parent', parent);
ln.VertexData = P;
ln.StripData = uint32(1:2:(2 * nedge + 1));
ln.ColorData = [rgb(1:3); uint8(255)];
ln.ColorBinding = 'object';
ln.LineWidth = 0.5;
ln.AlignVertexCenters = 'on';
ln.HitTest = 'off';
ln.PickableParts = 'none';
ln.HandleVisibility = 'off';

end

function tf = local_is_overlay(obj)

tf = false;
try
    tf = strcmp(char(string(obj.Tag)), 'zef_edge_overlay');
catch
end

end

function tf = local_has_overlay(obj)

tf = false;
if ~isappdata(obj, 'ZefEdgeOverlay')
    return
end
ln = getappdata(obj, 'ZefEdgeOverlay');
tf = isgraphics(ln);

end

function cam = local_cam_snapshot(ax)

cam = struct();
props = {'CameraPosition', 'CameraTarget', 'CameraUpVector', ...
    'CameraViewAngle', 'XLim', 'YLim', 'ZLim'};
for i = 1 : numel(props)
    try
        cam.(props{i}) = get(ax, props{i});
    catch
    end
end

end

function local_cam_restore(ax, cam)

props = fieldnames(cam);
nv = cell(1, 0);
for i = 1 : numel(props)
    try
        cur = get(ax, props{i});
        if ~isequal(cur, cam.(props{i}))
            nv{end + 1} = props{i}; %#ok<AGROW>
            nv{end + 1} = cam.(props{i}); %#ok<AGROW>
        end
    catch
    end
end
if ~isempty(nv)
    set(ax, nv{:});
end

end
