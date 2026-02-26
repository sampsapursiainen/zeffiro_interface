function zef_source_tree_add_child(treeObj, childText)

    if nargin ~= 2
        error('zef_cbtreenode_add_child:InvalidInput', ...
              'Provide (CheckBoxTree, childText).');
    end
    if ~(ischar(childText) || (isstring(childText) && isscalar(childText)))
        error('zef_cbtreenode_add_child:InvalidInput', ...
              'childText must be a char or scalar string.');
    end
    childText = char(string(childText));

        parentNode = treeObj;

    newNode = uitreenode(parentNode);
    newNode.Text = childText;
    if isprop(parentNode,'NodeData')
    newNode.NodeData = parentNode.NodeData;
    else
    newNode.NodeData = zef_init_jr_nodedata();
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
