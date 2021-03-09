function [p_vec_window] = zef_change_size_function(object_handle, current_size)

p_vec_window = get(object_handle, 'Position');
h = get(object_handle, 'Children');

for i = 1 : length(h)
    p_vec_object = get(h(i), 'Position'); 
    fontsize_scaling = isprop(h(i),'FontSize');
    if fontsize_scaling
    fontsize_object = get(h(i), 'FontSize'); 
    end
    if length(p_vec_object)==4; 
 p_vec = [p_vec_object(1).*p_vec_window(3)./current_size(3) p_vec_object(2).*p_vec_window(4)./current_size(4) p_vec_object(3).*p_vec_window(3)./current_size(3) p_vec_object(4).*p_vec_window(4)./current_size(4)];
        set(h(i),'Position',p_vec); 
         if fontsize_scaling
        set(h(i),'FontSize',fontsize_object*p_vec_window(4)./current_size(4)); 
         end
    end; 
end


end