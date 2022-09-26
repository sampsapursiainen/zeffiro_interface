function [p_vec_window,relative_size] = zef_change_size_function(object_handle, current_size, varargin)

    
relative_size = [];
exclude_type = cell(0);
scale_positions = 1;
if not(isempty(varargin))
    if length(varargin) > 0 %#ok<ISMT>
        relative_size = varargin{1};
    end
    if length(varargin) > 1
        exclude_type = varargin{2};
    end
    if length(varargin) > 2
        scale_positions = varargin{3};
    end
end

p_vec_window = get(object_handle(1),'Position');

if and(prod(p_vec_window)>0,prod(current_size)>0)

if and(not(isempty(p_vec_window)),not(isempty(current_size)))

  
h = findall(object_handle,'-property','Position');
h = setdiff(h,object_handle);


    for i = 1 : length(exclude_type)
    h = setdiff(h, findobj(h,'Type',exclude_type{i}));
    h = setdiff(h, findobj(h,'Tag',exclude_type{i}));
    end

    for i = 1 : length(h)

        p_vec_object = [];
        find_pos = findprop(h(i),'Position');
        if not(isempty(find_pos))
        if isequal(find_pos.GetAccess,'public')
        p_vec_object = get(h(i),'Position');
        end
        end
        
        p_vec_parent = [];
        find_parent = findprop(h(i).Parent,'Position');
        if not(isempty(find_parent))
        if isequal(find_parent.GetAccess,'public')
        p_vec_parent = get(h(i).Parent,'Position');
        end
        end
        
        find_fontsize = findprop(h(i),'FontSize');
        if not(isempty(find_fontsize))
        if not(isempty(find_fontsize))
        if isequal(find_fontsize.GetAccess,'public')
         fontsize_object = get(h(i),'FontSize');
                set(h(i),'FontSize',fontsize_object*p_vec_window(4)./current_size(4));
        end
        end
        end

        if length(p_vec_parent)==4
            
            if not(isempty(relative_size))
                if scale_positions
            set(h(i),'Position',relative_size{i}.*p_vec_parent([3 4 3 4]));
                end
            else
            if    length(p_vec_object)==4
            p_vec = [p_vec_object(1).*p_vec_parent(3)./current_size(3) p_vec_object(2).*p_vec_parent(4)./current_size(4) p_vec_object(3).*p_vec_parent(3)./current_size(3) p_vec_object(4).*p_vec_parent(4)./current_size(4)];
            if scale_positions
            h(i).Position = p_vec;
            end
            end
            end
          
        end
    end

end

end
end

