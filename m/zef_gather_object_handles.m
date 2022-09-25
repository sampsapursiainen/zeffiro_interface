function h_struct = zef_gather_object_handles(zef,window_name)

if nargin == 1
    window_name = 'ZEFFIRO Interface';
end

h_groot = findall(groot,'-regexp','Name',window_name);
h_struct = zef_find_object_handles(zef, h_groot);

fields = fieldnames(h_struct);

for i = 1 : length(fields)
    if ismember('Children',properties(h_struct.(fields{i})))
    h_struct_aux = zef_find_object_handles(zef, cat(1,h_struct.(fields{i}).Children));
    h_struct.(fields{i}) = h_struct_aux; 
    end
end

end