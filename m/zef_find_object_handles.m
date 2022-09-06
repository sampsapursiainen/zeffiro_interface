function h_output = zef_find_object_handles(zef, h_input, h_output, node_name)

if nargin < 3
    h_output = struct;
end

if nargin < 4
    node_name = 'zef';
end

fields = fieldnames(eval(node_name));
for i = 1 : length(fields)

    aux_field = eval([node_name '.' fields{i}]);
    if isobject(aux_field) & ishandle(aux_field)
        if ismember(aux_field,h_input)
            h_output.(fields{i}) = aux_field;
        end
        
    elseif isstruct(eval([node_name '.' fields{i}])) 
        h_output = zef_find_object_handles(zef, h_input, h_output, [node_name '.' fields{i}]);
    end
      
end
end