function zef_data = zef_get_fields(fieldnames_aux, zef)
%zef_get_data gets the fields of struct zef and returns them 
%as the fields of struct zef_data.
%Input: struct zef, cell fieldnames_aux (field names as 1xN cell)
%Output: struct zef.

if nargin == 1
    zef = evalin('base','zef');
end

zef_data = struct; 
for zef_i = 1 : length(fieldnames_aux)
zef_data.(fieldnames_aux{zef_i}) = zef_data.(fieldnames_aux{zef_i});
end

end