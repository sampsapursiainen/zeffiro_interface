zef.h_ES_parameter_table.Data = cell(0);
zef_i = zef.ES_search_method;
switch zef_i
    case {1,2,3}
        zef.h_ES_parameter_table.Data{1,1} = 'Alpha minimum (dB)';
        zef.h_ES_parameter_table.Data{1,2} = num2str(db(zef.ES_alpha));
        zef.h_ES_parameter_table.Data{2,1} = 'Alpha maximum (dB)';
        zef.h_ES_parameter_table.Data{2,2} = num2str(db(zef.ES_alpha_max));  
        zef.h_ES_parameter_table.Data{3,1}  = 'Nuisance field weight minimum (dB)';
        zef.h_ES_parameter_table.Data{3,2}  = num2str(db(zef.ES_beta_min));
        zef.h_ES_parameter_table.Data{4,1}  = 'Nuisance field weight maximum (dB)';
        zef.h_ES_parameter_table.Data{4,2}  = num2str(db(zef.ES_beta));        
        zef.h_ES_parameter_table.Data{5,1} = 'Total current in montage';
        zef.h_ES_parameter_table.Data{5,2} = num2str(zef.ES_total_max_current);
        zef.h_ES_parameter_table.Data{6,1} = 'Max current allowed per electrode';
        zef.h_ES_parameter_table.Data{6,2} = num2str(zef.ES_max_current_channel);
        zef.h_ES_parameter_table.Data{7,1} = 'Relative weight of non-zero currents';
        zef.h_ES_parameter_table.Data{7,2} = num2str(zef.ES_relative_weight_nnz);
        zef.h_ES_parameter_table.Data{8,1} = 'Maximum non-zero currents';
        zef.h_ES_parameter_table.Data{8,2} = num2str(zef.ES_score_dose);
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
        zef.h_ES_parameter_table.Data{15,1} = 'RoI radius (mm)';
        zef.h_ES_parameter_table.Data{15,2} = num2str(zef.ES_roi_range);
        
end
clear zef_i
