if zef.current_version <= 2.2
     for zef_i = 1 : 22
 evalin('base',['zef.d' num2str(zef_i) '_priority =' num2str(28-zef_i) ';']);
     end
 end
clear zef_i

if zef.current_version < 4

    if isempty(zef.active_compartment_ind) &&  isfield(zef,'brain_ind')
        zef.active_compartment_ind = zef.brain_ind;
    end

    if isfield(zef,'sigma_ind') && isempty(zef.domain_labels_raw)
    zef.domain_labels_raw = zef.sigma_ind;
    end

    if isfield(zef,'sigma') && isempty(zef.domain_labels)
        if not(isempty(zef.sigma))
    zef.domain_labels= zef.sigma(:,2);
        end
    end

    if isfield(zef,'nodes_b') && isempty(zef.nodes_raw)
    zef.nodes_raw = zef.nodes_b;
    end

    if isfield(zef,'tetra_aux') && isempty(zef.tetra_raw)
    zef.tetra_raw = zef.tetra_aux;
    end

end
