function [relative_size] = zef_get_relative_size(object_handle)

set(object_handle,'units','pixels')
object_size = get(object_handle,'position');
object_children = get(object_handle,'children');
relative_size = get(object_children,'position');

for i = 1 : length(relative_size)
    if size(relative_size{i},2) == 4
    relative_size{i} = relative_size{i}./object_size([3 4 3 4]);
    end
end