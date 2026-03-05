function [zef, Y, info] = zef_simulate_measurements_from_outPub(zef, sourceTree, outPub, varargin)
%ZEF_SIMULATE_MEASUREMENTS_FROM_OUTPUB
% Plot-driven measurement simulator (outPub -> sensor data):
%   - iterates over outPub.nodes exactly like zef_plot_outPub
%   - takes y = upAbsByPass(:,pass) and ignores NaNs like plot
%   - fetches node parameters (pos, ori, amp, noise) from sourceTree by path
%   - projects into sensors using zef.L and zef.source_positions
%
% Inputs:
%   zef.L               : K x (3N) lead field (xyz blocks)
%   zef.source_positions: N x 3
%   sourceTree          : parameter tree (struct with NodeData)
%   outPub              : published signals (struct with .tAbs and .nodes)
%
% Name-value:
%   'Pass'          : default 1
%       - numeric scalar -> use that pass only
%       - numeric vector -> use those passes
%       - "all" -> use all passes available per node
%   'PositionTol'   : default Inf
%   'UseCheckedOnly': default false
%   'GlobalNoiseStd': default [] (uses zef.source_tree_signal_parameters.gaussianNoiseStd)
%   'NodeNoiseMode' : default 'source' ('source'|'sensor')
%   'NodeFilter'    : default "" (like plot: only nodes whose path contains this)
%
% Output:
%   zef.measurements = Y (K x M), where M = numel(outPub.tAbs)

    p = inputParser;
    p.addParameter('Pass', 1, @(x) (isnumeric(x) && all(isfinite(x(:))) && all(x(:)>=1)) || ischar(x) || isstring(x));
    p.addParameter('PositionTol', Inf, @(x)isnumeric(x)&&isscalar(x)&&x>=0);
    p.addParameter('UseCheckedOnly', false, @(x)islogical(x)&&isscalar(x));
    p.addParameter('GlobalNoiseStd', [], @(x)isnumeric(x)&&isscalar(x) || isempty(x));
    p.addParameter('NodeNoiseMode', 'source', @(s)ischar(s)||isstring(s));
    p.addParameter('NodeFilter', "", @(s)ischar(s)||isstring(s));
    p.parse(varargin{:});

    passSpec      = p.Results.Pass;
    posTol        = p.Results.PositionTol;
    useCheckedOnly= p.Results.UseCheckedOnly;
    nodeNoiseMode = lower(string(p.Results.NodeNoiseMode));
    nodeFilter    = string(p.Results.NodeFilter);

    if ~isfield(zef,'L') || isempty(zef.L)
        error('zef_simulate_measurements_from_outPub:MissingL', 'zef.L is missing/empty.');
    end
    if ~isfield(zef,'source_positions') || isempty(zef.source_positions)
        error('zef_simulate_measurements_from_outPub:MissingPositions', 'zef.source_positions is missing/empty.');
    end
    if ~isstruct(outPub) || ~isfield(outPub,'nodes') || ~isfield(outPub,'tAbs')
        error('zef_simulate_measurements_from_outPub:InvalidOutPub', 'outPub must have fields .tAbs and .nodes.');
    end

    K = size(zef.L,1);
    M = numel(outPub.tAbs);

    % --- global sensor noise std ---
    if ~isempty(p.Results.GlobalNoiseStd)
        sigma_global = double(p.Results.GlobalNoiseStd);
    else
        sigma_global = 0;
        if isfield(zef,'source_tree_signal_parameters') && isfield(zef.source_tree_signal_parameters,'gaussianNoiseStd')
            gstd = zef.source_tree_signal_parameters.gaussianNoiseStd;
            if isstruct(gstd) && isfield(gstd,'Value')
                sigma_global = double(gstd.Value);
            elseif isnumeric(gstd)
                sigma_global = double(gstd);
            end
        end
    end

    measurement_scale_conversion = 1;
        if isfield(zef,'source_tree_signal_parameters')
           if isfield(zef.source_tree_signal_parameters,'gainConversion')
            measurement_scale_conversion = zef.source_tree_signal_parameters.gainConversion.Value;
        end
        end

    % Build a fast map: path(char) -> meta struct with NodeData/UserData
    srcMap = zef_local_build_pathmap_from_sourceTree(sourceTree);

    Y = zeros(K, M);

    info = struct();
    info.nNodesTotal = numel(outPub.nodes);
    info.nUsed       = 0;
    info.pathsUsed   = strings(0,1);
    info.passSpec    = passSpec;

    for k = 1:numel(outPub.nodes)
        path = string(outPub.nodes(k).path);

        % Same filtering semantics as plot
        if nodeFilter ~= "" && ~contains(path, nodeFilter, 'IgnoreCase', true)
            continue;
        end

        if ~isfield(outPub.nodes(k),'upAbsByPass')
            continue;
        end

        U = outPub.nodes(k).upAbsByPass;
        if isempty(U)
            continue;
        end

        % Determine which passes to use for THIS node
        passList = zef_local_resolve_pass_list(passSpec, size(U,2));
        if isempty(passList)
            continue;
        end

        % Fetch corresponding NodeData from sourceTree by path
        pchar = char(path);
        if ~isKey(srcMap, pchar)
            continue;
        end
        meta = srcMap(pchar);
        nd   = meta.NodeData;

        if useCheckedOnly
            isChecked = false;
            if isfield(meta,'UserData') && isstruct(meta.UserData) && isfield(meta.UserData,'IsChecked')
                isChecked = logical(meta.UserData.IsChecked);
            end
            if ~isChecked
                continue;
            end
        end

        pos  = zef_local_get_nd_value(nd, 'SourcePosition', [0 0 0]);
        ori  = zef_local_get_nd_value(nd, 'SourceOrientation', [1 0 0]);
        nstd = zef_local_get_nd_value(nd, 'SourceNoiseStd', 0);

        pos  = zef_local_row3(pos);
        ori  = zef_local_safe_unit(zef_local_row3(ori));
        nstd = double(nstd);


        [idx, dmin] = zef_local_find_source_index(zef.source_positions, pos);
        if isempty(idx) || dmin > posTol
            continue;
        end

        cols = (3*(idx-1)+1):(3*idx);
        if cols(end) > size(zef.L,2)
            continue;
        end

        Gi = measurement_scale_conversion*zef.L(:, cols);   % Kx3
        g  = Gi * ori(:);      % Kx1

        % --- Add contributions for selected passes, plot-like NaN handling ---
        usedThisNode = false;

        for pass = passList
            y = double(U(:,pass));        % Mx1 (ideally)
            if numel(y) ~= M
                % best effort: skip inconsistent pass
                continue;
            end

            mask = isfinite(y);
            if ~any(mask)
                continue;
            end

            usedThisNode = true;

            if nstd > 0
                switch nodeNoiseMode
                    case "sensor"
                        Y(:,mask) = Y(:,mask) + g * y(mask).' + (nstd) .* randn(K, nnz(mask));
                    otherwise
                        y2 = y(mask).' + (nstd) .* randn(1, nnz(mask));
                        Y(:,mask) = Y(:,mask) + g * y2;
                end
            else
                Y(:,mask) = Y(:,mask) + g * y(mask).';
            end
        end

        if usedThisNode
            info.nUsed = info.nUsed + 1;
            info.pathsUsed(end+1,1) = path; %#ok<AGROW>
        end
    end

    if sigma_global > 0
        Y = Y + sigma_global .* randn(size(Y));
    end

    zef.measurements = Y;
end

% ======================================================================
% Helper: resolve pass specification -> pass list
% ======================================================================

function passList = zef_local_resolve_pass_list(passSpec, nPass)
    if ischar(passSpec) || isstring(passSpec)
        s = lower(string(passSpec));
        if s == "all"
            passList = 1:nPass;
        else
            error('zef_simulate_measurements_from_outPub:BadPass', ...
                  'Pass must be numeric (scalar/vector) or "all".');
        end
        return;
    end

    passList = unique(round(double(passSpec(:).')));
    passList = passList(isfinite(passList) & passList >= 1 & passList <= nPass);
end

% ======================================================================
% Helper: build path->meta map from sourceTree
% ======================================================================

function mp = zef_local_build_pathmap_from_sourceTree(treeStruct)
    mp = containers.Map('KeyType','char','ValueType','any');

    if ~isstruct(treeStruct)
        return;
    end

    reserved = {'Text','UserData','NodeData','t','Vp','Vpe','Vpi','up','upRaw','upNet','qpRaw',...
                'samplingRate_Hz','blockDuration_s','nPass'};

    roots = fieldnames(treeStruct);
    stackNode = {};
    stackPath = {};

    for r = numel(roots):-1:1
        nm = roots{r};
        v  = treeStruct.(nm);
        if isstruct(v) && isfield(v,'NodeData')
            stackNode{end+1} = v; %#ok<AGROW>
            stackPath{end+1} = nm; %#ok<AGROW>
        end
    end

    while ~isempty(stackNode)
        ns   = stackNode{end}; stackNode(end) = [];
        path = stackPath{end}; stackPath(end) = [];

        meta = struct();
        meta.NodeData = ns.NodeData;
        if isfield(ns,'UserData'), meta.UserData = ns.UserData; else, meta.UserData = []; end

        mp(path) = meta;

        fn = fieldnames(ns);
        childNames = {};
        childStructs = {};

        for k = 1:numel(fn)
            f = fn{k};
            if any(strcmp(f, reserved)), continue; end
            vv = ns.(f);
            if isstruct(vv) && isfield(vv,'NodeData')
                childNames{end+1}   = f;  %#ok<AGROW>
                childStructs{end+1} = vv; %#ok<AGROW>
            end
        end

        for c = numel(childNames):-1:1
            stackNode{end+1} = childStructs{c}; %#ok<AGROW>
            stackPath{end+1} = [path '.' childNames{c}]; %#ok<AGROW>
        end
    end
end

% ======================================================================
% Small utilities
% ======================================================================

function v = zef_local_get_nd_value(nd, fieldName, default)
    v = default;
    if ~isstruct(nd) || ~isfield(nd,fieldName), return; end
    s = nd.(fieldName);
    if isstruct(s) && isfield(s,'Value')
        v = s.Value;
    else
        v = s;
    end
end

function r = zef_local_row3(x)
    x = double(x(:));
    if numel(x) < 3
        r = [x(:).' zeros(1,3-numel(x))];
    else
        r = x(1:3).';
    end
end

function u = zef_local_safe_unit(v)
    n = norm(v);
    if n > 0
        u = v ./ n;
    else
        u = [1 0 0];
    end
end

function [idx, dmin] = zef_local_find_source_index(P, pos)
    dif = P - pos;
    d2  = sum(dif.^2, 2);
    [d2min, idx] = min(d2);
    dmin = sqrt(d2min);
    if isempty(idx) || ~isfinite(dmin)
        idx = [];
        dmin = inf;
    end
end
