zef.h_ES_parameter_table.Data = cell(0);

if ismember(zef.ES_search_type,1)

    zef.h_ES_search_method.Items = zef.ES_search_method_list([1 3 4]);
zef.h_ES_search_method.ItemsData = [1 3 4];
   zef.h_ES_algorithm.Items = zef.ES_algorithm_list([1 2 3]);
zef.h_ES_algorithm.ItemsData = [1 2 3];

if not(isequal(zef.ES_search_method,4))
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
        zef.h_ES_parameter_table.Data{7,1} = 'Threshold for non-zero currents';
        zef.h_ES_parameter_table.Data{7,2} = num2str(zef.ES_relative_weight_nnz);
        zef.h_ES_parameter_table.Data{8,1} = 'Maximum non-zero currents';
        zef.h_ES_parameter_table.Data{8,2} = num2str(zef.ES_score_dose);
        zef.h_ES_parameter_table.Data{9,1} = 'Lattice size';
        zef.h_ES_parameter_table.Data{9,2} = num2str(zef.ES_step_size);
        zef.h_ES_parameter_table.Data{10,1} = 'Targeted current density (A/m2)';
        zef.h_ES_parameter_table.Data{10,2} = num2str(zef.ES_source_density);
        zef.h_ES_parameter_table.Data{11,1} = 'Second-stage search threshold';
        zef.h_ES_parameter_table.Data{11,2} = num2str(zef.ES_acceptable_threshold);
        zef.h_ES_parameter_table.Data{12,1} = 'Boundary color limit';
        zef.h_ES_parameter_table.Data{12,2} = num2str(zef.ES_boundary_color_limit);
        zef.h_ES_parameter_table.Data{13,1} = 'ROI radius (mm)';
        zef.h_ES_parameter_table.Data{13,2} = num2str(zef.ES_roi_range);
         zef.h_ES_parameter_table.Data{14,1} = 'Solver tolerance';
        zef.h_ES_parameter_table.Data{14,2} = num2str(zef.ES_solver_tolerance);
        zef.h_ES_parameter_table.Data{15,1} = 'Maximum number of iterations';
        zef.h_ES_parameter_table.Data{15,2} = num2str(zef.ES_max_n_iterations);
   zef.h_ES_parameter_table.Data{16,1} = 'Step tolerance';
        zef.h_ES_parameter_table.Data{16,2} = num2str(zef.ES_step_tolerance);
         zef.h_ES_parameter_table.Data{17,1} = 'Constraint tolerance';
        zef.h_ES_parameter_table.Data{17,2} = num2str(zef.ES_constraint_tolerance);   
         zef.h_ES_parameter_table.Data{18,1} = 'Maximum time (s)';
        zef.h_ES_parameter_table.Data{18,2} = num2str(zef.ES_max_time);
         zef.h_ES_parameter_table.Data{19,1} = 'Display';
        zef.h_ES_parameter_table.Data{19,2} = num2str(zef.ES_display);
else
         zef.h_ES_parameter_table.Data{1,1} = 'Total current in montage';
        zef.h_ES_parameter_table.Data{1,2} = num2str(zef.ES_total_max_current);
        zef.h_ES_parameter_table.Data{2,1} = 'Max current allowed per electrode';
        zef.h_ES_parameter_table.Data{2,2} = num2str(zef.ES_max_current_channel);
        zef.h_ES_parameter_table.Data{3,1} = 'Threshold for non-zero currents';
        zef.h_ES_parameter_table.Data{3,2} = num2str(zef.ES_relative_weight_nnz);
        zef.h_ES_parameter_table.Data{4,1} = 'Maximum non-zero currents';
        zef.h_ES_parameter_table.Data{4,2} = num2str(zef.ES_score_dose);
                zef.h_ES_parameter_table.Data{5,1} = 'Boundary color limit';
        zef.h_ES_parameter_table.Data{5,2} = num2str(zef.ES_boundary_color_limit);
                zef.h_ES_parameter_table.Data{6,1} = 'ROI radius (mm)';
        zef.h_ES_parameter_table.Data{6,2} = num2str(zef.ES_roi_range);
end


end
        

if ismember(zef.ES_search_type,2)
            
    zef.h_ES_search_method.Items = zef.ES_search_method_list([1 2]);
zef.h_ES_search_method.ItemsData = [1 2];
   zef.h_ES_algorithm.Items = zef.ES_algorithm_list([1]);
zef.h_ES_algorithm.ItemsData = [1];

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
        zef.h_ES_parameter_table.Data{7,1} = 'Threshold for non-zero currents';
        zef.h_ES_parameter_table.Data{7,2} = num2str(zef.ES_relative_weight_nnz);
        zef.h_ES_parameter_table.Data{8,1} = 'Maximum non-zero currents';
        zef.h_ES_parameter_table.Data{8,2} = num2str(zef.ES_score_dose);
        zef.h_ES_parameter_table.Data{9,1} = 'Lattice size';
        zef.h_ES_parameter_table.Data{9,2} = num2str(zef.ES_step_size);
        zef.h_ES_parameter_table.Data{10,1} = 'Targeted current density (A/m2)';
        zef.h_ES_parameter_table.Data{10,2} = num2str(zef.ES_source_density);
        zef.h_ES_parameter_table.Data{11,1} = 'Second-stage search threshold';
        zef.h_ES_parameter_table.Data{11,2} = num2str(zef.ES_acceptable_threshold);
        zef.h_ES_parameter_table.Data{12,1} = 'Boundary color limit';
        zef.h_ES_parameter_table.Data{12,2} = num2str(zef.ES_boundary_color_limit);
        zef.h_ES_parameter_table.Data{13,1} = 'ROI radius (mm)';
        zef.h_ES_parameter_table.Data{13,2} = num2str(zef.ES_roi_range);
         zef.h_ES_parameter_table.Data{14,1} = 'Solver tolerance';
        zef.h_ES_parameter_table.Data{14,2} = num2str(zef.ES_solver_tolerance);
         zef.h_ES_parameter_table.Data{15,1} = 'Display';
        zef.h_ES_parameter_table.Data{15,2} = num2str(zef.ES_display);

end

if ismember(zef.ES_search_type,3)
            
    zef.h_ES_search_method.Items =zef.ES_search_method_list([1 2]);
zef.h_ES_search_method.ItemsData = [1 2];
   zef.h_ES_algorithm.Items = zef.ES_algorithm_list([1]);
zef.h_ES_algorithm.ItemsData = [1];

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
        zef.h_ES_parameter_table.Data{7,1} = 'Threshold for non-zero currents';
        zef.h_ES_parameter_table.Data{7,2} = num2str(zef.ES_relative_weight_nnz);
        zef.h_ES_parameter_table.Data{8,1} = 'Maximum non-zero currents';
        zef.h_ES_parameter_table.Data{8,2} = num2str(zef.ES_score_dose);
        zef.h_ES_parameter_table.Data{9,1} = 'Lattice size';
        zef.h_ES_parameter_table.Data{9,2} = num2str(zef.ES_step_size);
        zef.h_ES_parameter_table.Data{10,1} = 'Targeted current density (A/m2)';
        zef.h_ES_parameter_table.Data{10,2} = num2str(zef.ES_source_density);
        zef.h_ES_parameter_table.Data{11,1} = 'Second-stage search threshold';
        zef.h_ES_parameter_table.Data{11,2} = num2str(zef.ES_acceptable_threshold);
        zef.h_ES_parameter_table.Data{12,1} = 'Boundary color limit';
        zef.h_ES_parameter_table.Data{12,2} = num2str(zef.ES_boundary_color_limit);
        zef.h_ES_parameter_table.Data{13,1} = 'ROI radius (mm)';
        zef.h_ES_parameter_table.Data{13,2} = num2str(zef.ES_roi_range);
         zef.h_ES_parameter_table.Data{14,1} = 'Solver tolerance';
        zef.h_ES_parameter_table.Data{14,2} = num2str(zef.ES_solver_tolerance);
         zef.h_ES_parameter_table.Data{15,1} = 'Display';
        zef.h_ES_parameter_table.Data{15,2} = num2str(zef.ES_display);

end

if ismember(zef.ES_search_type,4)
            
    zef.h_ES_search_method.Items = zef.ES_search_method_list([1 ]);
zef.h_ES_search_method.ItemsData = [1];

   zef.h_ES_algorithm.Items = zef.ES_algorithm_list([1 3 4]);
zef.h_ES_algorithm.ItemsData = [1 3 4];

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
        zef.h_ES_parameter_table.Data{7,1} = 'Threshold for non-zero currents';
        zef.h_ES_parameter_table.Data{7,2} = num2str(zef.ES_relative_weight_nnz);
        zef.h_ES_parameter_table.Data{8,1} = 'Maximum non-zero currents';
        zef.h_ES_parameter_table.Data{8,2} = num2str(zef.ES_score_dose);
        zef.h_ES_parameter_table.Data{9,1} = 'Lattice size';
        zef.h_ES_parameter_table.Data{9,2} = num2str(zef.ES_step_size);
        zef.h_ES_parameter_table.Data{10,1} = 'Targeted current density (A/m2)';
        zef.h_ES_parameter_table.Data{10,2} = num2str(zef.ES_source_density);
        zef.h_ES_parameter_table.Data{11,1} = 'Second-stage search threshold';
        zef.h_ES_parameter_table.Data{11,2} = num2str(zef.ES_acceptable_threshold);
        zef.h_ES_parameter_table.Data{12,1} = 'Boundary color limit';
        zef.h_ES_parameter_table.Data{12,2} = num2str(zef.ES_boundary_color_limit);
        zef.h_ES_parameter_table.Data{13,1} = 'ROI radius (mm)';
        zef.h_ES_parameter_table.Data{13,2} = num2str(zef.ES_roi_range);
        zef.h_ES_parameter_table.Data{14,1} = 'Solver tolerance';
        zef.h_ES_parameter_table.Data{14,2} = num2str(zef.ES_solver_tolerance);
        zef.h_ES_parameter_table.Data{15,1} = 'Maximum number of iterations';
        zef.h_ES_parameter_table.Data{15,2} = num2str(zef.ES_max_n_iterations);
        zef.h_ES_parameter_table.Data{16,1} = 'Maximum time (s)';
        zef.h_ES_parameter_table.Data{16,2} = num2str(zef.ES_max_time); 
         zef.h_ES_parameter_table.Data{17,1} = 'Display';
        zef.h_ES_parameter_table.Data{17,2} = num2str(zef.ES_display); 

end

if ismember(zef.ES_search_type,5)
            
    zef.h_ES_search_method.Items = zef.ES_search_method_list([1]);
zef.h_ES_search_method.ItemsData = [1];
 zef.h_ES_algorithm.Items = zef.ES_algorithm_list([1 3 4]);
zef.h_ES_algorithm.ItemsData = [1 3 4];

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
        zef.h_ES_parameter_table.Data{7,1} = 'Threshold for non-zero currents';
        zef.h_ES_parameter_table.Data{7,2} = num2str(zef.ES_relative_weight_nnz);
        zef.h_ES_parameter_table.Data{8,1} = 'Maximum non-zero currents';
        zef.h_ES_parameter_table.Data{8,2} = num2str(zef.ES_score_dose);
        zef.h_ES_parameter_table.Data{9,1} = 'Lattice size';
        zef.h_ES_parameter_table.Data{9,2} = num2str(zef.ES_step_size);
        zef.h_ES_parameter_table.Data{10,1} = 'Targeted current density (A/m2)';
        zef.h_ES_parameter_table.Data{10,2} = num2str(zef.ES_source_density);
        zef.h_ES_parameter_table.Data{11,1} = 'Second-stage search threshold';
        zef.h_ES_parameter_table.Data{11,2} = num2str(zef.ES_acceptable_threshold);
        zef.h_ES_parameter_table.Data{12,1} = 'Boundary color limit';
        zef.h_ES_parameter_table.Data{12,2} = num2str(zef.ES_boundary_color_limit);
        zef.h_ES_parameter_table.Data{13,1} = 'ROI radius (mm)';
        zef.h_ES_parameter_table.Data{13,2} = num2str(zef.ES_roi_range);
                 zef.h_ES_parameter_table.Data{14,1} = 'Solver tolerance';
        zef.h_ES_parameter_table.Data{14,2} = num2str(zef.ES_solver_tolerance);
        zef.h_ES_parameter_table.Data{15,1} = 'Maximum number of iterations';
        zef.h_ES_parameter_table.Data{15,2} = num2str(zef.ES_max_n_iterations);
        zef.h_ES_parameter_table.Data{16,1} = 'Maximum time (s)';
        zef.h_ES_parameter_table.Data{16,2} = num2str(zef.ES_max_time); 
         zef.h_ES_parameter_table.Data{17,1} = 'Display';
        zef.h_ES_parameter_table.Data{17,2} = num2str(zef.ES_display);
end

