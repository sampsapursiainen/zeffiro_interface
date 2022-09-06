function zef = zef_remove_object_handles(zef, node_name, h_list)

if nargin < 2 | isempty(node_name)
   node_name = 'zef'; 
end

if nargin < 3
    h_list = [];
end

fields = fieldnames(eval(node_name));
for i = 1 : length(fields)
aux_field = eval([node_name '.' fields{i}]);
if isobject(aux_field) & ishandle(aux_field)
if isempty(h_list) | ismember(aux_field,h_list) 
aux_struct = rmfield(eval(node_name),fields{i});
eval([node_name  ' = aux_struct;']);
elseif isstruct(eval([node_name '.' fields{i}])) 
zef = zef_remove_object_handles(zef, [node_name '.' fields{i}]);
end 
end
end