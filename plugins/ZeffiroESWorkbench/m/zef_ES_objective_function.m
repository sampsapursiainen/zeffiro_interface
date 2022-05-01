function [vec, sr, sc] = zef_ES_objective_function
load_aux = evalin('base','zef.y_ES_interval');

ES_y                     = zeros(size(load_aux.y_ES));
ES_residual              = cell2mat(load_aux.residual);
if evalin('base','zef.ES_search_method') ~= 3
    ES_residual = round(ES_residual/max(abs(ES_residual(:))),6);
end
ES_max                   = zeros(size(load_aux.y_ES));
ES_flag                  = cell2mat(load_aux.flag')';

ES_magnitude             = cell2mat(load_aux.field_source.magnitude')';
ES_angle_error           = cell2mat(load_aux.field_source.angle')';
ES_rela_norm             = cell2mat(load_aux.field_source.relative_norm_error')';
ES_rela_error            = cell2mat(load_aux.field_source.relative_error')';

ES_off_field             = cell2mat(load_aux.field_source.avg_off_field')';
ES_active_electrodes     = evalin('base','zef.ES_active_electrodes');

ES_separation_angle      = evalin('base','zef.ES_separation_angle');
ES_search_method         = evalin('base','zef.h_ES_search_method.Items{zef.ES_search_method}');
ES_max_current_channel   = evalin('base','zef.ES_max_current_channel');

ES_relative_weight_nnz   = evalin('base','zef.ES_relative_weight_nnz');
ES_cortex_thickness      = evalin('base','zef.ES_cortex_thickness');
ES_total_max_current     = evalin('base','zef.ES_total_max_current');
ES_source_density        = evalin('base','zef.ES_source_density');
ES_rela_source_amplitude = evalin('base','zef.ES_relative_source_amplitude');

if evalin('base','zef.ES_search_method') == 3
    ES_relative_weight_nnz = 100;
    ES_active_electrodes = zef_ES_4x1_sensors;
else
    if isempty(ES_active_electrodes)
        ES_active_electrodes = size(load_aux.y_ES{1,1},1);
    end
    ES_separation_angle = NaN;
end
for i = 1:size(load_aux.y_ES,1)
    for j = 1:size(load_aux.y_ES,2)
        ES_y(i,j) =         norm(cell2mat(load_aux.y_ES(i,j)),1);  % L1
        ES_max(i,j) =          max(cell2mat(load_aux.y_ES(i,j)));  % Max
        %ES_nnz(i,j) = length(find(cell2mat(load_aux.y_ES(i,j))));
    end
end

vec = array2table({ ES_y,                   ES_residual,            ES_max,                 ES_flag, ...
                    ES_magnitude,           ES_angle_error,         ES_rela_norm,           ES_rela_error, ...
                    ES_off_field,           ES_active_electrodes,   ES_separation_angle,    ES_search_method, ...
                    ES_max_current_channel, ES_relative_weight_nnz, ES_cortex_thickness,    ES_total_max_current, ...
                    ES_source_density,      ES_rela_source_amplitude, max(0,ES_magnitude./ES_off_field)}, ...
    'VariableNames', ...
                    {'Total dose',              'Residual',            'Max Y',            'Flag value', ...
                     'Current density',         'Angle error',         'Magnitude error',  'Relative error', ...
                     'Avg. off-field',          'Active electrodes',   'Separation angle', 'Search method', ...
                     'Maximum current (A)',     'Relative weight NNZ', 'Cortex thickness', 'Solver maximum current (mA)', ...
                     'Source density (A/m2)',   'Relative source amplitude', 'Current density vs. off-field ratio'});

%% Obj Fun
vec_aux = vec(1,[2,5,6,8,19]);
switch evalin('base','zef.ES_obj_fun')
    case {1,3,4}
        obj_funct   = cell2mat(vec_aux{1, evalin('base','zef.ES_obj_fun')});
        if evalin('base','zef.ES_acceptable_threshold') <= 100
            obj_funct_threshold = obj_funct;
            [Idx] = find(abs(obj_funct_threshold(:)) <= min(obj_funct_threshold(:))+(max(obj_funct_threshold(:))-min(obj_funct_threshold(:))).* (1-evalin('base','zef.ES_acceptable_threshold')/100));
        end
    case {2,5}
        obj_funct   = cell2mat(vec_aux{1,evalin('base','zef.ES_obj_fun')});
        if evalin('base','zef.ES_acceptable_threshold') <= 100
            obj_funct_threshold = obj_funct;
            [Idx] = find(obj_funct_threshold(:)      >= max(obj_funct_threshold(:))-(max(obj_funct_threshold(:))-min(obj_funct_threshold(:))).* (1-evalin('base','zef.ES_acceptable_threshold')/100));
        end
end

switch evalin('base','zef.ES_obj_fun_2')
    case {1,3,4}
        obj_funct_2   = cell2mat(vec_aux{1,evalin('base','zef.ES_obj_fun_2')});
        [~,Idx_2] = min(obj_funct_2(Idx));
    case {2,5}
        obj_funct_2   = cell2mat(vec_aux{1,evalin('base','zef.ES_obj_fun_2')});
        [~,Idx_2] = max(obj_funct_2(Idx));
end
[sr, sc] = ind2sub(size(obj_funct_2),Idx(Idx_2));
end