zef.h_ES_parameter_table.Data = cell(0);
zef_i = zef.ES_search_type;
if ismember(zef_i,1)

    zef.h_ES_search_method.Items = {'L1L1 optimization', 'Least squares optimization'};
zef.h_ES_search_method.ItemsData = [1 3];
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
        zef.h_ES_parameter_table.Data{10,1} = 'Targeted current density (A/m2)';
        zef.h_ES_parameter_table.Data{10,2} = num2str(zef.ES_source_density);
        zef.h_ES_parameter_table.Data{11,1} = 'Relative source amplitude';
        zef.h_ES_parameter_table.Data{11,2} = num2str(zef.ES_relative_source_amplitude);
        zef.h_ES_parameter_table.Data{12,1} = 'Acceptable threshold value';
        zef.h_ES_parameter_table.Data{12,2} = num2str(zef.ES_acceptable_threshold);
        zef.h_ES_parameter_table.Data{13,1} = 'Boundary color limit';
        zef.h_ES_parameter_table.Data{13,2} = num2str(zef.ES_boundary_color_limit);
        zef.h_ES_parameter_table.Data{14,1} = 'ROI radius (mm)';
        zef.h_ES_parameter_table.Data{14,2} = num2str(zef.ES_roi_range);
         zef.h_ES_parameter_table.Data{15,1} = 'Solver tolerance';
        zef.h_ES_parameter_table.Data{15,2} = num2str(zef.ES_solver_tolerance);
        zef.h_ES_parameter_table.Data{16,1} = 'Maximum number of iterations';
        zef.h_ES_parameter_table.Data{16,2} = num2str(zef.ES_max_n_iterations);
        zef.h_ES_parameter_table.Data{17,1} = 'Algorithm';
        zef.h_ES_parameter_table.Data{17,2} = num2str(zef.ES_algorithm);  
   zef.h_ES_parameter_table.Data{18,1} = 'Step tolerance';
        zef.h_ES_parameter_table.Data{18,2} = num2str(zef.ES_step_tolerance);
         zef.h_ES_parameter_table.Data{19,1} = 'Constraint tolerance';
        zef.h_ES_parameter_table.Data{19,2} = num2str(zef.ES_constraint_tolerance);   
         zef.h_ES_parameter_table.Data{20,1} = 'Maximum time (s)';
        zef.h_ES_parameter_table.Data{21,2} = num2str(zef.ES_max_time); 
        
end

if ismember(zef_i,2)
            
    zef.h_ES_search_method.Items = {'L1L1 optimization', 'L1L2 optimization', 'Least squares optimization'};
zef.h_ES_search_method.ItemsData = [1 2 3];
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
        zef.h_ES_parameter_table.Data{10,1} = 'Targeted current density (A/m2)';
        zef.h_ES_parameter_table.Data{10,2} = num2str(zef.ES_source_density);
        zef.h_ES_parameter_table.Data{11,1} = 'Relative source amplitude';
        zef.h_ES_parameter_table.Data{11,2} = num2str(zef.ES_relative_source_amplitude);
        zef.h_ES_parameter_table.Data{12,1} = 'Acceptable threshold value';
        zef.h_ES_parameter_table.Data{12,2} = num2str(zef.ES_acceptable_threshold);
        zef.h_ES_parameter_table.Data{13,1} = 'Boundary color limit';
        zef.h_ES_parameter_table.Data{13,2} = num2str(zef.ES_boundary_color_limit);
        zef.h_ES_parameter_table.Data{14,1} = 'ROI radius (mm)';
        zef.h_ES_parameter_table.Data{14,2} = num2str(zef.ES_roi_range);
         zef.h_ES_parameter_table.Data{15,1} = 'Solver tolerance';
        zef.h_ES_parameter_table.Data{15,2} = num2str(zef.ES_solver_tolerance);


end

if ismember(zef_i,3)
            
    zef.h_ES_search_method.Items = {'L1L1 optimization', 'L1L2 optimization', 'Least squares optimization'};
zef.h_ES_search_method.ItemsData = [1 2 3];
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
        zef.h_ES_parameter_table.Data{10,1} = 'Targeted current density (A/m2)';
        zef.h_ES_parameter_table.Data{10,2} = num2str(zef.ES_source_density);
        zef.h_ES_parameter_table.Data{11,1} = 'Relative source amplitude';
        zef.h_ES_parameter_table.Data{11,2} = num2str(zef.ES_relative_source_amplitude);
        zef.h_ES_parameter_table.Data{12,1} = 'Acceptable threshold value';
        zef.h_ES_parameter_table.Data{12,2} = num2str(zef.ES_acceptable_threshold);
        zef.h_ES_parameter_table.Data{13,1} = 'Boundary color limit';
        zef.h_ES_parameter_table.Data{13,2} = num2str(zef.ES_boundary_color_limit);
        zef.h_ES_parameter_table.Data{14,1} = 'ROI radius (mm)';
        zef.h_ES_parameter_table.Data{14,2} = num2str(zef.ES_roi_range);
         zef.h_ES_parameter_table.Data{15,1} = 'Solver tolerance';
        zef.h_ES_parameter_table.Data{15,2} = num2str(zef.ES_solver_tolerance);


end

if ismember(zef_i,4)
            
    zef.h_ES_search_method.Items = {'L1L1 optimization', 'Least squares optimization'};
zef.h_ES_search_method.ItemsData = [1 3];
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
        zef.h_ES_parameter_table.Data{10,1} = 'Targeted current density (A/m2)';
        zef.h_ES_parameter_table.Data{10,2} = num2str(zef.ES_source_density);
        zef.h_ES_parameter_table.Data{11,1} = 'Relative source amplitude';
        zef.h_ES_parameter_table.Data{11,2} = num2str(zef.ES_relative_source_amplitude);
        zef.h_ES_parameter_table.Data{12,1} = 'Acceptable threshold value';
        zef.h_ES_parameter_table.Data{12,2} = num2str(zef.ES_acceptable_threshold);
        zef.h_ES_parameter_table.Data{13,1} = 'Boundary color limit';
        zef.h_ES_parameter_table.Data{13,2} = num2str(zef.ES_boundary_color_limit);
        zef.h_ES_parameter_table.Data{14,1} = 'ROI radius (mm)';
        zef.h_ES_parameter_table.Data{14,2} = num2str(zef.ES_roi_range);
         zef.h_ES_parameter_table.Data{15,1} = 'Solver tolerance';
        zef.h_ES_parameter_table.Data{15,2} = num2str(zef.ES_solver_tolerance);
        zef.h_ES_parameter_table.Data{16,1} = 'Maximum number of iterations';
        zef.h_ES_parameter_table.Data{16,2} = num2str(zef.ES_max_n_iterations);
        zef.h_ES_parameter_table.Data{17,1} = 'Algorithm';
        zef.h_ES_parameter_table.Data{17,2} = num2str(zef.ES_algorithm);  
   zef.h_ES_parameter_table.Data{18,1} = 'Step tolerance';
        zef.h_ES_parameter_table.Data{18,2} = num2str(zef.ES_step_tolerance);
         zef.h_ES_parameter_table.Data{19,1} = 'Constraint tolerance';
        zef.h_ES_parameter_table.Data{19,2} = num2str(zef.ES_constraint_tolerance);   
         zef.h_ES_parameter_table.Data{20,1} = 'Maximum time (s)';
        zef.h_ES_parameter_table.Data{21,2} = num2str(zef.ES_max_time); 


end


if ismember(zef_i,5)
            
    zef.h_ES_search_method.Items = {'L1L1 optimization', 'Least squares optimization'};
zef.h_ES_search_method.ItemsData = [1 3];
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
        zef.h_ES_parameter_table.Data{10,1} = 'Targeted current density (A/m2)';
        zef.h_ES_parameter_table.Data{10,2} = num2str(zef.ES_source_density);
        zef.h_ES_parameter_table.Data{11,1} = 'Relative source amplitude';
        zef.h_ES_parameter_table.Data{11,2} = num2str(zef.ES_relative_source_amplitude);
        zef.h_ES_parameter_table.Data{12,1} = 'Acceptable threshold value';
        zef.h_ES_parameter_table.Data{12,2} = num2str(zef.ES_acceptable_threshold);
        zef.h_ES_parameter_table.Data{13,1} = 'Boundary color limit';
        zef.h_ES_parameter_table.Data{13,2} = num2str(zef.ES_boundary_color_limit);
        zef.h_ES_parameter_table.Data{14,1} = 'ROI radius (mm)';
        zef.h_ES_parameter_table.Data{14,2} = num2str(zef.ES_roi_range);
        zef.h_ES_parameter_table.Data{15,1} = 'Maximum number of iterations';
        zef.h_ES_parameter_table.Data{15,2} = num2str(zef.ES_max_n_iterations);
        zef.h_ES_parameter_table.Data{16,1} = 'Algorithm';
        zef.h_ES_parameter_table.Data{16,2} = num2str(zef.ES_algorithm);  

end



if ismember(zef_i,6)
            
    zef.h_ES_search_method.Items = {'L1L1 optimization', 'Least squares optimization'};
zef.h_ES_search_method.ItemsData = [1 3];
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
        zef.h_ES_parameter_table.Data{10,1} = 'Targeted current density (A/m2)';
        zef.h_ES_parameter_table.Data{10,2} = num2str(zef.ES_source_density);
        zef.h_ES_parameter_table.Data{11,1} = 'Relative source amplitude';
        zef.h_ES_parameter_table.Data{11,2} = num2str(zef.ES_relative_source_amplitude);
        zef.h_ES_parameter_table.Data{12,1} = 'Acceptable threshold value';
        zef.h_ES_parameter_table.Data{12,2} = num2str(zef.ES_acceptable_threshold);
        zef.h_ES_parameter_table.Data{13,1} = 'Boundary color limit';
        zef.h_ES_parameter_table.Data{13,2} = num2str(zef.ES_boundary_color_limit);
        zef.h_ES_parameter_table.Data{14,1} = 'ROI radius (mm)';
        zef.h_ES_parameter_table.Data{14,2} = num2str(zef.ES_roi_range);
                 zef.h_ES_parameter_table.Data{15,1} = 'Maximum time (s)';
        zef.h_ES_parameter_table.Data{15,2} = num2str(zef.ES_max_time); 
end

clear zef_i
