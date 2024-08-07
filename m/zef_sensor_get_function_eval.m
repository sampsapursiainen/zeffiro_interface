function [contacts, sensor_info, triangle_index] = zef_sensor_get_function_eval(function_string, project_struct, domain_type)

[contacts, sensor_info, triangle_index] = feval(@(project_struct, domain_type)evalin('caller',function_string),project_struct, domain_type);

end