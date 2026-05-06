function h = zef_plot_selected_source_to_axes_stem(treeObj, h_axes, varargin)
%ZEF_PLOT_SELECTED_SOURCE_TO_AXES_STEM Plot selected UI-tree node as a 3D stem/arrow (zef_plot_3D_arrow).
%
% Reads selection from treeObj (uitree) and uses nodeUI.NodeData fields:
%   NodeData.SourcePosition.Value      (1x3)
%   NodeData.SourceOrientation.Value   (1x3)
% Optional:
%   NodeData.SourceAmplitude.Value     (scalar) -> scales arrow (sqrt)
%
% Does NOT access zef.source_tree_published.
%
% Name-value options:
%   'ArrowScaleBase'   : base scale multiplier (default 5)
%   'ArrowType'        : default 1
%   'ArrowColor'       : color spec OR [] to use 'ColorCell' indexing (default [0.5 0.5 0.5])
%   'ArrowShape'       : default 10
%   'ArrowLength'      : default 1
%   'ArrowHeadSize'    : default 2
%   'ArrowNPolygons'   : default 100
%   'ColorCell'        : cell array like {'k','r',...} (default ZI style)
%   'ColorIndexField'  : NodeData field for color index, e.g. {'Plot','ColorIndex'} (default empty -> uses ArrowColor)
%   'DeletePrevious'   : default true (deletes zef.h_tree_source if exists)
%   'StoreHandleToZef' : default true (stores to zef.h_tree_source)
%   'Tag'              : default 'additional: selected tree source'
%
% Output:
%   h : handle(s) returned by zef_plot_3D_arrow

% ---- defaults for stem/arrow ----
p = inputParser;
p.addParameter('ArrowScaleBase', 20, @(x)isnumeric(x)&&isscalar(x)&&isfinite(x)&&x>0);
p.addParameter('ArrowType', 1, @(x)isnumeric(x)&&isscalar(x));
p.addParameter('ArrowColor', [0 1 0], @(c) isempty(c) || ischar(c)||isstring(c) || (isnumeric(c)&&numel(c)==3));
p.addParameter('ArrowShape', 10, @(x)isnumeric(x)&&isscalar(x));
p.addParameter('ArrowLength', 1, @(x)isnumeric(x)&&isscalar(x));
p.addParameter('ArrowHeadSize', 2, @(x)isnumeric(x)&&isscalar(x));
p.addParameter('ArrowNPolygons', 100, @(x)isnumeric(x)&&isscalar(x)&&x>=8);
p.addParameter('ScaleByAmplitude', true, @(x)islogical(x)&&isscalar(x));
p.addParameter('DeletePrevious', true, @(x)islogical(x)&&isscalar(x));
p.addParameter('StoreHandleToZef', true, @(x)islogical(x)&&isscalar(x));
p.addParameter('Tag', 'additional: selected tree source', @(s)ischar(s)||isstring(s));

% optional color-by-index support (like inv_synth_source(:,10))
p.addParameter('ColorCell', {'k','r','g','b','y','m','c'}, @(c)iscell(c)&&~isempty(c));
p.addParameter('ColorIndexField', {}, @(c)iscell(c));  % e.g. {'Plot','ColorIndex'} or {'ColorIndex'}

p.parse(varargin{:});
opt = p.Results;

% ---- checks ----
if nargin < 2 || isempty(h_axes) || ~ishandle(h_axes)
    error('Provide a valid target axes handle.');
end
if isempty(treeObj) || ~isvalid(treeObj)
    error('treeObj is empty/invalid.');
end

% ---- delete previous handle if desired ----
if opt.DeletePrevious
    try
        zef_has = evalin('base',"exist('zef','var') && isstruct(zef)");
        if zef_has && evalin('base',"isfield(zef,'h_tree_source')")
            h_prev = evalin('base','zef.h_tree_source');
            if ~isempty(h_prev)
                try, delete(h_prev(ishandle(h_prev))); catch, end
            end
        end
    catch
    end
end

% ---- selected UI node ----
sel = [];
if isprop(treeObj,'SelectedNodes')
    sel = treeObj.SelectedNodes;
elseif isprop(treeObj,'SelectedNode')
    sel = treeObj.SelectedNode;
end
if isempty(sel)
    error('No node selected in the tree.');
end
nodeUI = sel(1);

% ---- extract NodeData (UI node) ----
if ~isprop(nodeUI,'NodeData') || isempty(nodeUI.NodeData)
    error('Selected UI node has no NodeData.');
end
nd = nodeUI.NodeData;

% If UI stored full tree node struct, unwrap:
if isfield(nd,'NodeData') && isstruct(nd.NodeData)
    nd = nd.NodeData;
end

pos = get_value_nested(nd, {'SourcePosition','Value'});
ori = get_value_nested(nd, {'SourceOrientation','Value'});
pos = pos(:).'; ori = ori(:).';
if numel(pos)~=3, error('SourcePosition must be 1x3.'); end
if numel(ori)~=3, error('SourceOrientation must be 1x3.'); end

% normalize orientation
nrm = norm(ori);
if nrm < eps
    ori = [1 0 0];
else
    ori = ori ./ nrm;
end

% optional amplitude scaling
amp = [];
if isfield(nd,'SourceAmplitude')
    try
        amp = get_value_nested(nd, {'SourceAmplitude','Value'});
        if ~isscalar(amp), amp = amp(1); end
    catch
        amp = [];
    end
end

% arrow_scale like in your synthetic source: arrow_scale = 5*sqrt(s(i,9))
arrow_scale = opt.ArrowScaleBase;
if opt.ScaleByAmplitude && ~isempty(amp) && isfinite(amp) && amp > 0
    arrow_scale = opt.ArrowScaleBase * sqrt(amp);
end

% determine arrow color:
arrow_color = opt.ArrowColor;
if isempty(arrow_color) && ~isempty(opt.ColorIndexField)
    % try to read color index from NodeData
    try
        cidx = get_value_nested(nd, [opt.ColorIndexField {'Value'}]); %#ok<NBRAK>
    catch
        try
            cidx = get_value_nested(nd, opt.ColorIndexField);
        catch
            cidx = [];
        end
    end
    if ~isempty(cidx) && isnumeric(cidx) && isscalar(cidx)
        cidx = max(1, min(numel(opt.ColorCell), round(cidx)));
        arrow_color = opt.ColorCell{cidx};
    else
        arrow_color = 0.5*[1 1 1];
    end
elseif isempty(arrow_color)
    arrow_color = 0.5*[1 1 1];
end

% ---- draw into existing axes without clearing ----
axes(h_axes); %#ok<LAXES>
hold(h_axes,'on');

% IMPORTANT: zef_plot_3D_arrow must exist on path.
h = zef_plot_3D_arrow( ...
    pos(1), pos(2), pos(3), ...
    ori(1), ori(2), ori(3), ...
    arrow_scale, opt.ArrowType, arrow_color, ...
    opt.ArrowShape, opt.ArrowLength, opt.ArrowHeadSize, opt.ArrowNPolygons);

try
    set(h,'Tag', char(string(opt.Tag)));
catch
end

hold(h_axes,'off');

% ---- store handle (optional) ----
if opt.StoreHandleToZef
    try
        evalin('base','if ~exist(''zef'',''var''), zef = struct(); end');
        assignin('base','ans',h); %#ok<NASGU>
        evalin('base','zef.h_tree_source = ans; clear ans;');
    catch
    end
end

end

% -------------------------------------------------------------------------
function v = get_value_nested(s, path)
cur = s;
for k = 1:numel(path)
    f = path{k};
    if ~isstruct(cur) || ~isfield(cur,f)
        error('Missing field: %s', f);
    end
    cur = cur.(f);
end
v = cur;
end
