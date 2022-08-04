function [sr, sc] = zef_ES_objective_function(vec, varargin)
switch nargin
    case 1
        if     evalin('base','zef.ES_obj_fun') == 5
            obj1 = 9;
        elseif evalin('base','zef.ES_obj_fun') == 2
            obj1 = 5;
        end
        thre_aux = evalin('base','zef.ES_acceptable_threshold');
        
        switch evalin('base','zef.ES_obj_fun_2');
            case {1,3,4}
                ES_optimize_condition = 'minimum';
            case {2,5}
                ES_optimize_condition = 'maximum';
        end
        
    case {2,3} %Intensity
        if     strcmpi('residual', varargin{1});        obj1 = 2;
        elseif strcmpi('intensity', varargin{1});       obj1 = 5;
        elseif strcmpi('angle', varargin{1});           obj1 = 6;
        elseif strcmpi('relative error', varargin{1});  obj1 = 8;
        elseif strcmpi('focality', varargin{1});        obj1 = 9;
        end
        
        if nargin == 2; thre_aux = 0.08;
        else;           thre_aux = varargin{2};
        end
        
        switch varargin{1}
            case {'residual','angle', 'relative error'}
                ES_optimize_condition = 'minimum';
            case {'intensity','focality'}
                ES_optimize_condition = 'maximum';
        end
end

obj_fun_thresh = vec.(obj1){1,1};

if     isequal(ES_optimize_condition, 'minimum')
    [Idx] = find(abs(obj_fun_thresh(:)) <= thre_aux);
    obj_fun_2 = vec.(obj1){1,1};
    [~, Idx_2] = min(obj_fun_2(Idx));
elseif isequal(ES_optimize_condition, 'maximum')
    [Idx] = find(abs(obj_fun_thresh(:)) >= thre_aux);
    obj_fun_2 = vec.(obj1){1,1};
    [~, Idx_2] = max(obj_fun_2(Idx));
end

[sr, sc] = ind2sub(size(obj_fun_2),Idx(Idx_2));
end