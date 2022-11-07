function zef_dataBank_add_data_item(zef,data_type,parent_node_name,node_name)

eval('zef_dataBank_refreshTree;');
h_tree = eval('zef.dataBank.app.Tree');
hash_list = eval('zef.dataBank.hashList');
h_tree.SelectedNodes = zef_dataBank_treeSearch(h_tree, parent_node_name);

if ischar(data_type)
if eval(['ismember(''' data_type ''',zef.dataBank.app.Entrytype.Items);'])
eval(['zef.dataBank.app.Entrytype.Value = ''' data_type ''';']);    
eval('zef_dataBank_addButtonPress;');
end
elseif isfloat(data_type)
eval(['zef.dataBank.app.Entrytype.Value = zef.dataBank.app.Entrytype.Items{' num2str(data_type) '};']);    
eval('zef_dataBank_addButtonPress;');
end

eval('zef_dataBank_refreshTree;');
hash_list_new = eval('zef.dataBank.hashList');

new_hash = setdiff(hash_list_new, hash_list);
eval(['zef.dataBank.tree.(''' new_hash{1} ''').name = ''' node_name ''';']);
eval('zef_dataBank_refreshTree;');

end