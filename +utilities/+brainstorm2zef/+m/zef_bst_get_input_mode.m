function [input_mode] = zef_bst_get_input_mode(h_parent)

if nargin < 1
h_parent = get(gcbo,'Parent');
end

h_object = findobj(h_parent.Children,'Tag','input_mode');
input_mode = h_object.Value;

end