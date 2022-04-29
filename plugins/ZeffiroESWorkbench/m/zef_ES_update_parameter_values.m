n_ES = zef.ES_search_method;
switch n_ES
    case {1,2}
        zef.ES_alpha        = str2double(zef.h_ES_parameter_table.Data{1,2});
        zef.ES_alpha_max    = str2double(zef.h_ES_parameter_table.Data{2,2});
        if n_ES == 1
            zef.ES_beta       = str2double(zef.h_ES_parameter_table.Data{3,2});
            zef.ES_beta_min  = str2double(zef.h_ES_parameter_table.Data{4,2});
        elseif n_ES == 2
            zef.ES_kval        = str2double(zef.h_ES_parameter_table.Data{3,2});
            zef.ES_kval_max        = str2double(zef.h_ES_parameter_table.Data{4,2});
            zef.ES_delta        = str2double(zef.h_ES_parameter_table.Data{15,2});
            zef.ES_L1_iter      = str2double(zef.h_ES_parameter_table.Data{16,2});
        end
        zef.ES_total_max_current            = str2double(zef.h_ES_parameter_table.Data{5,2});
        zef.ES_max_current_channel          = str2double(zef.h_ES_parameter_table.Data{6,2});
        zef.ES_relative_weight_nnz          = str2double(zef.h_ES_parameter_table.Data{7,2});
        zef.ES_score_dose                   = str2double(zef.h_ES_parameter_table.Data{8,2});
        zef.ES_step_size                    = str2double(zef.h_ES_parameter_table.Data{9,2});
        zef.ES_source_density               = str2double(zef.h_ES_parameter_table.Data{10,2});
        zef.ES_cortex_thickness             = str2double(zef.h_ES_parameter_table.Data{11,2});
        zef.ES_relative_source_amplitude    = str2double(zef.h_ES_parameter_table.Data{12,2});
        zef.ES_acceptable_threshold         = str2double(zef.h_ES_parameter_table.Data{13,2});
        zef.ES_boundary_color_limit         = str2double(zef.h_ES_parameter_table.Data{14,2});
        
    case 3
        zef.ES_separation_angle             = str2double(zef.h_ES_parameter_table.Data{1,2});
        zef.ES_solver_max_current           = str2double(zef.h_ES_parameter_table.Data{2,2});
        zef.ES_maximum_current              = str2double(zef.h_ES_parameter_table.Data{3,2});
        zef.ES_relative_weight_nnz          = str2double(zef.h_ES_parameter_table.Data{4,2});
        zef.ES_source_density               = str2double(zef.h_ES_parameter_table.Data{5,2});
        zef.ES_cortex_thickness             = str2double(zef.h_ES_parameter_table.Data{6,2});
        zef.ES_relative_source_amplitude    = str2double(zef.h_ES_parameter_table.Data{7,2});
        zef.ES_boundary_color_limit         = str2double(zef.h_ES_parameter_table.Data{8,2});
end
clear n_ES