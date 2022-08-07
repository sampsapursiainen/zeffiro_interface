if ismember(zef.ES_search_type,1)
    
    if not(isequal(zef.ES_search_method,4))
        zef.ES_alpha        = 10^(str2double(zef.h_ES_parameter_table.Data{1,2})/20);
        zef.ES_alpha_max    = 10^(str2double(zef.h_ES_parameter_table.Data{2,2})/20);
            zef.ES_beta_min = 10^(str2double(zef.h_ES_parameter_table.Data{3,2})/20);
            zef.ES_beta     = 10^(str2double(zef.h_ES_parameter_table.Data{4,2})/20);
        zef.ES_total_max_current            = str2double(zef.h_ES_parameter_table.Data{5,2});
        zef.ES_max_current_channel          = str2double(zef.h_ES_parameter_table.Data{6,2});
        zef.ES_relative_weight_nnz          = str2double(zef.h_ES_parameter_table.Data{7,2});
        zef.ES_score_dose                   = str2double(zef.h_ES_parameter_table.Data{8,2});
        zef.ES_step_size                    = str2double(zef.h_ES_parameter_table.Data{9,2});
        zef.ES_source_density               = str2double(zef.h_ES_parameter_table.Data{10,2});
        zef.ES_acceptable_threshold         = str2double(zef.h_ES_parameter_table.Data{11,2});
        zef.ES_boundary_color_limit         = str2double(zef.h_ES_parameter_table.Data{12,2});
        zef.ES_roi_range                    = str2double(zef.h_ES_parameter_table.Data{13,2});
        zef.ES_solver_tolerance                   = str2double(zef.h_ES_parameter_table.Data{14,2});
            zef.ES_max_n_iterations                  = str2double(zef.h_ES_parameter_table.Data{15,2});
        zef.ES_algorithm = zef.h_ES_parameter_table.Data{16,2};
    zef.ES_step_tolerance = str2double(zef.h_ES_parameter_table.Data{17,2});
    zef.ES_constraint_tolerance = str2double(zef.h_ES_parameter_table.Data{18,2});
 zef.ES_max_time = str2double(zef.h_ES_parameter_table.Data{19,2});
  zef.ES_display = (zef.h_ES_parameter_table.Data{20,2});
    else
         zef.ES_total_max_current            = str2double(zef.h_ES_parameter_table.Data{1,2});
        zef.ES_max_current_channel          = str2double(zef.h_ES_parameter_table.Data{2,2});
        zef.ES_relative_weight_nnz          = str2double(zef.h_ES_parameter_table.Data{3,2});
        zef.ES_score_dose                   = str2double(zef.h_ES_parameter_table.Data{4,2});
         zef.ES_boundary_color_limit         = str2double(zef.h_ES_parameter_table.Data{5,2});
        zef.ES_roi_range                    = str2double(zef.h_ES_parameter_table.Data{6,2});
    end
 
end

if ismember(zef.ES_search_type,2)
   zef.ES_alpha        = 10^(str2double(zef.h_ES_parameter_table.Data{1,2})/20);
        zef.ES_alpha_max    = 10^(str2double(zef.h_ES_parameter_table.Data{2,2})/20);
            zef.ES_beta_min = 10^(str2double(zef.h_ES_parameter_table.Data{3,2})/20);
            zef.ES_beta     = 10^(str2double(zef.h_ES_parameter_table.Data{4,2})/20);
        zef.ES_total_max_current            = str2double(zef.h_ES_parameter_table.Data{5,2});
        zef.ES_max_current_channel          = str2double(zef.h_ES_parameter_table.Data{6,2});
        zef.ES_relative_weight_nnz          = str2double(zef.h_ES_parameter_table.Data{7,2});
        zef.ES_score_dose                   = str2double(zef.h_ES_parameter_table.Data{8,2});
        zef.ES_step_size                    = str2double(zef.h_ES_parameter_table.Data{9,2});
        zef.ES_source_density               = str2double(zef.h_ES_parameter_table.Data{10,2});
        zef.ES_acceptable_threshold         = str2double(zef.h_ES_parameter_table.Data{11,2});
        zef.ES_boundary_color_limit         = str2double(zef.h_ES_parameter_table.Data{12,2});
        zef.ES_roi_range                    = str2double(zef.h_ES_parameter_table.Data{13,2});
        zef.ES_solver_tolerance                   = str2double(zef.h_ES_parameter_table.Data{14,2});
 zef.ES_display = (zef.h_ES_parameter_table.Data{15,2});

end

if ismember(zef.ES_search_type,3)
    
      zef.ES_alpha        = 10^(str2double(zef.h_ES_parameter_table.Data{1,2})/20);
        zef.ES_alpha_max    = 10^(str2double(zef.h_ES_parameter_table.Data{2,2})/20);
            zef.ES_beta_min = 10^(str2double(zef.h_ES_parameter_table.Data{3,2})/20);
            zef.ES_beta     = 10^(str2double(zef.h_ES_parameter_table.Data{4,2})/20);
        zef.ES_total_max_current            = str2double(zef.h_ES_parameter_table.Data{5,2});
        zef.ES_max_current_channel          = str2double(zef.h_ES_parameter_table.Data{6,2});
        zef.ES_relative_weight_nnz          = str2double(zef.h_ES_parameter_table.Data{7,2});
        zef.ES_score_dose                   = str2double(zef.h_ES_parameter_table.Data{8,2});
        zef.ES_step_size                    = str2double(zef.h_ES_parameter_table.Data{9,2});
        zef.ES_source_density               = str2double(zef.h_ES_parameter_table.Data{10,2});
        zef.ES_acceptable_threshold         = str2double(zef.h_ES_parameter_table.Data{11,2});
        zef.ES_boundary_color_limit         = str2double(zef.h_ES_parameter_table.Data{12,2});
        zef.ES_roi_range                    = str2double(zef.h_ES_parameter_table.Data{13,2});
        zef.ES_solver_tolerance                   = str2double(zef.h_ES_parameter_table.Data{14,2});
    zef.ES_display = (zef.h_ES_parameter_table.Data{15,2});
    
        
end

% if ismember(zef.ES_search_type,4)
%     
%         zef.ES_alpha        = 10^(str2double(zef.h_ES_parameter_table.Data{1,2})/20);
%         zef.ES_alpha_max    = 10^(str2double(zef.h_ES_parameter_table.Data{2,2})/20);
%             zef.ES_beta_min = 10^(str2double(zef.h_ES_parameter_table.Data{3,2})/20);
%             zef.ES_beta     = 10^(str2double(zef.h_ES_parameter_table.Data{4,2})/20);
%         zef.ES_total_max_current            = str2double(zef.h_ES_parameter_table.Data{5,2});
%         zef.ES_max_current_channel          = str2double(zef.h_ES_parameter_table.Data{6,2});
%         zef.ES_relative_weight_nnz          = str2double(zef.h_ES_parameter_table.Data{7,2});
%         zef.ES_score_dose                   = str2double(zef.h_ES_parameter_table.Data{8,2});
%         zef.ES_step_size                    = str2double(zef.h_ES_parameter_table.Data{9,2});
%         zef.ES_source_density               = str2double(zef.h_ES_parameter_table.Data{10,2});
%         zef.ES_relative_source_amplitude    = str2double(zef.h_ES_parameter_table.Data{11,2});
%         zef.ES_acceptable_threshold         = str2double(zef.h_ES_parameter_table.Data{12,2});
%         zef.ES_boundary_color_limit         = str2double(zef.h_ES_parameter_table.Data{13,2});
%         zef.ES_roi_range                    = str2double(zef.h_ES_parameter_table.Data{14,2});
%            zef.ES_max_n_iterations                  = str2double(zef.h_ES_parameter_table.Data{15,2});
%     zef.ES_absolute_tolerance = str2double(zef.h_ES_parameter_table.Data{16,2});
%     zef.ES_relative_tolerance = str2double(zef.h_ES_parameter_table.Data{17,2});
%  zef.ES_max_time = str2double(zef.h_ES_parameter_table.Data{18,2}); 
%   zef.ES_display = (zef.h_ES_parameter_table.Data{19,2});
%  
% end


if ismember(zef.ES_search_type,4)
    
        zef.ES_alpha        = 10^(str2double(zef.h_ES_parameter_table.Data{1,2})/20);
        zef.ES_alpha_max    = 10^(str2double(zef.h_ES_parameter_table.Data{2,2})/20);
            zef.ES_beta_min = 10^(str2double(zef.h_ES_parameter_table.Data{3,2})/20);
            zef.ES_beta     = 10^(str2double(zef.h_ES_parameter_table.Data{4,2})/20);
        zef.ES_total_max_current            = str2double(zef.h_ES_parameter_table.Data{5,2});
        zef.ES_max_current_channel          = str2double(zef.h_ES_parameter_table.Data{6,2});
        zef.ES_relative_weight_nnz          = str2double(zef.h_ES_parameter_table.Data{7,2});
        zef.ES_score_dose                   = str2double(zef.h_ES_parameter_table.Data{8,2});
        zef.ES_step_size                    = str2double(zef.h_ES_parameter_table.Data{9,2});
        zef.ES_source_density               = str2double(zef.h_ES_parameter_table.Data{10,2});
        zef.ES_acceptable_threshold         = str2double(zef.h_ES_parameter_table.Data{11,2});
        zef.ES_boundary_color_limit         = str2double(zef.h_ES_parameter_table.Data{12,2});
        zef.ES_roi_range                    = str2double(zef.h_ES_parameter_table.Data{13,2});
 zef.ES_solver_tolerance = str2double(zef.h_ES_parameter_table.Data{14,2}); 
  zef.ES_max_n_iterations = str2double(zef.h_ES_parameter_table.Data{15,2});
  zef.ES_algorithm =  (zef.h_ES_parameter_table.Data{16,2});
 zef.ES_max_time = str2double(zef.h_ES_parameter_table.Data{17,2});
 zef.ES_display =  (zef.h_ES_parameter_table.Data{18,2});
 
end

if ismember(zef.ES_search_type,5)
    
        zef.ES_alpha        = 10^(str2double(zef.h_ES_parameter_table.Data{1,2})/20);
        zef.ES_alpha_max    = 10^(str2double(zef.h_ES_parameter_table.Data{2,2})/20);
            zef.ES_beta_min = 10^(str2double(zef.h_ES_parameter_table.Data{3,2})/20);
            zef.ES_beta     = 10^(str2double(zef.h_ES_parameter_table.Data{4,2})/20);
        zef.ES_total_max_current            = str2double(zef.h_ES_parameter_table.Data{5,2});
        zef.ES_max_current_channel          = str2double(zef.h_ES_parameter_table.Data{6,2});
        zef.ES_relative_weight_nnz          = str2double(zef.h_ES_parameter_table.Data{7,2});
        zef.ES_score_dose                   = str2double(zef.h_ES_parameter_table.Data{8,2});
        zef.ES_step_size                    = str2double(zef.h_ES_parameter_table.Data{9,2});
        zef.ES_source_density               = str2double(zef.h_ES_parameter_table.Data{10,2});
        zef.ES_acceptable_threshold         = str2double(zef.h_ES_parameter_table.Data{11,2});
        zef.ES_boundary_color_limit         = str2double(zef.h_ES_parameter_table.Data{12,2});
        zef.ES_roi_range                    = str2double(zef.h_ES_parameter_table.Data{13,2});
 zef.ES_solver_tolerance = str2double(zef.h_ES_parameter_table.Data{14,2}); 
  zef.ES_max_n_iterations = str2double(zef.h_ES_parameter_table.Data{15,2});
  zef.ES_algorithm =  (zef.h_ES_parameter_table.Data{16,2});
 zef.ES_max_time = str2double(zef.h_ES_parameter_table.Data{17,2});
 zef.ES_display =  (zef.h_ES_parameter_table.Data{18,2});
end

