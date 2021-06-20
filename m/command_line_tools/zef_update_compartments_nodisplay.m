zef.aux_field_2 = zeros(length(zef.compartment_tags),1);


for zef_i = 1 : length(zef.compartment_tags)
    
    zef.aux_field_2(zef_i) =  evalin('base',['zef.' zef.compartment_tags{zef_i} '_priority']);  
   
end

[~, zef.aux_field_2] = sort(zef.aux_field_2);
zef.compartment_tags = zef.compartment_tags(zef.aux_field_2);
zef.compartment_tags = fliplr(zef.compartment_tags);

zef = rmfield(zef,'aux_field_2');