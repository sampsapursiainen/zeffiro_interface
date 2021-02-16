function [results_summary, vector_field_aux] = source_calculations(results_summary, L_aux, i, j, y_tes, residual, flag_val, timer, source_position_index, source_directions, source_magnitude, varargin)
if length(varargin) >= 1
    threshold_values = varargin{1};
    t = varargin{2};
else
    threshold_values = 0;
    t = 0;
end
if length(varargin) == 3
    y_tes_aux_vec = varargin{3};
    if isempty(y_tes_aux_vec)
       y_tes_aux_vec = 0;
    end
else
    y_tes_aux_vec = 0;
end

%%%%% For general
if (threshold_values == 0)
    if ismember(flag_val, [1 3])
        vector_field_aux                       = reshape(L_aux*y_tes,3,size(L_aux,1)/3);
        results_summary.mag_field_max_abs{i,j} = abs(max(vector_field_aux));
        results_summary.mag_field_norm{i,j}    = sqrt(sum(sum(vector_field_aux.^2)));
        results_summary.y_tes{i,j}             = y_tes;
        results_summary.y_tes_norm{i,j}        = norm(y_tes,1);
        results_summary.residual{i,j}          = residual;
        results_summary.residual_norm{i,j}     = norm(residual,1);
        results_summary.flag_value{i,j}        = flag_val;
        results_summary.source_directions      = source_directions;
        results_summary.source_magnitude       = source_magnitude;
        for running_index = 1 : length(source_position_index)
            vec_1 = source_magnitude(running_index)*source_directions(running_index,:);
            vec_2 = (vector_field_aux(:,source_position_index(running_index)).^2);
            results_summary.field_source(running_index).field_source{i,j}  = (vector_field_aux(:,source_position_index(running_index)).^2);
            results_summary.field_source(running_index).magnitude{i,j}     = sqrt(sum(vector_field_aux(:,source_position_index(running_index)).^2));
            results_summary.field_source(running_index).angle{i,j}         = 180/pi*acos(dot(vec_1',vec_2)/(norm(vec_1')*norm(vec_2)));
            results_summary.field_source(running_index).relative{i,j}      = norm(vec_2)/norm(vec_1');
            results_summary.field_source(running_index).error_norm{i,j}    = norm(vec_1'-vec_2);
        end
        results_summary.elapsed_time{i,j}      = timer;
    end
    if ismember(flag_val, [-2])
        vector_field_aux                       = 0;
        results_summary.mag_field_max_abs{i,j} = 0;
        results_summary.mag_field_norm{i,j}    = 0;
        results_summary.y_tes{i,j}             = 0;
        results_summary.y_tes_norm{i,j}        = 0;
        results_summary.residual{i,j}          = 0;
        results_summary.residual_norm{i,j}     = 0;
        results_summary.flag_value{i,j}        = flag_val;
        results_summary.source_directions      = source_directions;
        results_summary.source_magnitude       = source_magnitude;
        for running_index = 1 : length(source_position_index)
            results_summary.results_source(running_index).field_source(i,j)            = 0;
            results_summary.results_source(running_index).field_source_mag(i,j)        = 0;
            results_summary.results_source(running_index).field_source_angle(i,j)      = 0;
            results_summary.results_source(running_index).field_source_relative(i,j)   = 0;
            results_summary.results_source(running_index).field_source_error_norm(i,j) = 0;
        end
        
    end
end

%%%%% For threshold
if (t > 0)
    if (y_tes_aux_vec == 0)
        if ismember(flag_val, [1 3])
            I_threshold                              = find(abs(y_tes) < threshold_values*max(abs(y_tes)));
            y_tes(I_threshold)                       = 0; %#ok<FNDSB>
            
            vector_field_aux                         = reshape(L_aux*y_tes,3,size(L_aux,1)/3);
            results_summary.mag_field_max_abs{i,j,t} = abs(max(vector_field_aux));
            results_summary.mag_field_norm{i,j,t}    = sqrt(sum(sum(vector_field_aux.^2)));
            results_summary.y_tes{i,j,t}             = y_tes;
            results_summary.y_tes_norm{i,j,t}        = norm(y_tes,1);
            results_summary.residual{i,j,t}          = residual;
            results_summary.residual_norm{i,j,t}     = norm(residual,1);
            results_summary.flag_value{i,j,t}        = flag_val;
            results_summary.source_directions        = source_directions;
            results_summary.source_magnitude         = source_magnitude;
            for running_index = 1 : length(source_position_index)
                vec_1 = source_magnitude(running_index)*source_directions(running_index,:);
                vec_2 = (vector_field_aux(:,source_position_index(running_index)).^2);
                results_summary.field_source(running_index).field_source{i,j}  = (vector_field_aux(:,source_position_index(running_index)).^2);
                results_summary.field_source(running_index).magnitude{i,j}     = sqrt(sum(vector_field_aux(:,source_position_index(running_index)).^2));
                results_summary.field_source(running_index).angle{i,j}         = 180/pi*acos(dot(vec_1',vec_2)/(norm(vec_1')*norm(vec_2)));
                results_summary.field_source(running_index).relative{i,j}      = norm(vec_2)/norm(vec_1');
                results_summary.field_source(running_index).error_norm{i,j}    = norm(vec_1'-vec_2);
            end
        end
        if ismember(flag_val, [-2])
            vector_field_aux                         = 0;
            results_summary.mag_field_max_abs{i,j,t} = 0;
            results_summary.mag_field_norm{i,j,t}    = 0;
            results_summary.y_tes{i,j,t}             = 0;
            results_summary.y_tes_norm{i,j,t}        = 0;
            results_summary.residual{i,j,t}          = 0;
            results_summary.residual_norm{i,j,t}     = 0;
            results_summary.flag_value{i,j,t}        = flag_val;
            results_summary.source_directions        = source_directions;
            results_summary.source_magnitude         = source_magnitude;
            for running_index = 1 : length(source_position_index)
                results_summary.field_source(running_index).field_source{i,j}  = 0;
                results_summary.field_source(running_index).magnitude{i,j}     = 0;
                results_summary.field_source(running_index).angle{i,j}         = 0;
                results_summary.field_source(running_index).relative{i,j}      = 0;
                results_summary.field_source(running_index).error_norm{i,j}    = 0;
            end
       end
    end
end

%%%%%% For active
if (t > 0)
    if any(y_tes_aux_vec > 0)
         if ismember(flag_val, [1 3])
            vector_field_aux                         = reshape(L_aux*y_tes,3,size(L_aux,1)/3);
            results_summary.mag_field_max_abs{i,j,t} = abs(max(vector_field_aux));
            results_summary.mag_field_norm{i,j,t}    = sqrt(sum(sum(vector_field_aux.^2)));
            results_summary.y_tes{i,j,t}             = y_tes;
            results_summary.y_tes_norm{i,j,t}        = norm(y_tes,1);
            results_summary.residual{i,j,t}          = residual;
            results_summary.residual_norm{i,j,t}     = norm(residual);
            results_summary.flag_value{i,j,t}        = flag_val;
            results_summary.source_directions        = source_directions;
            results_summary.source_magnitude         = source_magnitude;
            for running_index = 1 : length(source_position_index)
                vec_1 = source_magnitude(running_index)*source_directions(running_index,:);
                vec_2 = (vector_field_aux(:,source_position_index(running_index)).^2);
                results_summary.field_source(running_index).field_source{i,j}  = (vector_field_aux(:,source_position_index(running_index)).^2);
                results_summary.field_source(running_index).magnitude{i,j}     = sqrt(sum(vector_field_aux(:,source_position_index(running_index)).^2));
                results_summary.field_source(running_index).angle{i,j}         = 180/pi*acos(dot(vec_1',vec_2)/(norm(vec_1')*norm(vec_2)));
                results_summary.field_source(running_index).relative{i,j}      = norm(vec_2)/norm(vec_1');
                results_summary.field_source(running_index).error_norm{i,j}    = norm(vec_1'-vec_2);
            end
            results_summary.elapsed_time{i,j,t}      = timer;
        end
        if ismember(flag_val, [-2])
            vector_field_aux                         = 0;
            results_summary.mag_field_max_abs{i,j,t} = 0;
            results_summary.mag_field_norm{i,j,t}    = 0;
            results_summary.y_tes{i,j,t}             = 0;
            results_summary.y_tes_norm{i,j,t}        = 0;
            results_summary.residual{i,j,t}          = 0;
            results_summary.residual_norm{i,j,t}     = 0;
            results_summary.flag_value{i,j,t}        = flag_val;
            results_summary.source_directions        = source_directions;
            results_summary.source_magnitude         = source_magnitude;
            for running_index = 1 : length(source_position_index)
                results_summary.field_source(running_index).field_source{i,j}  = 0;
                results_summary.field_source(running_index).magnitude{i,j}     = 0;
                results_summary.field_source(running_index).angle{i,j}         = 0;
                results_summary.field_source(running_index).relative{i,j}      = 0;
                results_summary.field_source(running_index).error_norm{i,j}    = 0;
            end
            results_summary.elapsed_time{i,j,t}      = timer;
       end
    end
end

end %% function end