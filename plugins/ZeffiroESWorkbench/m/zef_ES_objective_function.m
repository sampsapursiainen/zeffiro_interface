function [sr, sc] = zef_ES_objective_function(varargin)
 
[~, ~, metacriteria_list, metacriteria_type] = zef_ES_table([]);

obj1 = [];
obj2 = [];
thre_aux = [];
thre_type = [];
vec = [];

if not(isempty(varargin))
    vec = varargin{1};
        if length(varargin) > 1
        obj1 = varargin{2};
        end
    if length(varargin) > 2
        obj2 = varargin{3};
    end
    if length(varargin) > 3
        thre_aux = varargin{4};
    end
     if length(varargin) > 4
        thre_type = varargin{5};
    end
end

if isempty(obj1)
    vec = zef_ES_table;
end

if isempty(obj1)
    obj1 = evalin('base','zef.ES_obj_fun');
end

if isempty(obj2)
    obj2 = evalin('base','zef.ES_obj_fun_2');
end

if isempty(thre_aux)
thre_aux = evalin('base','zef.ES_acceptable_threshold');
end

if isempty(thre_type)
thre_type = evalin('base','zef.ES_threshold_condition');
end

obj_fun_1 = vec.(metacriteria_list{obj1}){1};
obj_fun_2 = vec.(metacriteria_list{obj2}){1};

if isequal(obj1,obj2)
    
if   isequal(metacriteria_type{obj1}, 'minimum')
[~, Idx] = min(abs(obj_fun_1(:)));
elseif isequal(metacriteria_type{obj1}, 'maximum')
 [~, Idx] = max(abs(obj_fun_1(:)));
end

[sr, sc] = ind2sub(size(obj_fun_1),Idx);

else
    
if isequal(thre_type,1)
  thre_aux = thre_aux*max((obj_fun_1(:)));
end

if   isequal(metacriteria_type{obj1}, 'minimum')
    [Idx] = find(abs(obj_fun_1(:)) <= thre_aux);
if isempty(Idx)
[~,Idx] = min(abs(obj_fun_1(:)));
end
elseif isequal(metacriteria_type{obj1}, 'maximum')
     [Idx] = find(abs(obj_fun_1(:)) >= thre_aux);
if isempty(Idx)
[~,Idx] = max(abs(obj_fun_1(:)));
end
end

if   isequal(metacriteria_type{obj2}, 'minimum')
    [~, Idx_2] = min(abs(obj_fun_2(Idx)));
elseif isequal(metacriteria_type{obj2}, 'maximum')
    [~, Idx_2] = max(abs(obj_fun_2(Idx)));
end

[sr, sc] = ind2sub(size(obj_fun_2),Idx(Idx_2));

end