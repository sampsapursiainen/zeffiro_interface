function zef = zef_remove_object_handles(zef, node_name, h_list)

skip_class_list = {'matlab.io.MatFile'};

if nargin < 2 
   node_name = 'zef'; 
end

if isempty(node_name)
    node_name = 'zef';
end

if nargin < 3
    h_list = [];
end

fields = fieldnames(eval(node_name));
for i = 1 : length(fields)
    aux_string = [node_name '.' fields{i}];
aux_field = eval(aux_string);
if not(ismember(class(aux_field),skip_class_list))
try
isvalid(aux_field);
handle_test = true; 
catch
handle_test = false;
end
if isobject(aux_field) &  handle_test  
if isempty(h_list) | ismember(aux_field,h_list) 
aux_struct = rmfield(eval(node_name),fields{i});
eval([node_name  ' = aux_struct;']);
end
elseif isstruct(eval(aux_string)) 
zef = zef_remove_object_handles(zef, aux_string);
end 
end
end
end