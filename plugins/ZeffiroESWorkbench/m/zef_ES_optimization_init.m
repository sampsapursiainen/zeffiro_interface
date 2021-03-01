zef.ES_inv_colormap = 10;
zef.ES_search_type = 1;
zef.ES_current_threshold_checkbox = 0;

if not(isfield(zef,'ES_plot_type'));
    zef.ES_plot_type = 1;
end;
if not(isfield(zef,'ES_search_type'));
    zef.ES_search_type = 1;
end;
if not(isfield(zef,'ES_volumetric_current_density')); 
    zef.ES_volumetric_current_density = []; 
end;
if not(isfield(zef,'ES_optimizer_tolerance'));
    zef.ES_optimizer_tolerance = 1E-02; 
end;
if not(isfield(zef,'ES_regularization_parameter')); 
    zef.ES_regularization_parameter = 0; 
end;
if not(isfield(zef,'ES_optimizer_tolerance_max'));
    zef.ES_optimizer_tolerance_max = 1E-10;
end;
if not(isfield(zef,'ES_regularization_parameter_max')); 
    zef.ES_regularization_parameter_max = 10; 
end;
if not(isfield(zef,'ES_current_threshold_checkbox'))
    zef.ES_current_threshold_checkbox = 0;
end;
if not(isfield(zef,'ES_current_threshold')); 
    zef.ES_current_threshold = 0.1; 
end;
if not(isfield(zef,'ES_active_electrodes')); 
    zef.ES_active_electrodes = [];
end
if not(isfield(zef,'ES_positivity_constraint')); 
    zef.ES_positivity_constraint = [];
end
if not(isfield(zef,'ES_negativity_constraint')); 
    zef.ES_negativity_constraint = [];
end
if not(isfield(zef,'ES_maximum_current')); 
    zef.ES_maximum_current = 0.002; 
end;
if not(isfield(zef,'y_ES')); 
    zef.y_ES = 0; 
end;
if not(isfield(zef,'ES_cortex_thickness')); 
    zef.ES_cortex_thickness = 4; 
end;
if not(isfield(zef,'ES_relative_source_amplitude')); 
    zef.ES_relative_source_amplitude = 0.26; 
end;
if not(isfield(zef,'ES_source_density')); 
    zef.ES_source_density = 0.77; 
end;
if not(isfield(zef,'ES_inv_colormap'));
    zef.ES_inv_colormap = 10;
end