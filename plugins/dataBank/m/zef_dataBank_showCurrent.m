function [info,columnNames] = zef_dataBank_showCurrent(zef, type)

tree.node.data=zef_dataBank_getData(zef, type);
tree.node.type=type;
[info, columnNames]=zef_databank_showAll(tree, type);

end

