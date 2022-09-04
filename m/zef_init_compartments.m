 zef.h_compartment_table.Data = [];

zef.compartment_tags = cell(0);
zef.compartment_transform_name = cell(0);
zef.compartment_structure_aux = cell(0);

if not(zef.new_empty_project)

zef.segmentation_profile_aux = readcell([zef.program_path '/profile/' zef.profile_name  '/zeffiro_segmentation.ini'],'filetype','text','delimiter',',');
[zef_i] = find(ismember(char(zef.segmentation_profile_aux{:,2}),{'compartment_tags'}));

zef.compartment_tags_aux = zef.segmentation_profile_aux(zef_i,4:end);

for zef_i = 1 : length(zef.compartment_tags_aux)

    zef.compartment_structure_aux = cell(0);
    zef_k = 0;
    for zef_j = 1 : size(zef.segmentation_profile_aux,1)
        if not(isequal(zef.segmentation_profile_aux{zef_j,2},'compartment_tags'))
            zef_k = zef_k + 1;
            if not(isstring(zef.segmentation_profile_aux{zef_j,zef_i + 3}))
                zef.compartment_structure_aux{zef_k} = {zef.segmentation_profile_aux{zef_j,2}, num2str(zef.segmentation_profile_aux{zef_j,zef_i+3})};
            end
            if isequal(zef.segmentation_profile_aux{zef_j,3},'string')
            zef.compartment_structure_aux{zef_k} = {zef.segmentation_profile_aux{zef_j,2}, ['''' zef.segmentation_profile_aux{zef_j,zef_i+3} '''']};
            end
        end

    end

    zef = zef_create_compartment(zef,zef.compartment_tags_aux{zef_i},'zef',zef.compartment_structure_aux);

end

zef = rmfield(zef,{'segmentation_profile_aux','compartment_structure_aux','compartment_tags_aux'});

clear zef_i zef_j zef_k;

end
