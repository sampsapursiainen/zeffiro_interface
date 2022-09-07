function h_output = zef_find_object_handles(zef, h_input, h_output, node_name)

if nargin < 3
    h_output = struct;
end

if nargin < 4
    node_name = 'zef';
end

fields = fieldnames(eval(node_name));
for i = 1 : length(fields)
aux_string = [node_name '.' fields{i}];
    aux_field = eval(aux_string);
    if isobject(aux_field) &  ( ishandle(aux_field) | isempty(whos(aux_string)))
        if ismember(aux_field,h_input)
            h_output.(fields{i}) = aux_field;
        end
        
    elseif isstruct(eval(aux_string)) 
        h_output = zef_find_object_handles(zef, h_input, h_output, aux_string);
    end
      
end
end