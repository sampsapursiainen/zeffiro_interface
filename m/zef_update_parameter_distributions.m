function zef = zef_update_parameter_distributions(zef)

parameter_profile = eval('zef.parameter_profile');

for zef_j = 1 : size(parameter_profile,1)
    if isequal(parameter_profile{zef_j,8},'Segmentation') && isequal(parameter_profile{zef_j,3},'Scalar') && isequal(parameter_profile{zef_j,6},'On')
        eval(['zef.' parameter_profile{zef_j,2} '= zeros(size(zef.domain_labels,1),2);']);
        eval(['zef.' parameter_profile{zef_j,2} '(:,2) = zef.domain_labels;';]);
        for zef_i = 1 : length(zef.compartment_tags)
            I = find(zef.domain_labels == zef_i);
            eval(['zef.' parameter_profile{zef_j,2} '(I,1) = zef.' zef.compartment_tags{zef_i} '_' parameter_profile{zef_j,2} ';']);
        end
    end
end

end
