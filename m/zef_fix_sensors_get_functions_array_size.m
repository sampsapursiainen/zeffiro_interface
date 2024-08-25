function zef = zef_fix_sensors_get_functions_array_size(zef)

if not(isfield(zef,[zef.current_sensors '_get_functions']))
zef.([zef.current_sensors '_get_functions']) = cell(0);
end
zef.([zef.current_sensors '_get_functions_aux']) = cell(1,size(zef.([zef.current_sensors '_points']),1));
zef.([zef.current_sensors '_get_functions_aux_ind']) = setdiff([1:size(zef.([zef.current_sensors '_get_functions']),2)],find(cellfun(@isempty, zef.([zef.current_sensors '_get_functions']))));
zef.([zef.current_sensors '_get_functions_aux'])(zef.([zef.current_sensors '_get_functions_aux_ind'])) = zef.([zef.current_sensors '_get_functions'])(zef.([zef.current_sensors '_get_functions_aux_ind']));
zef.([zef.current_sensors '_get_functions']) = zef.([zef.current_sensors '_get_functions_aux']);
zef = rmfield(zef,[zef.current_sensors '_get_functions_aux']);
zef = rmfield(zef,[zef.current_sensors '_get_functions_aux_ind']);

end