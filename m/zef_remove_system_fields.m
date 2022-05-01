zef.system_fields = {'compartment_activity','start_mode','colormap_cell'};
for zef_i  =  1 : length(zef.system_fields)
if isfield(zef_data,zef.system_fields{zef_i});
zef_data = rmfield(zef_data,zef.system_fields{zef_i});
end
end
