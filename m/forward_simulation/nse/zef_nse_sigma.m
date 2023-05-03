function sigma_out = zef_nse_sigma(nse_field,nodes,tetra,domain_labels,sigma_in,s_interp_ind, singular_threshold)

arguments

    nse_field (1,1) struct

    nodes (:,3) double

    tetra (:,4) double

    domain_labels (:,1) int64

    sigma_in (:,2) double

    s_interp_ind (:,4) uint64 { mustBePositive }

    singular_threshold (1,1) double { mustBePositive, mustBeLessThan ( singular_threshold, 1e-2 ) } = eps(1)

end

assert( numel(domain_labels) == size(tetra, 1), "The numbers of domain labels and tetrahedra do not match. Aborting..." );

assert( size(sigma_in,1) == size(tetra, 1), "The numbers of conductivities and tetrahedra do not match. Aborting..." );

mm_conversion = 0.001;

% Preallocate the conductivity matrix. Each column corresponds to a time
% frame.

sigma_out = repmat(sigma_in(:,1), 1, nse_field.n_frames);

% Go over the time frames.

for tfi = 1 : nse_field.n_frames

    disp("  σ-frame " + tfi + "...")

    bf_interp = mean(abs(nse_field.bf_capillaries{tfi}(s_interp_ind)),2);

    active_compartment_ind = find(ismember(domain_labels,nse_field.capillary_domain_ind));

    domain_labels_aux = domain_labels(active_compartment_ind);

    [v_nodes, v_tetra, nse_field.bf_capillary_node_ind] = zef_get_submesh(nodes, tetra, active_compartment_ind);

    v_nodes = mm_conversion*v_nodes;

    [~, determinant] = zef_volume_barycentric(v_nodes,v_tetra);

    volume = abs(determinant)/6;

    sigma_aux = sigma_in(active_compartment_ind,1);

    if isequal(nse_field.conductivity_model,1)

        for i = 1 : length(nse_field.capillary_domain_ind)

            I = find(domain_labels_aux == nse_field.capillary_domain_ind(i));

            I_aux = find(abs(bf_interp(I))> singular_threshold);

            I = I(I_aux);

            I_aux = find(abs(bf_interp(I)) > 1-singular_threshold);

            sigma_out(I_aux, tfi) = nse_field.blood_conductivity;

            I_aux = find(abs(bf_interp(I)) > 1-singular_threshold);

            bf_interp(I(I_aux)) = 1-singular_threshold;

            I_aux = find(abs(bf_interp(I)) <= 1);

            I = I(I_aux);

            volume_aux = sum(volume(I));

            background_conductivity = sum(sigma_aux(I).*volume(I))./volume_aux;

            m = nse_field.conductivity_exponent;

            s = log(1-bf_interp(I).^m)./log(1-bf_interp(I));

            sigma_out(active_compartment_ind(I),tfi) = (1-bf_interp(I)).^s.*background_conductivity + nse_field.blood_conductivity .* bf_interp(I).^m;

        end % for

    elseif isequal(nse_field.conductivity_model,2)

        for i = 1 : length(nse_field.capillary_domain_ind)

            I = find(domain_labels_aux == nse_field.capillary_domain_ind(i));

            volume_aux = sum(volume(I));

            background_conductivity = sum(sigma_aux(I).*volume(I))./volume_aux;

            sigma_out(active_compartment_ind(I),1) = background_conductivity.*(1-bf_interp(I)) + nse_field.blood_conductivity.*(bf_interp(I));

        end

    elseif isequal(nse_field.conductivity_model,3)

        for i = 1 : length(nse_field.capillary_domain_ind)

            I = find(domain_labels_aux == nse_field.capillary_domain_ind(i));

            I_aux = find(abs(bf_interp(I))> singular_threshold);

            I = I(I_aux);

            I_aux = find(abs(bf_interp(I)) > 1-singular_threshold);

            sigma_out(I_aux,1) = nse_field.blood_conductivity;

            I_aux = find(abs(bf_interp(I)) > 1-singular_threshold);

            bf_interp(I(I_aux)) = 1-singular_threshold;

            I_aux = find(abs(bf_interp(I)) <= 1);

            I = I(I_aux);

            volume_aux = sum(volume(I));

            background_conductivity = sum(sigma_aux(I).*volume(I))./volume_aux;

            sigma_out(active_compartment_ind(I),1) = background_conductivity.*(1 + (3.*bf_interp(I).*(nse_field.blood_conductivity-background_conductivity))./(3.*background_conductivity + (1 - bf_interp(I)).*(nse_field.blood_conductivity-background_conductivity)));

            %sigma_out(active_compartment_ind(I),1) = 1./(background_conductivity./(1-bf_interp(I)) + nse_field.blood_conductivity./bf_interp(I));

        end

    elseif isequal(nse_field.conductivity_model,4)

        for i = 1 : length(nse_field.capillary_domain_ind)

            I = find(domain_labels_aux == nse_field.capillary_domain_ind(i));

            volume_aux = sum(volume(I));

            background_conductivity = sum(sigma_aux(I).*volume(I))./volume_aux;

            sigma_out(active_compartment_ind(I),1) = (nse_field.blood_conductivity + (background_conductivity - nse_field.blood_conductivity).*(1-(2.*bf_interp(I)./3)))./(1 + (bf_interp(I)./3).*(background_conductivity./nse_field.blood_conductivity-1));

        end

    else

        error("Uknown conductivity model. Aborting...")

    end % if

end % for

end % function
