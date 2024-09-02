function zef = zef_fix_sensors_get_functions_array_size(zef)

n_sensors = size(zef.([zef.current_sensors '_points']),1);
if isequal(n_sensors,0)
n_sensors = 1;
end

if not(isfield(zef,[zef.current_sensors '_get_functions']))
zef.([zef.current_sensors '_get_functions']) = cell(1,n_sensors);
end
zef.([zef.current_sensors '_get_functions_aux']) = cell(1,n_sensors);
zef.([zef.current_sensors '_get_functions_aux_ind']) = setdiff([1:size(zef.([zef.current_sensors '_get_functions']),2)],find(cellfun(@isempty, zef.([zef.current_sensors '_get_functions']))));
zef.([zef.current_sensors '_get_functions']) = zef.([zef.current_sensors '_get_functions_aux']);

zef = rmfield(zef,[zef.current_sensors '_get_functions_aux']);
zef = rmfield(zef,[zef.current_sensors '_get_functions_aux_ind']);

end