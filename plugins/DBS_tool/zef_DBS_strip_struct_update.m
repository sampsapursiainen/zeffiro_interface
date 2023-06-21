function zef = zef_DBS_strip_struct_update(zef)
    if zef.strip_struct.strip_type == 1
        zef = zef_electrode_strip_multiple_probe(zef);
    elseif zef.strip_struct.strip_type == 2
        zef = zef_Abbott_infinity_strip_multiple_probe(zef);
    end
end