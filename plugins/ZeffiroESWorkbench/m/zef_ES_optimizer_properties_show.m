if ismember(zef.ES_search_method,[1 2])

    if not(isfield(zef,'h_ES_optimizer_properties'))
        zef_ES_optimizer_properties;
    elseif not(isvalid(zef.h_ES_optimizer_properties))
        zef_ES_optimizer_properties;
    end

    figure(zef.h_ES_optimizer_properties);

    if zef.ES_search_type == 1
        zef.h_ES_optimizer_properties_table.Data{1,1} = 'Current density at source location';
        zef.h_ES_optimizer_properties_table.Data{1,2} = zef.y_ES_single.field_source.magnitude;
        zef.h_ES_optimizer_properties_table.Data{2,1} = 'Magnitude error';
        zef.h_ES_optimizer_properties_table.Data{2,2} = zef.y_ES_single.field_source.relative_norm;
        zef.h_ES_optimizer_properties_table.Data{3,1} = 'Angle error';
        zef.h_ES_optimizer_properties_table.Data{3,2} = zef.y_ES_single.field_source.angle;
        zef.h_ES_optimizer_properties_table.Data{4,1} = 'Relative error';
        zef.h_ES_optimizer_properties_table.Data{4,2} = zef.y_ES_single.field_source.relative_error;
        zef.h_ES_optimizer_properties_table.Data{5,1} = 'Maximum current';
        zef.h_ES_optimizer_properties_table.Data{5,2} = max(abs(zef.y_ES_single.y_ES));
        zef.h_ES_optimizer_properties_table.Data{6,1} = 'Total dose';
        zef.h_ES_optimizer_properties_table.Data{6,2} = sum(abs(zef.y_ES_single.y_ES));
        zef.h_ES_optimizer_properties_table.Data{7,1} = 'Off-field ';
        zef.h_ES_optimizer_properties_table.Data{7,2} = zef.y_ES_single.field_source.avg_off_field;
    end

    if zef.ES_search_type == 2
        [~, zef.ES_star_row, zef.ES_star_col]         = zef_ES_objective_function;
        zef.h_ES_optimizer_properties_table.Data{1,1} = 'Current density at source location';
        zef.h_ES_optimizer_properties_table.Data{1,2} = zef.y_ES_interval.field_source.magnitude{zef.ES_star_row, zef.ES_star_col};
        zef.h_ES_optimizer_properties_table.Data{2,1} = 'Magnitude error';
        zef.h_ES_optimizer_properties_table.Data{2,2} = zef.y_ES_interval.field_source.relative_norm_error{zef.ES_star_row, zef.ES_star_col};
        zef.h_ES_optimizer_properties_table.Data{3,1} = 'Angle error';
        zef.h_ES_optimizer_properties_table.Data{3,2} = zef.y_ES_interval.field_source.angle{zef.ES_star_row, zef.ES_star_col};
        zef.h_ES_optimizer_properties_table.Data{4,1} = 'Relative error';
        zef.h_ES_optimizer_properties_table.Data{4,2} = zef.y_ES_interval.field_source.relative_error{zef.ES_star_row, zef.ES_star_col};
        zef.h_ES_optimizer_properties_table.Data{5,1} = 'Maximum current';
        zef.h_ES_optimizer_properties_table.Data{5,2} = max(abs(zef.y_ES_interval.y_ES{zef.ES_star_row, zef.ES_star_col}));
        zef.h_ES_optimizer_properties_table.Data{6,1} = 'Total dose';
        zef.h_ES_optimizer_properties_table.Data{6,2} = sum(abs(zef.y_ES_interval.y_ES{zef.ES_star_row, zef.ES_star_col}));
        zef.h_ES_optimizer_properties_table.Data{7,1} = 'Off-field ';
        zef.h_ES_optimizer_properties_table.Data{7,2} = zef.y_ES_interval.field_source.avg_off_field{zef.ES_star_row, zef.ES_star_col};
        zef.h_ES_optimizer_properties_table.Data{8,1} = 'Alpha';
        zef.h_ES_optimizer_properties_table.Data{8,2} = zef.y_ES_interval.reg_param(zef.ES_star_col);
        zef.h_ES_optimizer_properties_table.Data{9,1} = 'Tol/k-val';
        if zef.ES_search_method == 1
            zef.h_ES_optimizer_properties_table.Data{9,2} = zef.y_ES_interval.optimizer_tolerance(zef.ES_star_row);
        else
            zef.h_ES_optimizer_properties_table.Data{9,2} = zef.y_ES_interval.k_val(zef.ES_star_row);
        end
    end
end