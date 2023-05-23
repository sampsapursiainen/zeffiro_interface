function [h_node_output, node_found] = zef_dataBank_treeSearch(h_node_input, node_name)

node_found = 0;
h_node_output = [];
i = 0;
while i < length(h_node_input.Children) && not(node_found)
    i = i + 1;
    if isequal(h_node_input.Children(i).Text, node_name)
        node_found = 1;
        h_node_output = h_node_input.Children(i);
    else
        [h_node_output, node_found] = zef_dataBank_treeSearch(h_node_input.Children(i),node_name);
    end
end
end
