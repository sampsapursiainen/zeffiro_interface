function [vec, sr, sc] = zef_ES_objective_function
load_aux = evalin('base','zef.y_ES_interval');

A = zeros(size(load_aux.y_ES));
B = cell2mat(load_aux.residual);
if evalin('base','zef.ES_search_method') ~= 3
    B = round(B/max(abs(B(:))),6);
end
C = zeros(size(load_aux.y_ES));
D = zeros(size(load_aux.y_ES));

E = cell2mat(load_aux.field_source.magnitude')';
F = cell2mat(load_aux.field_source.angle')';
G = cell2mat(load_aux.field_source.relative_norm_error')';
H = cell2mat(load_aux.field_source.relative_error')';

I1 = cell2mat(load_aux.field_source.avg_off_field')';
I2 = evalin('base','zef.ES_active_electrodes');

J = evalin('base','zef.ES_separation_angle');
K = evalin('base','zef.h_ES_search_method.Items{zef.ES_search_method}');
L = evalin('base','zef.ES_maximum_current');

M = evalin('base','zef.ES_relativeweightnnz');
N = evalin('base','zef.ES_cortex_thickness');
O = evalin('base','zef.ES_solvermaximumcurrent');
P = evalin('base','zef.ES_source_density');
Q = evalin('base','zef.ES_relative_source_amplitude');

if evalin('base','zef.ES_search_method') == 3
    M = 100;
    I2 = zef_ES_4x1_sensors;
else
    if isempty(I2)
        I2 = size(load_aux.y_ES{1,1},1);
    end
    J = NaN;
end
for i = 1:size(load_aux.y_ES,1)
    for j = 1:size(load_aux.y_ES,2)
        A(i,j) =         norm(cell2mat(load_aux.y_ES(i,j)),1);  % L1
        C(i,j) =          max(cell2mat(load_aux.y_ES(i,j)));    % Max
        %  D(i,j) = zef_ES_rwnnz(cell2mat(load_aux.y_ES(i,j)), M); % NNZ Currents
        D(i,j) = length(find(cell2mat(load_aux.y_ES(i,j))));
    end
end

vec = array2table({A,B,C,D,E,F,G,H,I1,I2,J,K,L,M,N,O,P,Q}, 'VariableNames', ...
    {'Total Dose', 'Residual', 'Max Y', 'NNZ Currents', ... %A B C D
    'Current Density','Angle Error','Magnitude Error', 'Relative Error', 'Avg. Off-field'... %E F G H, I1
    'Active Electrodes','Separation Angle','Search Method','Maximum Current (A)', ... %I2 J K L
    'Relative Weight NNZ','Cortex Thickness','Solver Maximum Current (mA)', ...  %N O P
    'Source Density (A/m2)','Relative Source Amplitude'}); %Q R

%% Obj Fun
%% August version
%C_idx = find(C <= evalin('base','zef.ES_solvermaximumcurrent'));
%D_idx = (1:length(D(:)))';
vec_aux = vec(1,[2,5,6,8]);

switch evalin('base','zef.ES_objfun')
    case {1,3,4}
        obj_funct   = cell2mat(vec_aux{1,evalin('base','zef.ES_objfun')});
        if evalin('base','zef.ES_acceptable_threshold') <= 100
            obj_funct_threshold = obj_funct;
            %[Idx] = find(abs(obj_funct_threshold(:)) <= 100/evalin('base','zef.ES_acceptable_threshold').*min(abs(obj_funct_threshold(:))))
            [Idx] = find(abs(obj_funct_threshold(:)) <= min( obj_funct_threshold(:) )+(max(obj_funct_threshold(:))-min(obj_funct_threshold(:))).* (1-evalin('base','zef.ES_acceptable_threshold')/100));
        end
    case 2
        obj_funct   = cell2mat(vec_aux{1,evalin('base','zef.ES_objfun')});
        if evalin('base','zef.ES_acceptable_threshold') <= 100
            obj_funct_threshold = obj_funct;
            %[Idx] = find(abs(obj_funct_threshold(:)) >= max(abs(obj_funct_threshold(:)))./(100/evalin('base','zef.ES_acceptable_threshold')))
            [Idx] = find(obj_funct_threshold(:) >= max(obj_funct_threshold(:))-(max(obj_funct_threshold(:))-min(obj_funct_threshold(:)) ).* (1-evalin('base','zef.ES_acceptable_threshold')/100));
        end
end

switch evalin('base','zef.ES_objfun_2')
    case {1,3,4}
        obj_funct_2   = cell2mat(vec_aux{1,evalin('base','zef.ES_objfun_2')});
        [~,Idx_2] = min(obj_funct_2(Idx));
    case 2
        obj_funct_2   = cell2mat(vec_aux{1,evalin('base','zef.ES_objfun_2')});
        [~,Idx_2] = max(obj_funct_2(Idx));
end

[sr, sc] = ind2sub(size(obj_funct_2),Idx(Idx_2));
%[sr, sc] = find(obj_funct);

% Accept_idx = intersect(C_idx,D_idx);
% [~,star_idx] = min(objfun(Accept_idx));
% star_idx = Accept_idx(star_idx);
% Accept_idx = intersect(star_idx,D_idx);
% [sr, sc] = ind2sub(size(D), Accept_idx);
%% July version
% if evalin('base','zef.ES_solvermaximumcurrent_checkbox') == 0
%     C_idx = find(C <= evalin('base','zef.ES_solvermaximumcurrent'));
% else
%     C_idx = (1:length(C(:)))';
% end
%
% if evalin('base','zef.ES_scoredose_checkbox') == 0
%     D_idx = find(D <= evalin('base','zef.ES_scoredose'));
%     %D_idx = find(D == evalin('base','zef.ES_scoredose'));
% else
%     D_idx = (1:length(D(:)))';
% end
%
% vec_aux = vec(1,[2,5,6,8]);
% objfun = cell2mat(vec_aux{1,evalin('base','zef.ES_objfun')});
%
% Accept_idx = intersect(C_idx,D_idx);
% [~,star_idx] = min(objfun(Accept_idx));
% star_idx = Accept_idx(star_idx);
% Accept_idx = intersect(star_idx,D_idx);
% [sr, sc] = ind2sub(size(D), Accept_idx);
end
