function tree = zef_build_source_tree(parentObj)
%ZEF_BUILD_SOURCE_TREE Build a struct "tree" from a UI tree / checkbox tree.
%   Works with both checkboxtree (CheckedNodes exists) and plain tree
%   (no CheckedNodes). In the plain tree case, "IsChecked" is inferred from
%   SelectedNodes (if available) or node.Checked (if available), otherwise false.

    if nargin ~= 1
        error('zef_build_source_tree:InvalidInput', 'Provide exactly one input: parentObj.');
    end
    if ~hasPropOrField(parentObj,'Children')
        error('zef_build_source_tree:NoChildren', ...
              'Input parentObj does not have a Children property/field.');
    end

    annotateCheckedNodesIntoUserData(parentObj);

    tree = struct();
    roots = getPropOrField(parentObj,'Children');
    roots = roots(:);

    used = struct();
    for k = 1:numel(roots)
        base = makeNodeName(getMaybe(roots(k),'Text'), k);
        name = makeUniqueSiblingName(base, used);
        used.(name) = true;
        tree.(name) = buildNode(roots(k));
    end
end

function annotateCheckedNodesIntoUserData(parentObj)
% Annotate each node's UserData with fields:
%   - IsChecked (logical)
%   - CheckedIndex (index within checked list; 0 if not checked)
% and preserve prior UserData in a non-destructive way.

    % --- Priority 1: checkboxtree style ---
    checked = [];
    checkedMode = "";

    if hasPropOrField(parentObj,'CheckedNodes')
        checked = getPropOrField(parentObj,'CheckedNodes');
        checkedMode = "CheckedNodes";
    end

    % --- Priority 2: plain tree fallback: SelectedNodes as "checked" ---
    if isempty(checked) && hasPropOrField(parentObj,'SelectedNodes')
        checked = getPropOrField(parentObj,'SelectedNodes');
        checkedMode = "SelectedNodes";
    end

    % Normalize list to column vector of handles (if any)
    if isempty(checked)
        checked = [];
    else
        checked = checked(:);
    end

    roots = getPropOrField(parentObj,'Children');
    roots = roots(:);

    for k = 1:numel(roots)
        walkAndAnnotate(roots(k), checked, checkedMode);
    end
end

function walkAndAnnotate(obj, checked, checkedMode)
    % Determine checked-ness robustly
    [isChecked, idx] = inferIsChecked(obj, checked, checkedMode);

    % Preserve/merge existing UserData without destroying it
    oldUD = getMaybe(obj,'UserData');

    if isstruct(oldUD)
        ud = oldUD;
        % Only store OriginalUserData if it doesn't exist already
        if ~isfield(ud,'OriginalUserData')
            ud.OriginalUserData = oldUD;
        end
    else
        ud = struct();
        ud.OriginalUserData = oldUD;
    end

    ud.IsChecked = logical(isChecked);
    if isChecked
        ud.CheckedIndex = idx;
    else
        ud.CheckedIndex = 0;
    end

    setMaybe(obj,'UserData', ud);

    % Recurse
    if hasPropOrField(obj,'Children')
        ch = getPropOrField(obj,'Children');
        ch = ch(:);
        for i = 1:numel(ch)
            walkAndAnnotate(ch(i), checked, checkedMode);
        end
    end
end

function [isChecked, idx] = inferIsChecked(obj, checked, checkedMode)
% Robustly infer "checked" state.
% checkedMode:
%   "CheckedNodes" / "SelectedNodes" -> membership test in 'checked'
%   otherwise -> try per-node logical property 'Checked' if it exists.

    isChecked = false;
    idx = 0;

    if ~isempty(checked) && (checkedMode == "CheckedNodes" || checkedMode == "SelectedNodes")
        % Membership test that won't error on handle comparisons
        try
            tf = (checked == obj); % works for handle arrays in many cases
            idx = find(tf, 1, 'first');
        catch
            % Fallback: isequal-based membership
            idx = 0;
            for k = 1:numel(checked)
                if isequal(checked(k), obj)
                    idx = k;
                    break;
                end
            end
        end
        isChecked = (idx ~= 0);
        return;
    end

    % Fallback: if node itself exposes a boolean "Checked" property
    if hasPropOrField(obj,'Checked')
        try
            isChecked = logical(getPropOrField(obj,'Checked'));
            if isChecked, idx = 1; end
        catch
            isChecked = false;
            idx = 0;
        end
    end
end

function node = buildNode(obj)
    node = struct();
    node.Text = getMaybe(obj,'Text');
    node.UserData = getMaybe(obj,'UserData');
    node.NodeData = getMaybe(obj,'NodeData');

    if ~hasPropOrField(obj,'Children')
        return;
    end

    ch = getPropOrField(obj,'Children');
    ch = ch(:);

    used = struct();
    for k = 1:numel(ch)
        base = makeNodeName(getMaybe(ch(k),'Text'), k);
        name = makeUniqueSiblingName(base, used);
        used.(name) = true;
        node.(name) = buildNode(ch(k));
    end
end

function name = makeNodeName(txt, idx)
    if isstring(txt) && isscalar(txt), txt = char(txt); end
    if iscell(txt) && numel(txt)==1, txt = txt{1}; end
    if isempty(txt)
        name = sprintf('branch_node_%d', idx);
        return;
    end
    s = char(string(txt));
    name = matlab.lang.makeValidName(s, 'ReplacementStyle','delete');
    if isempty(name)
        name = sprintf('branch_node_%d', idx);
    end
end

function name = makeUniqueSiblingName(base, used)
    name = base;
    if ~isfield(used, name)
        return;
    end
    t = 2;
    while true
        cand = sprintf('%s_%d', base, t);
        if ~isfield(used, cand)
            name = cand;
            return;
        end
        t = t + 1;
    end
end

function val = getMaybe(obj, prop)
    if hasPropOrField(obj, prop)
        val = getPropOrField(obj, prop);
    else
        val = [];
    end
end

function setMaybe(obj, prop, val)
    if ~hasPropOrField(obj, prop)
        return;
    end
    try
        obj.(prop) = val;
    catch
        try
            set(obj, prop, val);
        catch
        end
    end
end

function tf = hasPropOrField(obj, name)
    tf = false;
    try
        if isstruct(obj)
            tf = isfield(obj, name);
        else
            tf = isprop(obj, name);
        end
    catch
        tf = false;
    end
end

function val = getPropOrField(obj, name)
    if isstruct(obj)
        val = obj.(name);
    else
        try
            val = obj.(name);
        catch
            val = get(obj, name);
        end
    end
end
