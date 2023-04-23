function zef = zef_nse_interpolate(zef,type)

if ismember(type,[1 2 3 5 6 7 8 9 10 11 12 13])
    
        for i = 1 : length(zef.compartment_tags)
        eval(['zef.' zef.compartment_tags{i} '_sources = 0;'])
    end
    
    
    for i = 1 : length(zef.nse_field.artery_domain_ind)
     eval(['zef.' zef.compartment_tags{zef.nse_field.artery_domain_ind(i)} '_sources = 1;']) 
    end

    zef = zef_build_compartment_table(zef);
    
   zef.active_compartment_ind = find(ismember(zef.domain_labels,zef.nse_field.artery_domain_ind));
    zef.source_positions = zef.nodes(zef.nse_field.bp_vessel_node_ind,:);
    
elseif ismember(type,[4 14 15 16])

    for i = 1 : length(zef.compartment_tags)
        eval(['zef.' zef.compartment_tags{i} '_sources = 0;'])
    end
    
    
    for i = 1 : length(zef.nse_field.capillary_domain_ind)
     eval(['zef.' zef.compartment_tags{zef.nse_field.capillary_domain_ind(i)} '_sources = 1;']) 
    end

    zef = zef_build_compartment_table(zef);
    
    zef.active_compartment_ind = find(ismember(zef.domain_labels,zef.nse_field.capillary_domain_ind));
 zef.source_positions = zef.nodes(zef.nse_field.bf_capillary_node_ind,:);
    
    end

    zef = zef_source_interpolation(zef);
    
end