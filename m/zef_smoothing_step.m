
if zef.mesh_smoothing_on

    length_waitbar = 4+length(priority_vec);

    sensors = zef.sensors;

    smoothing_param = zef.smoothing_strength;
    smoothing_steps_surf = zef.smoothing_steps_surf;
    if length(smoothing_steps_surf) == 1
        smoothing_steps_surf = repmat([ 0 smoothing_steps_surf],1,zef.mesh_smoothing_repetitions);
    else
        smoothing_steps_surf = reshape([zeros(size(smoothing_steps_surf)) ;smoothing_steps_surf],1,2*length(smoothing_steps_surf));
    end
    smoothing_steps_vol =  zef.smoothing_steps_vol;
    if length(smoothing_steps_vol) == 1
        smoothing_steps_vol = repmat([smoothing_steps_vol smoothing_steps_vol],1,zef.mesh_smoothing_repetitions);
    else
        smoothing_steps_vol =  reshape([smoothing_steps_vol ;smoothing_steps_vol],1,2*length(smoothing_steps_vol));
    end
    smoothing_steps_ele = zef.smoothing_steps_ele;
    if length(smoothing_steps_ele) == 1
        smoothing_steps_ele = repmat([ 0 smoothing_steps_ele],1,zef.mesh_smoothing_repetitions);
    else
        smoothing_steps_ele = reshape([zeros(size(smoothing_steps_ele)) ;smoothing_steps_ele],1,2*length(smoothing_steps_ele));
    end

    for smoothing_repetition_ind  = 1 : 2*zef.mesh_smoothing_repetitions

        if zef.mesh_relabeling && smoothing_repetition_ind > 2

            if smoothing_repetition_ind == 1
                zef_segmentation_counter_step;
            elseif smoothing_repetition_ind > 1

                if zef.mesh_relabeling
                    pml_ind = [];
                    labeling_flag = 2;
                    label_ind = uint32(tetra);
                    zef_mesh_labeling_step;
                end

            end

        end

        N = size(nodes, 1);
        L = [];

        surface_triangles = [];
        J = [];
        for k = 1 : length(priority_vec)
            zef_waitbar(k/length_waitbar,h,'Smoothing operators.');
            if not(pml_vec(k))
                I = find(submesh_ind_1(domain_labels)==k);
                [surface_triangles] = [ surface_triangles ; zef_surface_mesh(tetra(I,:))];

                J = [J ; unique(surface_triangles)];
                K = unique(J);
            end
        end

        zef_waitbar((1+length(priority_vec))/length_waitbar,h,'Smoothing operators.');
        surface_triangles = sort(surface_triangles,2);
        surface_triangles = unique(surface_triangles,'rows');

        J = setdiff(tetra(:),K);

        zef_waitbar((2+length(priority_vec))/length_waitbar,h,'Smoothing operators.');

        smoothing_ok = 0;

        A = sparse(N, N, 0);
        B = sparse(N, N, 0);

        if mod(smoothing_repetition_ind,2)==0

            for i = 1 : 3
                for j = i+1 : 3
                    A_part = sparse(surface_triangles(:,i),surface_triangles(:,j),double(ones(size(surface_triangles,1),1)),N,N);
                    if i == j
                        A = A + A_part;
                    else
                        A = A + A_part ;
                        A = A + A_part';
                    end
                end
            end

            zef_waitbar((3+length(priority_vec))/length_waitbar,h,'Smoothing operators.');
            clear surface_triangles;

            clear A_part;
            A = spones(A);
            sum_A = full(sum(A(K,K)))';
            sum_A = sum_A(:,[1 1 1]);

            A_K = A(K,K);
            nodes(K,:) = nodes(K,:);

        end

        if smoothing_steps_vol(smoothing_repetition_ind) > 0
            for i = 1 : 4
                for j = i+1 : 4
                    B_part = sparse(tetra(:,i),tetra(:,j),ones(size(tetra,1),1),N,N);
                    if i == j
                        B = B + B_part;
                    else
                        B = B + B_part ;
                        B = B + B_part';
                    end
                end
            end

            outer_surface_nodes_aux = [];
            if zef.fix_outer_surface
                [outer_surface_nodes_aux] = zef_surface_mesh(tetra);
                outer_surface_nodes_aux = unique(outer_surface_nodes_aux);
            end

            zef_waitbar((4+length(priority_vec))/length_waitbar,h,'Smoothing operators.');
            clear B_part;
            B = spones(B);
            sum_B = full(sum(B))';
            sum_B = sum_B(:,[1 1 1]);
        end

        taubin_lambda = 1;
        taubin_mu = -1;

        if smoothing_steps_surf(smoothing_repetition_ind) > 0
            if smoothing_steps_surf(smoothing_repetition_ind) < 1
                convergence_criterion = Inf;
            else
                convergence_criterion =  smoothing_steps_surf(smoothing_repetition_ind).^2;
            end
            iter_ind_aux = 0;
            while convergence_criterion > smoothing_steps_surf(smoothing_repetition_ind)
                iter_ind_aux = iter_ind_aux + 1;
                nodes_aux = A_K*nodes(K,:);
                nodes_aux = nodes_aux./sum_A;
                nodes_aux_1 = nodes_aux - nodes(K,:);
                nodes(K,:) =  nodes(K,:) + taubin_lambda*smoothing_param*nodes_aux_1;
                nodes_aux = A_K*nodes(K,:);
                nodes_aux = nodes_aux./sum_A;
                nodes_aux_2 = nodes_aux - nodes(K,:);
                nodes(K,:) = nodes(K,:) + taubin_mu*smoothing_param*nodes_aux_2;
                if smoothing_steps_surf(smoothing_repetition_ind) < 1
                    convergence_criterion = norm(nodes_aux_2-nodes_aux_1,'fro')/norm(nodes_aux_1);
                else
                    convergence_criterion = smoothing_steps_surf(smoothing_repetition_ind).^2/iter_ind_aux;
                end
                zef_waitbar(smoothing_steps_surf(smoothing_repetition_ind)/convergence_criterion,h,'Surface smoothing.');

            end
        end

zef_waitbar(0,1,h,'Surface triangles.');
unique_domain_labels = unique(submesh_ind_1(domain_labels));
n_unique_domain_labels = length(unique_domain_labels);
surface_triangles = cell(0);
for zef_j = 1 : n_unique_domain_labels - 1
    zef_waitbar(zef_j,n_unique_domain_labels,h,'Surface triangles.');
I_aux = find(submesh_ind_1(domain_labels) <= unique_domain_labels(zef_j));
surface_triangles{unique_domain_labels(zef_j)} = double(zef_surface_mesh(tetra(I_aux,:)));
end

        electrode_is_point = zef.sensors;
  if size(electrode_is_point,2) == 3
                electrode_is_point = zeros(size(electrode_is_point,1),1);
            else
                electrode_is_point = find(electrode_is_point(:,4)==0);
            end

            if length(electrode_is_point) < size(zef.sensors,1)
                bypass_functions = 1;
        [sensors_attached_volume] = zef_attach_sensors_volume(zef,sensors,'mesh',{},nodes,tetra,surface_triangles, bypass_functions);
        L = zef_electrode_struct(sensors_attached_volume);
        if not(isempty(L))
           zef_waitbar((4+length(priority_vec)+((smoothing_steps_surf(smoothing_repetition_ind)+1)/(smoothing_steps_surf(smoothing_repetition_ind) + 1 + smoothing_steps_vol(smoothing_repetition_ind)))*20)/length_waitbar,h,'Mesh smoothing.');
            C = [];
            for electrode_ind = 1 : length(L)
                zef_waitbar(electrode_ind/length(L),h,'Sensor smoothing.');
                if not(ismember(electrode_ind,electrode_is_point))
                    C_sparse = sparse(N, N, 0);
                    for i = 1 : 2
                        for j = i : 2
                            C_part = sparse(L(electrode_ind).edges(:,i),L(electrode_ind).edges(:,j),double(ones(size(L(electrode_ind).edges,1),1)),N,N);
                            if i == j
                                C_sparse = C_sparse + C_part;
                            else
                                C_sparse = C_sparse + C_part ;
                                C_sparse = C_sparse + C_part';
                            end
                        end
                    end
                    C = full(C_sparse(L(electrode_ind).nodes,L(electrode_ind).nodes));
                    C_sum = sum(C)';
                    C_sum = C_sum(:,[1 1 1]);

                    if smoothing_steps_ele(smoothing_repetition_ind) > 0
                        if smoothing_steps_ele(smoothing_repetition_ind) < 1
                            convergence_criterion = Inf;
                        else
                            converge_criterion = smoothing_steps_ele(smoothing_repetition_ind).^2;
                        end
                        iter_ind_aux = 0;
                        while convergence_criterion > smoothing_steps_ele(smoothing_repetition_ind)
                            iter_ind_aux = iter_ind_aux + 1;
                            nodes_aux = C*nodes(L(electrode_ind).nodes,:);
                            nodes_aux = nodes_aux./C_sum;
                            nodes_aux_1 = nodes_aux - nodes(L(electrode_ind).nodes,:);
                            nodes(L(electrode_ind).nodes,:) =  nodes(L(electrode_ind).nodes,:) + taubin_lambda*smoothing_param*nodes_aux_1;
                            nodes_aux = C*nodes(L(electrode_ind).nodes,:);
                            nodes_aux = nodes_aux./C_sum;
                            nodes_aux_2 = nodes_aux - nodes(L(electrode_ind).nodes,:);
                            nodes(L(electrode_ind).nodes,:) =  nodes(L(electrode_ind).nodes,:) + taubin_mu*smoothing_param*nodes_aux_2;
                            if smoothing_steps_ele(smoothing_repetition_ind) < 1
                                convergence_criterion = norm(nodes_aux_2-nodes_aux_1,'fro')/norm(nodes_aux_1);
                            else
                                convergence_criterion = smoothing_steps_ele(smoothing_repetition_ind).^2/iter_ind_aux;
                            end
                        end
                    end
                end
            end
        end
            end

        if smoothing_steps_vol(smoothing_repetition_ind) > 0
            if smoothing_steps_vol(smoothing_repetition_ind) < 1
                convergence_criterion = Inf;
            else
                convergence_criterion = smoothing_steps_vol(smoothing_repetition_ind).^2;
            end
            iter_ind_aux = 0;
            while convergence_criterion > smoothing_steps_vol(smoothing_repetition_ind)
                iter_ind_aux = iter_ind_aux + 1;
                nodes_aux = B*nodes;
                nodes_aux = nodes_aux./sum_B;
                nodes_aux_1 = (nodes_aux -nodes);
                nodes = nodes + smoothing_param*taubin_lambda*nodes_aux_1;
                nodes_aux = B*nodes;
                nodes_aux = nodes_aux./sum_B;
                nodes_aux_2 = (nodes_aux -nodes);
                if not(isempty(outer_surface_nodes_aux))
                    nodes_aux(outer_surface_nodes_aux,:) = 0;
                end
                nodes = nodes + smoothing_param*taubin_mu*nodes_aux_2;
                if smoothing_steps_vol(smoothing_repetition_ind) < 1
                    convergence_criterion = norm(nodes_aux_2-nodes_aux_1,'fro')/norm(nodes_aux_1);
                else
                    convergence_criterion = smoothing_steps_vol(smoothing_repetition_ind).^2/iter_ind_aux;
                end
                zef_waitbar(smoothing_steps_vol(smoothing_repetition_ind)/convergence_criterion,h,'Volume smoothing.');
            end
        end

        nodes = gather(nodes);

        if zef.use_fem_mesh_inflation
            nodes = zef_inflate_surfaces(zef,nodes,tetra,submesh_ind_1(domain_labels));
        end

        optimizer_counter = 1;
        optimizer_flag = -1;
        while optimizer_flag < 0 && optimizer_counter <= zef.mesh_optimization_repetitions
            optimizer_counter = optimizer_counter + 1;
            [nodes,optimizer_flag] = zef_fix_negatives(zef,nodes, tetra);
            if optimizer_flag == 1
            [tetra, optimizer_flag] = zef_tetra_turn(zef,nodes, tetra, thresh_val);
            end
          
        end

        if optimizer_flag == -1
            smoothing_ok = 0;
        else
            smoothing_ok = 1;
        end

        if smoothing_ok == 0
            error('Mesh smoothing failed.');
        end

        tetra_aux = tetra;

    end

    clear nodes_aux;

    if optimizer_flag == -1;
        smoothing_ok = 0;
    else
        smoothing_ok = 1;
    end

    if smoothing_ok == 0
        error('Mesh smoothing failed.');
    end

    clear A B;

end
