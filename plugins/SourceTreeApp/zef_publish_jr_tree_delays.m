function outPub = zef_publish_jr_tree_delays(outTree, sourceTree, gd, varargin)
%ZEF_PUBLISH_JR_TREE_DELAYS Publish per-pass signals into absolute-time arrays using delays.
%
% Key idea:
%   - Do NOT sum overlapping segments.
%   - Do NOT replace missing samples by zeros.
%   - Keep NaN padding; plotting will ignore NaNs.
%
% Pass shift rule (as requested):
%   passShift = maxCumDelay + maxRootDelay
%   offset(i,pass) = (pass-1)*passShift + cumDelay(i)
%
% Inputs:
%   outTree    : simulation result tree (has t and signal field per node)
%   sourceTree : original parameter tree (has NodeData with Delay fields)
%   gd         : global signal parameters (for fs if needed)
%
% Name-value:
%   'Signal' : 'up'|'upRaw'|'upNet'|'auto' (default 'auto')
%
% Output outPub:
%   outPub.tAbs : global absolute time vector
%   outPub.nodes(k).path
%   outPub.nodes(k).cumDelay_s
%   outPub.nodes(k).upAbsByPass   : [Ng x nPass] NaN-padded
%   outPub.nodes(k).signalField   : which field used
%   outPub.passShift_s

    p = inputParser;
    p.addParameter('Signal','auto',@(s)ischar(s)||isstring(s));
    p.parse(varargin{:});
    sigPref = lower(string(p.Results.Signal));

    fs = nvget(gd, 'samplingRate_Hz', 1000);

    % --- collect nodes from outTree (paths + structs) ---
    [outPaths, outNodes] = flatten_outTree_nodes(outTree);

    if isempty(outNodes)
        error('zef_publish_jr_tree_delays:NoNodes','No nodes found in outTree.');
    end

    % --- choose signal field + infer nPass and Nt ---
    [sigField, Nt, nPass] = infer_signal_layout(outNodes, sigPref);
    tLocal = outNodes{1}.t(:);
    if numel(tLocal) ~= Nt
        % best effort: use that node's t
        Nt = numel(tLocal);
    end

    % --- flatten sourceTree to get delays with SAME paths ---
    flat = flatten_sourceTree_for_delays(sourceTree, fs);

    % Build path -> idx map for delay lookup
    path2idx = containers.Map('KeyType','char','ValueType','double');
    for i = 1:flat.N
        path2idx(flat.path{i}) = i;
    end

    % --- compute cum delays for each published node (seconds & samples) ---
    cumDelaySamps = zeros(numel(outNodes),1);
    cumDelaySecs  = zeros(numel(outNodes),1);
    for k = 1:numel(outNodes)
        key = char(outPaths(k));
        if isKey(path2idx, key)
            i = path2idx(key);
            cumDelaySamps(k) = flat.cumDelaySamps(i);
            cumDelaySecs(k)  = flat.cumDelaySamps(i) / fs;
        else
            % If missing in sourceTree, assume no delay (still publish)
            cumDelaySamps(k) = 0;
            cumDelaySecs(k)  = 0;
        end
    end

    % --- pass shift per your rule ---
    maxCumDelaySamps  = max(flat.cumDelaySamps);
    maxRootDelaySamps = max(flat.rootDelaySamps);
    passShiftSamps    = maxCumDelaySamps + maxRootDelaySamps;
    passShift_s       = passShiftSamps / fs;

    % --- global length Ng: ensure we can hold last pass placed fully ---
    lastOffset = (nPass-1)*passShiftSamps + maxCumDelaySamps;
    Ng = lastOffset + Nt; % +Nt places full block
    tAbs = (0:Ng-1)'/fs;

    outPub = struct();
    outPub.tAbs = tAbs;
    outPub.passShift_s = passShift_s;

    outPub.nodes = repmat(struct( ...
        'path','', ...
        'cumDelay_s',0, ...
        'signalField','', ...
        'upAbsByPass',[]), numel(outNodes), 1);

    % --- place each node's per-pass series into absolute-time matrix ---
    for k = 1:numel(outNodes)
        nd = outNodes{k};
        u  = nd.(sigField); % Nt x nPass (or vector)

        % normalize to Nt x nPass
        U = normalize_to_matrix(u, Nt, nPass);

        M = nan(Ng, nPass); % NaN padding, no zeros

        baseDelay = cumDelaySamps(k);

        for pass = 1:nPass
            passBase = (pass-1)*passShiftSamps;
            offset   = passBase + baseDelay; % <-- your rule
            M = place_overwrite_nan(M, U(:,pass), offset, pass);
        end

        outPub.nodes(k).path        = char(outPaths(k));
        outPub.nodes(k).cumDelay_s  = cumDelaySecs(k);
        outPub.nodes(k).signalField = char(sigField);
        outPub.nodes(k).upAbsByPass = M;
    end
end

%% ========================================================================
%% Helpers

function [paths, nodes] = flatten_outTree_nodes(s)
    paths = strings(0,1);
    nodes = {};

    function walk(x, prefix)
        if ~isstruct(x), return; end

        hasT = isfield(x,'t');
        hasAny = isfield(x,'up') || isfield(x,'upRaw') || isfield(x,'upNet');

        if hasT && hasAny
            paths(end+1,1) = prefix; %#ok<AGROW>
            nodes{end+1,1} = x;      %#ok<AGROW>
        end

        fn = fieldnames(x);
        reservedLower = lower(string({'Text','UserData','NodeData','t','Vp','Vpe','Vpi','up','upRaw','upNet'}));
        for k = 1:numel(fn)
            nm = fn{k};
            if any(lower(string(nm)) == reservedLower), continue; end
            v = x.(nm);
            if isstruct(v)
                if prefix == ""
                    walk(v, string(nm));
                else
                    walk(v, prefix + "." + nm);
                end
            end
        end
    end

    walk(s,"");
end

function [sigField, Nt, nPass] = infer_signal_layout(outNodes, sigPref)
    % pick first node that has a usable signal
    sigField = "";
    Nt = [];
    nPass = [];

    prefOrder = ["up","upnet","upraw"]; % priority for 'auto'
    for ii = 1:numel(outNodes)
        nd = outNodes{ii};
        if ~isfield(nd,'t'), continue; end

        candidates = strings(0);
        if isfield_ci(nd,"up"),    candidates(end+1) = "up";    end %#ok<AGROW>
        if isfield_ci(nd,"upnet"), candidates(end+1) = "upnet"; end %#ok<AGROW>
        if isfield_ci(nd,"upraw"), candidates(end+1) = "upraw"; end %#ok<AGROW>
        if isempty(candidates), continue; end

        if sigPref ~= "auto"
            if any(candidates == sigPref)
                sigField = resolve_field_ci(nd, sigPref);
            end
        else
            for k = 1:numel(prefOrder)
                if any(candidates == prefOrder(k))
                    sigField = resolve_field_ci(nd, prefOrder(k));
                    break;
                end
            end
        end

        if sigField ~= ""
            t = nd.t(:);
            u = nd.(sigField);
            Nt = numel(t);
            if ismatrix(u) && size(u,1) == Nt
                nPass = size(u,2);
            elseif isvector(u) && numel(u) == Nt
                nPass = 1;
            else
                % fallback
                nPass = 1;
            end
            return;
        end
    end

    error('zef_publish_jr_tree_delays:NoSignal', ...
          'No node had requested signal field. Try Signal="auto".');
end

function tf = isfield_ci(s, nameLower)
    fn = fieldnames(s);
    tf = any(lower(string(fn)) == lower(string(nameLower)));
end

function fieldName = resolve_field_ci(s, nameLower)
    fn = fieldnames(s);
    hit = find(lower(string(fn)) == lower(string(nameLower)), 1, 'first');
    fieldName = string(fn{hit});
end

function U = normalize_to_matrix(u, Nt, nPass)
    if ismatrix(u) && size(u,1) == Nt
        if size(u,2) == nPass
            U = u;
        elseif size(u,2) == 1 && nPass > 1
            U = repmat(u, 1, nPass);
        else
            U = u(:,1:min(size(u,2),nPass));
            if size(U,2) < nPass
                U(:,end+1:nPass) = nan(Nt, nPass-size(U,2));
            end
        end
    elseif isvector(u) && numel(u) == Nt
        U = repmat(u(:), 1, nPass);
    else
        U = nan(Nt, nPass);
    end
end

function M = place_overwrite_nan(M, x, offsetSamps, col)
    % offsetSamps is 0-based
    Nt = numel(x);
    i0 = offsetSamps + 1;
    i1 = i0 + Nt - 1;

    if i1 < 1 || i0 > size(M,1), return; end

    j0 = 1;
    if i0 < 1
        j0 = 2 - i0;
        i0 = 1;
    end
    if i1 > size(M,1)
        NtKeep = size(M,1) - i0 + 1;
    else
        NtKeep = i1 - i0 + 1;
    end

    M(i0:i0+NtKeep-1, col) = x(j0:j0+NtKeep-1);
end

%% ========================================================================
%% Delay flattening from sourceTree (uses NodeData only)

function flat = flatten_sourceTree_for_delays(treeStruct, fs)
    flat.path = {};
    flat.parent = [];
    flat.children = {};
    flat.delaySelfSamps = [];
    flat.cumDelaySamps  = [];
    flat.rootIdx = [];
    flat.rootDelaySamps = [];

    idx = 0;
    reserved = {'Text','UserData','NodeData','t','Vp','Vpe','Vpi','up','upRaw','upNet'};

    function tf = is_node_struct(x)
        tf = isstruct(x) && isfield(x,'NodeData');
    end

    function add_node(nodeStruct, parentIdx, path, isRoot)
        idx = idx + 1;
        thisIdx = idx;

        flat.path{thisIdx,1} = path;
        flat.parent(thisIdx,1) = parentIdx;
        flat.children{thisIdx,1} = [];

        nd = nodeStruct.NodeData;
        dSelf = get_delay_samps(nd, fs);
        flat.delaySelfSamps(thisIdx,1) = dSelf;

        if parentIdx == 0
            flat.cumDelaySamps(thisIdx,1) = dSelf;
            flat.rootIdx(end+1,1) = thisIdx; %#ok<AGROW>
            flat.rootDelaySamps(end+1,1) = dSelf; %#ok<AGROW>
        else
            flat.children{parentIdx}(end+1) = thisIdx; %#ok<AGROW>
            flat.cumDelaySamps(thisIdx,1) = flat.cumDelaySamps(parentIdx) + dSelf;
        end

        fn = fieldnames(nodeStruct);
        for k = 1:numel(fn)
            nm = fn{k};
            if any(strcmp(nm, reserved)), continue; end
            v = nodeStruct.(nm);
            if is_node_struct(v)
                add_node(v, thisIdx, [path '.' nm], false);
            end
        end
    end

    roots = fieldnames(treeStruct);
    for r = 1:numel(roots)
        rname = roots{r};
        v = treeStruct.(rname);
        if is_node_struct(v)
            add_node(v, 0, rname, true);
        end
    end

    flat.N = idx;
end

function dSamps = get_delay_samps(nd, fs)
    dsec = nvget_nested(nd, {'Delay','Delay_s'}, []);
    if isempty(dsec), dsec = nvget_nested(nd, {'Delay_s'}, []); end
    if isempty(dsec), dsec = nvget_nested(nd, {'Delay'}, []); end
    if isempty(dsec), dsec = 0.0; end
    dSamps = max(0, round(double(dsec) * fs));
end

function v = nvget(s, field, default)
    if isfield(s, field) && isstruct(s.(field)) && isfield(s.(field),'Value')
        v = s.(field).Value;
    else
        v = default;
    end
end

function v = nvget_nested(nd, pathCells, default)
    v = default;
    if isempty(nd) || ~isstruct(nd), return; end
    cur = nd;
    for k = 1:numel(pathCells)
        p = pathCells{k};
        if isfield(cur, p), cur = cur.(p); else, return; end
    end
    if isstruct(cur) && isfield(cur,'Value'), v = cur.Value; else, v = cur; end
end
