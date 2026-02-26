function treeStruct = zef_cbtreenode_delete_node(nodeObj)
%ZEF_CBTREENODE_DELETE_NODE Delete a UITree node and all its children.
%
%   treeStruct = zef_cbtreenode_delete_node(nodeObj)
%
% nodeObj must be a matlab.ui.container.TreeNode (a selected node).
% The function deletes the node (which deletes the entire subtree) and
% rebuilds the source tree struct from the owning Tree.

    if nargin ~= 1
        error('zef_cbtreenode_delete_node:InvalidInput', ...
              'Provide (TreeNode).');
    end
    if ~isa(nodeObj, 'matlab.ui.container.TreeNode')
        error('zef_cbtreenode_delete_node:InvalidInput', ...
              'nodeObj must be a matlab.ui.container.TreeNode.');
    end

    % Find owning Tree (root UI tree object)
    treeObj = local_getOwningTree(nodeObj);
    if isempty(treeObj) || ~isvalid(treeObj)
        error('zef_cbtreenode_delete_node:InvalidState', ...
              'Could not determine the owning Tree object.');
    end

    % Delete selected node -> also deletes its children (subtree)
    if ~isvalid(nodeObj)
        % Nothing to delete; still rebuild struct for safety
        treeStruct = zef_build_source_tree(treeObj);
        return;
    end

    delete(nodeObj);

    % Rebuild your treeStruct after UI change
    treeStruct = zef_build_source_tree(treeObj);
end

function treeObj = local_getOwningTree(nodeOrTree)
%LOCAL_GETOWNINGTREE Climb Parents until we hit the Tree.

    treeObj = [];
    cur = nodeOrTree;

    % Parents alternate TreeNode -> TreeNode -> ... -> Tree
    while ~isempty(cur) && isvalid(cur)
        if isa(cur, 'matlab.ui.container.Tree')
            treeObj = cur;
            return;
        end

        if ~hasPropOrField(cur, 'Parent')
            return;
        end

        cur = cur.Parent;  % TreeNode.Parent is either TreeNode or Tree
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
