function zef_rebuild_source_tree(treeObj, treeStruct)
%ZEF_REBUILD_CHECKBOXTREE Rebuild a uitree / checkboxtree from a struct.
%   If treeObj supports CheckedNodes (checkboxtree), restores CheckedNodes
%   from UserData.CheckedIndex/IsChecked.
%   Otherwise, if treeObj supports SelectedNodes (plain uitree), restores
%   SelectedNodes using the same saved indices as a best-effort analogue.

    if nargin ~= 2
        error('zef_rebuild_CheckBoxTree:InvalidInput', ...
              'Provide (treeObj, struct).');
    end
    if ~isstruct(treeStruct)
        error('zef_rebuild_CheckBoxTree:InvalidInput', ...
              'Second argument must be a struct.');
    end
    if ~hasPropOrField(treeObj,'Children')
        error('zef_rebuild_CheckBoxTree:InvalidInput', ...
              'First argument must be a tree object with Children.');
    end

    supportsChecked  = hasPropOrField(treeObj,'CheckedNodes');
    supportsSelected = hasPropOrField(treeObj,'SelectedNodes');

    % Clear existing nodes
    try
        delete(treeObj.Children);
    catch
        ch = getPropOrField(treeObj,'Children');
        if ~isempty(ch), delete(ch); end
    end

    % Empty input => clear checked/selected state (if supported) and exit
    if isempty(fieldnames(treeStruct))
        if supportsChecked
            treeObj.CheckedNodes = [];
        end
        if supportsSelected
            treeObj.SelectedNodes = [];
        end
        return;
    end

    % Build UI nodes from struct
    fn = fieldnames(treeStruct);

    % Collect nodes with saved indices so we can restore checked/selected order
    idxList  = [];
    nodeList = {};  % cell array of node handles

    for k = 1:numel(fn)
        rootName = fn{k};
        rootStruct = treeStruct.(rootName);

        % Each top-level field corresponds to a root UI node
        [idxList, nodeList] = buildNode(treeObj, rootStruct, idxList, nodeList, rootName);
    end

    % Restore checked/selected nodes based on stored index ordering
    if ~isempty(idxList)
        [~, ord] = sort(idxList, 'ascend');
        orderedNodes = [nodeList{ord}];
    else
        orderedNodes = [];
    end

    if supportsChecked
        treeObj.CheckedNodes = orderedNodes;
    end

    if supportsSelected
        % Plain tree: "selected" is the closest concept we have
        treeObj.SelectedNodes = orderedNodes;
    end
end

function [idxList, nodeList] = buildNode(parent, nodeStruct, idxList, nodeList, defaultText)
    % Create node
    uiNode = uitreenode(parent);

    % Assign properties
    if nargin >= 5 && ~isempty(defaultText) && ~isfield(nodeStruct,'Text')
        uiNode.Text = defaultText;
    elseif isfield(nodeStruct,'Text')
        uiNode.Text = nodeStruct.Text;
    end

    if isfield(nodeStruct,'UserData')
        uiNode.UserData = nodeStruct.UserData;
    end
    if isfield(nodeStruct,'NodeData')
        uiNode.NodeData = nodeStruct.NodeData;
    end

    % Register checked/selected markers from UserData
    idx = getCheckedIndexFromUserData(uiNode.UserData);
    if idx > 0
        idxList(end+1)  = idx;        %#ok<AGROW>
        nodeList{end+1} = uiNode;     %#ok<AGROW>
    end

    % Recurse for children fields
    fn = fieldnames(nodeStruct);
    reserved = {'Text','UserData','NodeData'};
    for k = 1:numel(fn)
        name = fn{k};
        if any(strcmp(name, reserved))
            continue;
        end

        childStruct = nodeStruct.(name);
        if isstruct(childStruct)
            [idxList, nodeList] = buildNode(uiNode, childStruct, idxList, nodeList, name);
        end
    end
end

function idx = getCheckedIndexFromUserData(ud)
    idx = 0;

    if ~isstruct(ud)
        return;
    end

    % Accept either:
    %   ud.IsChecked + ud.CheckedIndex (your format)
    % or just:
    %   ud.CheckedIndex > 0
    if isfield(ud,'CheckedIndex') && isnumeric(ud.CheckedIndex) && isscalar(ud.CheckedIndex)
        ci = double(ud.CheckedIndex);
    else
        ci = 0;
    end

    if isfield(ud,'IsChecked')
        isC = isequal(ud.IsChecked, true);
    else
        isC = (ci > 0);
    end

    if isC && ci > 0
        idx = ci;
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
