function strip_struct = zef_get_strip_parameters(strip_struct)

if isequal(strip_struct.strip_model,1)
strip_struct.strip_radius = 0.635;
strip_struct.strip_n_contacts = 4;
elseif isequal(strip_struct.strip_model,2)
strip_struct.strip_radius = 0.635;
strip_struct.strip_n_contacts = 8;
elseif isequal(strip_struct.strip_model,3)
strip_struct.strip_radius = 0.635;
strip_struct.strip_n_contacts = 40;
end

end


