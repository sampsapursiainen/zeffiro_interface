if zef.ES_search_method == 1
    zef.ES_regularization_parameter = str2num(zef.h_ES_parameter_table.Data{1,2}); %#ok<*ST2NM>
    zef.ES_regularization_parameter_max = str2num(zef.h_ES_parameter_table.Data{2,2});
    zef.ES_optimizer_tolerance = str2num(zef.h_ES_parameter_table.Data{3,2});
    zef.ES_optimizer_tolerance_max = str2num(zef.h_ES_parameter_table.Data{4,2});
    zef.ES_solvermaximumcurrent = str2num(zef.h_ES_parameter_table.Data{5,2});
    zef.ES_maximum_current = str2num(zef.h_ES_parameter_table.Data{6,2});
    zef.ES_relativeweightnnz = str2num(zef.h_ES_parameter_table.Data{7,2});
    zef.ES_scoredose = str2num(zef.h_ES_parameter_table.Data{8,2});
    zef.ES_step_size = str2num(zef.h_ES_parameter_table.Data{9,2});
    zef.ES_source_density = str2num(zef.h_ES_parameter_table.Data{10,2});
    zef.ES_cortex_thickness = str2num(zef.h_ES_parameter_table.Data{11,2});
    zef.ES_relative_source_amplitude = str2num(zef.h_ES_parameter_table.Data{12,2});
    zef.ES_acceptable_threshold = str2num(zef.h_ES_parameter_table.Data{13,2});
    zef.ES_boundary_color_limit = str2num(zef.h_ES_parameter_table.Data{14,2});
elseif zef.ES_search_method == 2
    zef.ES_regularization_parameter = str2num(zef.h_ES_parameter_table.Data{1,2});
    zef.ES_regularization_parameter_max = str2num(zef.h_ES_parameter_table.Data{2,2});
    zef.ES_L2_reg_ratio_LL = str2num(zef.h_ES_parameter_table.Data{3,2});
    zef.ES_L2_reg_ratio_UL = str2num(zef.h_ES_parameter_table.Data{4,2});
    zef.ES_solvermaximumcurrent = str2num(zef.h_ES_parameter_table.Data{5,2});
    zef.ES_maximum_current = str2num(zef.h_ES_parameter_table.Data{6,2});
    zef.ES_relativeweightnnz = str2num(zef.h_ES_parameter_table.Data{7,2});
    zef.ES_scoredose = str2num(zef.h_ES_parameter_table.Data{8,2});
    zef.ES_step_size = str2num(zef.h_ES_parameter_table.Data{9,2});
    zef.ES_source_density = str2num(zef.h_ES_parameter_table.Data{10,2});
    zef.ES_cortex_thickness = str2num(zef.h_ES_parameter_table.Data{11,2});
    zef.ES_relative_source_amplitude = str2num(zef.h_ES_parameter_table.Data{12,2});
    zef.ES_delta_param = str2num(zef.h_ES_parameter_table.Data{13,2});
    zef.ES_L1_iter = str2num(zef.h_ES_parameter_table.Data{14,2});
    zef.ES_acceptable_threshold = str2num(zef.h_ES_parameter_table.Data{15,2});
    zef.ES_boundary_color_limit = str2num(zef.h_ES_parameter_table.Data{16,2});
elseif zef.ES_search_method == 3
    zef.ES_separation_angle = str2num(zef.h_ES_parameter_table.Data{1,2});
    zef.ES_solvermaximumcurrent = str2num(zef.h_ES_parameter_table.Data{2,2});
    zef.ES_maximum_current = str2num(zef.h_ES_parameter_table.Data{3,2});
    zef.ES_relativeweightnnz = str2num(zef.h_ES_parameter_table.Data{4,2});
    zef.ES_source_density = str2num(zef.h_ES_parameter_table.Data{5,2});
    zef.ES_cortex_thickness = str2num(zef.h_ES_parameter_table.Data{6,2});
    zef.ES_relative_source_amplitude = str2num(zef.h_ES_parameter_table.Data{7,2});
    zef.ES_boundary_color_limit = str2num(zef.h_ES_parameter_table.Data{8,2});
end
