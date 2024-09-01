function [run_type] = zef_bst_get_run_type(h_parent)

if nargin < 1
h_parent = get(gcbo,'Parent');
end

h_object = findobj(h_parent.Children,'Tag','run_type');
run_type = h_object.Value;

end