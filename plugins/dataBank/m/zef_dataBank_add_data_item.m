function zef_dataBank_add_data_item(data_type,parent_node_name,node_name)

evalin('base','zef_dataBank_refreshTree;');
h_tree = evalin('base','zef.dataBank.app.Tree');
hash_list = evalin('base','zef.dataBank.hashList');
h_tree.SelectedNodes = zef_dataBank_treeSearch(h_tree, parent_node_name);

if ischar(data_type)
if evalin('base',['ismember(''' data_type ''',zef.dataBank.app.Entrytype.Items);'])
evalin('base',['zef.dataBank.app.Entrytype.Value = ''' data_type ''';']);    
evalin('base','zef_dataBank_addButtonPress;');
end
elseif isfloat(data_type)
evalin('base',['zef.dataBank.app.Entrytype.Value = zef.dataBank.app.Entrytype.Items{' num2str(data_type) '};']);    
evalin('base','zef_dataBank_addButtonPress;');
end

evalin('base','zef_dataBank_refreshTree;');
hash_list_new = evalin('base','zef.dataBank.hashList');

new_hash = setdiff(hash_list_new, hash_list);
evalin('base',['zef.dataBank.tree.(''' new_hash{1} ''').name = ''' node_name ''';']);
evalin('base','zef_dataBank_refreshTree;');

end