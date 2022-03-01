zef.h_ES_parameter_table.Data = cell(0);

if zef.ES_search_method == 1
    zef.h_ES_parameter_table.Data{1,1} = 'Regularization parameter minimum';
    zef.h_ES_parameter_table.Data{1,2} = num2str(zef.ES_regularization_parameter);
    zef.h_ES_parameter_table.Data{2,1} = 'Regularization parameter maximum';
    zef.h_ES_parameter_table.Data{2,2} = num2str(zef.ES_regularization_parameter_max);
    zef.h_ES_parameter_table.Data{3,1} = 'Optimizer tolerance minimum';
    zef.h_ES_parameter_table.Data{3,2} = num2str(zef.ES_optimizer_tolerance);
    zef.h_ES_parameter_table.Data{4,1} = 'Optimizer tolerance maximum';
    zef.h_ES_parameter_table.Data{4,2} = num2str(zef.ES_optimizer_tolerance_max);
    zef.h_ES_parameter_table.Data{5,1} = 'Maximum total dose';
    zef.h_ES_parameter_table.Data{5,2} = num2str(zef.ES_solvermaximumcurrent);
    zef.h_ES_parameter_table.Data{6,1} = 'Maximum current per electrode';
    zef.h_ES_parameter_table.Data{6,2} = num2str(zef.ES_maximum_current);
    zef.h_ES_parameter_table.Data{7,1} = 'Relative weight of non-zero currents';
    zef.h_ES_parameter_table.Data{7,2} = num2str(zef.ES_relativeweightnnz);
    zef.h_ES_parameter_table.Data{8,1} = 'Maximum non-zero currents';
    zef.h_ES_parameter_table.Data{8,2} = num2str(zef.ES_scoredose);
    zef.h_ES_parameter_table.Data{9,1} = 'Lattice size';
    zef.h_ES_parameter_table.Data{9,2} = num2str(zef.ES_step_size);
    zef.h_ES_parameter_table.Data{10,1} = 'Source density';
    zef.h_ES_parameter_table.Data{10,2} = num2str(zef.ES_source_density);
    zef.h_ES_parameter_table.Data{11,1} = 'Cortex thickness';
    zef.h_ES_parameter_table.Data{11,2} = num2str(zef.ES_cortex_thickness);
    zef.h_ES_parameter_table.Data{12,1} = 'Relative source amplitude';
    zef.h_ES_parameter_table.Data{12,2} = num2str(zef.ES_relative_source_amplitude);
    zef.h_ES_parameter_table.Data{13,1} = 'Acceptable threshold value';
    zef.h_ES_parameter_table.Data{13,2} = num2str(zef.ES_acceptable_threshold);
    zef.h_ES_parameter_table.Data{14,1} = 'Boundary color limit';
    zef.h_ES_parameter_table.Data{14,2} = num2str(zef.ES_boundary_color_limit);

elseif zef.ES_search_method == 2

    zef.h_ES_parameter_table.Data{1,1} = 'Regularization parameter minimum';
    zef.h_ES_parameter_table.Data{1,2} = num2str(zef.ES_regularization_parameter);
    zef.h_ES_parameter_table.Data{2,1} = 'Regularization parameter maximum';
    zef.h_ES_parameter_table.Data{2,2} = num2str(zef.ES_regularization_parameter_max);

    zef.h_ES_parameter_table.Data{3,1} = 'Relative weighting minimum';
    zef.h_ES_parameter_table.Data{3,2} = num2str(zef.ES_L2_reg_ratio_LL);
    zef.h_ES_parameter_table.Data{4,1} = 'Relative weighting maximum';
    zef.h_ES_parameter_table.Data{4,2} = num2str(zef.ES_L2_reg_ratio_UL);

    zef.h_ES_parameter_table.Data{5,1} = 'Maximum total dose';
    zef.h_ES_parameter_table.Data{5,2} = num2str(zef.ES_solvermaximumcurrent);

    zef.h_ES_parameter_table.Data{6,1} = 'Maximum current per electrode';
    zef.h_ES_parameter_table.Data{6,2} = num2str(zef.ES_maximum_current);

    zef.h_ES_parameter_table.Data{7,1} = 'Relative weight of non-zero currents';
    zef.h_ES_parameter_table.Data{7,2} = num2str(zef.ES_relativeweightnnz);

    zef.h_ES_parameter_table.Data{8,1} = 'Maximum non-zero currents';
    zef.h_ES_parameter_table.Data{8,2} = num2str(zef.ES_scoredose);

    zef.h_ES_parameter_table.Data{9,1} = 'Lattice size';
    zef.h_ES_parameter_table.Data{9,2} = num2str(zef.ES_step_size);

    zef.h_ES_parameter_table.Data{10,1} = 'Source density';
    zef.h_ES_parameter_table.Data{10,2} = num2str(zef.ES_source_density);

    zef.h_ES_parameter_table.Data{11,1} = 'Cortex thickness';
    zef.h_ES_parameter_table.Data{11,2} = num2str(zef.ES_cortex_thickness);

    zef.h_ES_parameter_table.Data{12,1} = 'Relative source amplitude';
    zef.h_ES_parameter_table.Data{12,2} = num2str(zef.ES_relative_source_amplitude);

    zef.h_ES_parameter_table.Data{13,1} = 'Delta value';
    zef.h_ES_parameter_table.Data{13,2} = num2str(zef.ES_delta_param);

    zef.h_ES_parameter_table.Data{14,1} = 'L1 iteration steps';
    zef.h_ES_parameter_table.Data{14,2} = num2str(zef.ES_L1_iter);

    zef.h_ES_parameter_table.Data{15,1} = 'Acceptable threshold value';
    zef.h_ES_parameter_table.Data{15,2} = num2str(zef.ES_acceptable_threshold);

    zef.h_ES_parameter_table.Data{16,1} = 'Boundary color limit';
    zef.h_ES_parameter_table.Data{16,2} = num2str(zef.ES_boundary_color_limit);

elseif zef.ES_search_method == 3

    zef.h_ES_parameter_table.Data{1,1} = 'Separation angle';
    zef.h_ES_parameter_table.Data{1,2} = num2str(zef.ES_separation_angle);

    zef.h_ES_parameter_table.Data{2,1} = 'Maximum total dose (A)';
    zef.h_ES_parameter_table.Data{2,2} = num2str(zef.ES_solvermaximumcurrent);

    zef.h_ES_parameter_table.Data{3,1} = 'Maximum current per electrode (A)';
    zef.h_ES_parameter_table.Data{3,2} = num2str(zef.ES_maximum_current);

    zef.h_ES_parameter_table.Data{4,1} = 'Relative weight of non-zero currents';
    zef.h_ES_parameter_table.Data{4,2} = num2str(zef.ES_relativeweightnnz);

    zef.h_ES_parameter_table.Data{5,1} = 'Source density';
    zef.h_ES_parameter_table.Data{5,2} = num2str(zef.ES_source_density);

    zef.h_ES_parameter_table.Data{6,1} = 'Cortex thickness';
    zef.h_ES_parameter_table.Data{6,2} = num2str(zef.ES_cortex_thickness);

    zef.h_ES_parameter_table.Data{7,1} = 'Relative source amplitude';
    zef.h_ES_parameter_table.Data{7,2} = num2str(zef.ES_relative_source_amplitude);

    zef.h_ES_parameter_table.Data{8,1} = 'Boundary color limit';
    zef.h_ES_parameter_table.Data{8,2} = num2str(zef.ES_boundary_color_limit);

end