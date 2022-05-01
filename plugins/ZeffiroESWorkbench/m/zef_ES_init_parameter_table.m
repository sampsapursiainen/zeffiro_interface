zef.h_ES_parameter_table.Data = cell(0);
n_ES = zef.ES_search_method;
switch n_ES
    case {1,2}
        zef.h_ES_parameter_table.Data{1,1} = 'Alpha minimum (dB)';
        zef.h_ES_parameter_table.Data{1,2} = num2str(db(zef.ES_alpha));
        zef.h_ES_parameter_table.Data{2,1} = 'Alpha maximum (dB)';
        zef.h_ES_parameter_table.Data{2,2} = num2str(db(zef.ES_alpha_max));
        
        if     n_ES == 1
              zef.h_ES_parameter_table.Data{3,1}  = 'Off-field weight minimum (dB)';
            zef.h_ES_parameter_table.Data{3,2}  = num2str(db(zef.ES_beta_min));
            zef.h_ES_parameter_table.Data{4,1}  = 'Off-field weight maximum (dB)';
            zef.h_ES_parameter_table.Data{4,2}  = num2str(db(zef.ES_beta));
        elseif n_ES == 2
            zef.h_ES_parameter_table.Data{3,1}  = 'Off-field weight minimum (dB)';
            zef.h_ES_parameter_table.Data{3,2}  = num2str(db(zef.ES_kval));
            zef.h_ES_parameter_table.Data{4,1}  = 'Off-field weight maximum (dB)';
            zef.h_ES_parameter_table.Data{4,2}  = num2str(db(zef.ES_kval_max));
            zef.h_ES_parameter_table.Data{15,1} = 'Delta';
            zef.h_ES_parameter_table.Data{15,2} = num2str(zef.ES_delta);
            zef.h_ES_parameter_table.Data{16,1} = 'Re-weighting iteration steps';
            zef.h_ES_parameter_table.Data{16,2} = num2str(zef.ES_L1_iter);
        end
        
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
        
    case 3
        zef.h_ES_parameter_table.Data{1,1} = 'Separation angle';
        zef.h_ES_parameter_table.Data{1,2} = num2str(zef.ES_separation_angle);
        zef.h_ES_parameter_table.Data{2,1} = 'Total current in montage';
        zef.h_ES_parameter_table.Data{2,2} = num2str(zef.ES_total_max_current);
        zef.h_ES_parameter_table.Data{3,1} = 'Max current allowed per electrode';
        zef.h_ES_parameter_table.Data{3,2} = num2str(zef.ES_max_current_channel);
        zef.h_ES_parameter_table.Data{4,1} = 'Relative weight of non-zero currents';
        zef.h_ES_parameter_table.Data{4,2} = num2str(zef.ES_relative_weight_nnz);
        zef.h_ES_parameter_table.Data{5,1} = 'Source density';
        zef.h_ES_parameter_table.Data{5,2} = num2str(zef.ES_source_density);
        zef.h_ES_parameter_table.Data{6,1} = 'Cortex thickness';
        zef.h_ES_parameter_table.Data{6,2} = num2str(zef.ES_cortex_thickness);
        zef.h_ES_parameter_table.Data{7,1} = 'Relative source amplitude';
        zef.h_ES_parameter_table.Data{7,2} = num2str(zef.ES_relative_source_amplitude);
        zef.h_ES_parameter_table.Data{8,1} = 'Boundary color limit';
        zef.h_ES_parameter_table.Data{8,2} = num2str(zef.ES_boundary_color_limit);
end
clear n_ES