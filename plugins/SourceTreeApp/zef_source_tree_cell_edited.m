function zef_source_tree_cell_edited(~, tbl, event, whichTable)

    if nargin < 4 || isempty(whichTable)
        error('Provide whichTable = "SourceParameters" or "SignalParameters".');
    end
    whichTable = lower(char(string(whichTable)));

    % === 0) Always work on the latest zef from base (prevents reverting to defaults) ===
    zef = evalin('base','zef');

    % Ensure table data reflects the new edit
    try
        r = event.Indices(1);
        tbl.Data{r,2} = normalize_table_value(event.NewData);
    catch
    end

    switch whichTable
        case 'sourceparameters'
            node = get_selected_node(zef, tbl);
            if isempty(node)
                warning('No selected node; SourceParameters not updated.');
                return;
            end

            nd = node.NodeData;
            if isempty(nd) || ~isstruct(nd)
                warning('Selected node has empty/non-struct NodeData; cannot update.');
                return;
            end

            [nd2, didAny] = apply_table_rows_to_nvstruct(nd, tbl.Data);
            if ~didAny
                warning('No matching keys found to update in NodeData.');
                return;
            end
            node.NodeData = nd2;

        case 'signalparameters'
            spField = 'source_tree_signal_parameters';
            if ~isfield(zef, spField)
                warning('zef has no %s; cannot update.', spField);
                return;
            end

            sp = zef.(spField);
            if isempty(sp) || ~isstruct(sp)
                warning('Global signal parameters store is empty/non-struct; cannot update.');
                return;
            end

            [sp2, didAny] = apply_table_rows_to_nvstruct(sp, tbl.Data);
            if ~didAny
                warning('No matching keys found to update in global SignalParameters.');
                return;
            end
            zef.(spField) = sp2;
        otherwise
            error('whichTable must be "SourceParameters" or "SignalParameters".');
    end

    % Rebuild struct tree from UI tree (NodeData/UserData -> struct)
    parentObj = zef.h_source_tree.SourceTree;
    zef.source_tree = zef_build_source_tree(parentObj);

    % Push updated zef back
    assignin('base','zef', zef);

end




%% ========================================================================
%% Apply all table rows into an existing NV-struct (base = current struct)
function [sOut, didAny] = apply_table_rows_to_nvstruct(sIn, tableData)
% tableData: cell array {Name, Value} rows
    sOut = sIn;
    didAny = false;

    if isempty(tableData) || size(tableData,2) < 2
        return;
    end

    for r = 1:size(tableData,1)
        key = tableData{r,1};
        val = tableData{r,2};

        key = char(string(key));
        [sOut, didUpdate] = set_nv_value_by_display_name(sOut, key, val);
        didAny = didAny || didUpdate;
    end
end

%% ========================================================================
%% Get selected node robustly
function node = get_selected_node(zef, tbl)
    node = [];

    sel = zef.h_source_tree.SourceTree.SelectedNodes;
    if ~isempty(sel)
        node = sel(1);
        % remember last node
        try
            ud = tbl.UserData;
            if ~isstruct(ud), ud = struct(); end
            ud.LastNode = node;
            tbl.UserData = ud;
        catch
        end
        return;
    end

    % fallback
    if isstruct(tbl.UserData) && isfield(tbl.UserData,'LastNode') && ~isempty(tbl.UserData.LastNode)
        node = tbl.UserData.LastNode;
    end
end

function v = normalize_table_value(x)
    if isstring(x) && isscalar(x)
        v = char(x);
    else
        v = x;
    end
end

%% ========================================================================
%% NV update helper: find NV leaf by displayed name and set its Value
function [s, didUpdate] = set_nv_value_by_display_name(s, targetDisplayName, newVal)
    didUpdate = false;
    s = walk(s, '');

    function out = walk(x, prefix)
        out = x;
        if ~isstruct(x), return; end

        f = fieldnames(x);
        for k = 1:numel(f)
            key = f{k};
            val = x.(key);

            if isNV(val)
                dispName = joinName(prefix, key,'');
                if strcmp(char(string(dispName)), char(string(targetDisplayName)))
                    out.(key).Value = cast_from_table(val.Value, newVal);
                    didUpdate = true;
                    return;
                end
            elseif isstruct(val)
                out.(key) = walk(val, joinName(prefix, key, ''));
                if didUpdate, return; end
            end
        end
    end
end

function tf = isNV(x)
    tf = isstruct(x) && isfield(x,'Name') && isfield(x,'Value');
end

function s = joinName(prefix, key, leafName)
    parts = {};
    if ~isempty(prefix), parts{end+1} = prefix; end %#ok<AGROW>
    if ~isempty(key),    parts{end+1} = key;    end %#ok<AGROW>
    if ~isempty(leafName) && ~strcmp(leafName, key)
        parts{end+1} = char(string(leafName));
    end
    s = strjoin(parts, '.');
end

function v = cast_from_table(oldValue, newData)
% Convert newData to the type of oldValue when reasonable.

    if isempty(oldValue)
        if ischar(newData) 
            v = char(newData);
        else
            v = newData;
        end
        return;
    end

    if isnumeric(oldValue)
        if isnumeric(newData)
            v = newData;
            return;
        end
        s = strtrim(char(string(newData)));
        v = str2num(s);
        return;
    end

    if islogical(oldValue)
        if islogical(newData)
            v = newData;
            return;
        end
        s = lower(strtrim(char(string(newData))));
        if any(strcmp(s, {'1','true','yes','on'}))
            v = true;
        elseif any(strcmp(s, {'0','false','no','off'}))
            v = false;
        else
            v = oldValue;
        end
        return;
    end

    if ischar(oldValue) || isstring(oldValue)
        v = char(string(newData));
        return;
    end

    v = newData;
end
