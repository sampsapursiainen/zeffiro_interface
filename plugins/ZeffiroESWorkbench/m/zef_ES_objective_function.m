function [sr, sc] = zef_ES_objective_function(zef)
 
if nargin == 0
zef = evalin('base','zef');
end

[vec, ~, metacriteria_list, metacriteria_type] = zef_ES_table(zef);
obj1 = eval('zef.ES_obj_fun');
obj2 = eval('zef.ES_obj_fun_2');
thre_aux = eval('zef.ES_acceptable_threshold');
thre_type = eval('zef.ES_threshold_condition');

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