function [] = zef_dataBank_uiTreeDeleteHash(node, hashList)
%deleting nodes in the uitree when the hash is known, but the nodes are not
%selected. Moves through the tree and deletes when the hash(es) is(are)
%found

if isprop(node, 'NodeData')

    for i=1:length(hashList)
        if strcmp(node.NodeData, hashList{i})
            node.delete;
            return;
        end
    end
end

if ~isempty(node.Children)
    for i=length(node.Children):-1:1
        zef_dataBank_uiTreeDeleteHash(node.Children(i), hashList);
    end
end

end

