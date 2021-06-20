function [star_row_idx, star_col_idx] = zef_ES_objective_function
vec = zef_ES_error_criteria;
vec = [vec(1,2) vec(1,5:end)];
objfun = cell2mat(vec{1,evalin('base','zef.ES_objfun')});

C = cell2mat(vec{1,3});
if evalin('base','zef.ES_solvermaximumcurrent_checkbox') == 0
    C_idx = find(C <= evalin('base','zef.ES_solvermaximumcurrent_checkbox'));
else
    C_idx = (1:length(C(:)))';
end
D = cell2mat(vec{1,4});
if evalin('base','zef.ES_scoredose_checkbox') == 0
    D_idx = find(D <= evalin('base','zef.ES_scoredose'));
else
    D_idx = (1:length(D(:)))';
end

Accept_idx = intersect(C_idx,D_idx);
[~,star_idx] = min(objfun(Accept_idx));
star_idx = Accept_idx(star_idx);
Accept_idx = intersect(star_idx,D_idx);
[star_row_idx, star_col_idx] = ind2sub(size(D), Accept_idx);
end