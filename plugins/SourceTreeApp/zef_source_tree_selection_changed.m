function zef_source_tree_selection_changed(~, ~, ~)

zef = evalin('base','zef');

    sel = zef.h_source_tree.SourceTree.SelectedNodes;
    if isempty(sel)
        zef.h_source_tree.SourceParameters.Data = {};
        return;
    end

    nd = sel(1).NodeData;

    if isempty(nd) || (isstruct(nd) && isempty(fieldnames(nd)))
        zef.h_source_tree.SourceParameters.Data = {};
        return;
    end

    rows = nodedata_to_2col_rows(nd);   % {KeyPath, Value} only
    zef.h_source_tree.SourceParameters.Data = rows;

    % store dropdown options for later editing
    zef.h_source_tree.SourceParameters.UserData = default_options_map();

end


function rows = nodedata_to_2col_rows(nd)
%NODEDATA_TO_2COL_ROWS Convert NodeData into {KeyPath, Value} rows.
% Column 1 contains ONLY struct field names (no val.Name text).

    rows = {};
    walk(nd, '');

    function walk(s, prefix)
        if ~isstruct(s), return; end

        f = fieldnames(s);
        for k = 1:numel(f)
            key = f{k};
            val = s.(key);

            if isNV(val)
                fullKey = joinKey(prefix, key); % <-- only variable path
                rows(end+1,:) = {char(fullKey), toTableScalar(val.Value)}; %#ok<AGROW>
            elseif isstruct(val)
                walk(val, joinKey(prefix, key));
            end
        end
    end
end

function tf = isNV(x)
    tf = isstruct(x) && isfield(x,'Name') && isfield(x,'Value');
end

function s = joinKey(prefix, key)
    if isempty(prefix)
        s = char(string(key));
    else
        s = [char(string(prefix)) '.' char(string(key))];
    end
end

function out = toTableScalar(v)
    if isempty(v)
        out = '';
        return;
    end

    if ischar(v)
        out = v;
        return;
    end

    if isstring(v)
        if isscalar(v)
            out = char(v);
        else
            out = char(strjoin(v, ", "));
        end
        return;
    end

    if isnumeric(v) || islogical(v)
        if isscalar(v)
            out = v;
        else
            out = mat2str(v);
        end
        return;
    end

    if iscell(v)
        try
            out = char(string(v{1}));
        catch
            out = '<cell>';
        end
        return;
    end

    if isstruct(v)
        out = '<struct>';
        return;
    end

    try
        out = char(string(v));
    catch
        out = class(v);
    end
end


function optmap = default_options_map()
%DEFAULT_OPTIONS_MAP Dropdown suggestions keyed by KeyPath strings
% (these must match the keys produced in column 1)

    optmap = containers.Map('KeyType','char','ValueType','any');

    % --- NodeData-side dropdowns (only put things that actually live in NodeData) ---
    % Connectivity
    optmap('Connectivity.ToChildren')  = {false,true};
    optmap('Connectivity.ToRoots')     = {false,true};

    % RootTargets is free-form (comma/semicolon separated), so no dropdown here.

    % (Optional) If you later add per-node input routing into NodeData, put it here:
    % optmap('inputSource_type') = {'external','node'};
    % optmap('inputSource_targetPopulation') = {'p','e','i'};
    % optmap('nodeSource_signal') = {'Vp','Vpe','Vpi','upRaw','upNet'};
end
