[zef.file,zef.file_path] = uigetfile({'*.dat;*.mat'});

if not(isequal(zef.file,0))

zef.aux_field_1 = load([zef.file_path '/' zef.file]);
zef.aux_field_2 = [];

if isstruct(zef.aux_field_1)
    zef.aux_field_2 = fieldnames(zef.aux_field_1);
    zef.resection_points = zef.aux_field_1.(zef.aux_field_2{1});
else
    zef.resection_points = zef.aux_field_1;
end

zef = rmfield(zef,{'aux_field_1','aux_field_2'});

end
