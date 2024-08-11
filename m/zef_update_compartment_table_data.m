function zef = zef_update_compartment_table_data(zef)

if nargin == 0
    zef = evalin('base','zef');
end

zef.compartment_tags = fliplr(zef.compartment_tags);

for zef_i = 1 : length(zef.compartment_tags) 

    zef_j = zef_i;

    zef_init_fields_compartment_table

    zef_n = 0;
    for zef_k =  1 : size(zef.parameter_profile,1)
        if isequal(zef.parameter_profile{zef_k,8},'Segmentation') && isequal(zef.parameter_profile{zef_k,6},'On') && isequal(zef.parameter_profile{zef_k,7},'On')
            zef_n = zef_n + 1;
            zef.h_compartment_table.ColumnName{zef_n+zef.compartment_table_size} = zef.parameter_profile{zef_k,1};
            if isequal(zef.parameter_profile{zef_k,3},'Scalar')
                zef.aux_field_1{zef_i,zef_n+zef.compartment_table_size} = num2str(eval(['zef.' zef.compartment_tags{zef_i} '_' zef.parameter_profile{zef_k,2}]));
            elseif isequal(zef.parameter_profile{zef_k,3},'String')
                zef.aux_field_1{zef_i,zef_n + zef.compartment_table_size} = (eval(['zef.' zef.compartment_tags{zef_i} '_' zef.parameter_profile{zef_k,2} ]));
            end
        end
    end

end

zef.h_compartment_table.Data = zef.aux_field_1;

if size(zef.h_compartment_table.Data,2) > length(zef.h_compartment_table.ColumnEditable)
    missing_entries = (size(zef.h_compartment_table.Data,2) - length(zef.h_compartment_table.ColumnEditable));
    zef.h_compartment_table.ColumnEditable = [zef.h_compartment_table.ColumnEditable repmat(true,1,missing_entries)];
end

if size(zef.h_compartment_table.Data,2) > length(zef.h_compartment_table.ColumnWidth)
    missing_entries = (size(zef.h_compartment_table.Data,2) - length(zef.h_compartment_table.ColumnWidth));
    zef.h_compartment_table.ColumnWidth = [zef.h_compartment_table.ColumnWidth repmat({'fit'},1,missing_entries)];
end

zef.compartment_tags = fliplr(zef.compartment_tags);

if nargout == 0
    assignin('base','zef',zef);
end
