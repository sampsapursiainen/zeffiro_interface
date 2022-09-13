function self = label_mesh(self, labeling_mode)

    % label_mesh
    %
    % Determines which tetra and nodes belong to which volumetric compartment.
    %
    % Inputs:
    %
    % - self
    %
    %   The instance of Zef calling this method.
    %
    % - labeling_mode (optional)
    %
    %   The mode in which the labeling is to be performed. Must be in
    %   {"initial", "repeated", "adaptive-repeated"}.
    %
    %   default = "initial"
    %
    % Outputs
    %
    % - self
    %
    %   The instance of Zef that called this method.

    arguments

        self zef_as_class.Zef

        labeling_mode (1,1) string { mustBeMember(labeling_mode, ["initial", "repeated", "adaptive-repeated"]) } = "initial";

    end

    % Read and write needed initial values.

    nodes = self.nodes;

    tetra = self.tetra;

    label_ind = uint32(self.label_ind);

    self.labeling_mode = labeling_mode;

    labeling_mode = self.labeling_mode;

    n_compartments = self.n_compartments;

    % Initialize waitbar and cleanup object.

    n_of_iterations = length(self.compartments);

    if self.use_gui

        wb = waitbar(0, "Mesh labeling.");

        cu_fn = @(h) close(h);

        cu_obj = onCleanup(@() cu_fn(wb));

    else

        wb = zef_as_class.TerminalWaitbar("Mesh labeling", n_of_iterations);

    end


    if isequal(labeling_mode, "initial")

        %***********************************************************
        %Initialize labeling.
        %***********************************************************

        I = zeros(size(nodes,1), 1);

        I_2 = [1 : length(I)]';

        compartment_counter = 0;

        pml_counter = 0;

        for i_labeling = 1 : length(self.compartments)

            if self.use_gui

                waitbar(i_labeling/n_of_iterations, wb, 'Mesh labeling.');

            else

                wb = wb.progress();

            end

            compartment = self.compartments(i_labeling);

            for k_labeling = 1 : max(1,length(compartment.submesh_ind))

                compartment_counter = compartment_counter + 1;

                if isempty(compartment.submesh_ind)

                    reuna_t_aux = compartment.triangles;

                else

                    if k_labeling == 1

                        reuna_t_aux = compartment.triangles(1:compartment.submesh_ind,:);

                    else

                        reuna_t_aux = compartment.triangles(compartment.submesh_ind(k_labeling-1)+1: compartment.submesh_ind(k_labeling),:);

                    end

                end % if

                if not(isequal(i_labeling, self.data.pml_ind_aux))

                    I_1 = point_in_compartment( ...
                        self, ...
                        compartment.points, ...
                        reuna_t_aux, ...
                        nodes(I_2,:), ...
                        compartment_counter, ...
                        n_compartments ...
                    );

                    I(I_2(I_1)) = compartment_counter;

                    I_2 = find(I==0);

                else

                    pml_counter = compartment_counter;

                    if not(isempty(self.data.pml_ind))
                        I(self.data.pml_ind) = pml_counter;
                    end

                end % if

            end % for

        end % for

        if not(isempty(self.data.pml_ind_aux))
            I(find(I==0)) = pml_counter;
        end

        I_1 = find(sum(sign(I(label_ind)),2)>=size(label_ind,2));

        tetra = tetra(I_1,:);

        label_ind = label_ind(I_1,:);

        domain_labels = I(label_ind);

        [unique_vec_1, ~, unique_vec_3] = unique(tetra);

        tetra = reshape(unique_vec_3,size(tetra));

        nodes = nodes(unique_vec_1,:);

    elseif isequal(labeling_mode, "repeated")

        %**************************************************************
        %Re-labeling.
        %**************************************************************

        compartment_counter = 0;
        pml_counter = 0;
        max_compartments = max(domain_labels);

        unique_domain_labels = unique(domain_labels);

        for i_labeling = 1 : length(self.compartments)

            if self.use_gui

                waitbar(i_labeling/n_of_iterations, wb, 'Mesh labeling.');

            else

                wb = wb.progress();

            end

            compartment = self.compartments(i_labeling);

            for k_labeling = 1 : max(1,length(compartment.submesh_ind))

            compartment_counter = compartment_counter + 1;

            domain_label_ind = find(ismember(unique_domain_labels,compartment_counter));

                if domain_label_ind

                    if compartment_counter == max_compartments
                        break
                    end

                    if isempty(compartment.submesh_ind)

                        reuna_t_aux = compartment.triangles;

                    else

                        if k_labeling == 1
                            reuna_t_aux = compartment.triangles(1:compartment.submesh_ind,:);
                        else
                            reuna_t_aux = compartment.triangles(compartment.submesh_ind(k_labeling-1)+1: compartment.submesh_ind(k_labeling),:);
                        end

                    end % if

                    tetra_ind_aux = 0;
                    test_ind = -ones(size(nodes,1),1);

                    while not(isempty(tetra_ind_aux))

                        I_1 = find(domain_labels <= compartment_counter);
                        [I_2] = self.surface_mesh(label_ind(I_1,:));
                        I_1 = setdiff([1:size(domain_labels,1)]',I_1);
                        [I_2, ~] = find(ismember(label_ind(I_1,:),I_2));
                        I_3 = label_ind(I_1(I_2),:);
                        [I_4,~,I_5] = unique(I_3);
                        I_6 = find(test_ind(I_4) < 0);
                        I_7 = point_in_compartment( ...
                            self, ...
                            compartment.points, ...
                            reuna_t_aux, ...
                            nodes(I_4(I_6),:), ...
                            compartment_counter, ...
                            n_compartments ...
                        );
                        test_ind(I_4(I_6)) = 0;
                        test_ind(I_4(I_6(I_7))) = 1;
                        I_5 = reshape(test_ind(I_4(I_5)),size(I_3));
                        tetra_ind_aux = I_1(I_2(find(sum(I_5,2)>=4)));
                        domain_labels(tetra_ind_aux) = min(max_compartments, unique_domain_labels(domain_label_ind));

                    end

                    if self.data.reduce_labeling_outliers

                        I_3 = 0;

                        while not(isempty(I_3)) && compartment_counter < max_compartments

                            I_1 = find(domain_labels <= compartment_counter);
                            [~,~,I_2] = self.surface_mesh(label_ind(I_1,:));
                            I_3 = accumarray(I_2,ones(size(I_2)),[size(I_1,1) 1]);
                            I_3 = find(I_3 >1);
                            domain_labels(I_1(I_3)) = compartment_counter+1;

                        end

                        I_3 = 0;

                        while not(isempty(I_3)) && compartment_counter < max_compartments

                            I_1 = find(domain_labels <= compartment_counter);
                            [~,~,~,~,I_2] = self.surface_mesh(label_ind,[],I_1);
                            I_2 = I_2(find(I_2));
                            I_3 = accumarray(I_2,ones(size(I_2)),[size(domain_labels,1) 1]);
                            I_3 = find(I_3 >= 3);
                            domain_labels(I_3) = compartment_counter;

                        end % while

                    end % if

                end % if

            end % for

        end % for

    elseif isequal(labeling_mode, "adaptive-repeated")

        %**************************************************************
        %Re-labeling (adaptive).
        %**************************************************************

        compartment_counter = 0;
        pml_counter = 0;
        max_compartments = max(domain_labels);

        unique_domain_labels = unique(domain_labels);

        for i_labeling = 1 : length(self.compartments)

            if self.use_gui

                waitbar(i_labeling/n_of_iterations, wb, 'Mesh labeling.');

            else

                wb = wb.progress();

            end

            compartment = self.compartments(i_labeling);

            for k_labeling = 1 : max(1,length(compartment.submesh_ind))

                compartment_counter = compartment_counter + 1;

                domain_label_ind = find(ismember(unique_domain_labels,compartment_counter));

                if domain_label_ind

                    if compartment_counter == max_compartments
                        break
                    end

                    if isempty(compartment.submesh_ind)

                        reuna_t_aux = compartment.triangles;

                    else

                        if k_labeling == 1

                            reuna_t_aux = compartment.triangles(1:compartment.submesh_ind,:);

                        else

                            reuna_t_aux = compartment.triangles(compartment.submesh_ind(k_labeling-1)+1: compartment.submesh_ind(k_labeling),:);

                        end

                    end % if

                    tetra_ind_aux = 0;
                    test_ind = -ones(size(nodes,1),1);
                    loop_steps = 0;

                    while not(isempty(tetra_ind_aux))

                        I_1_0 = find(domain_labels <= compartment_counter);
                        I_1 = intersect(I_1_0,tetra_refine_ind);

                        if isempty(I_1)

                            tetra_ind_aux = [];

                        else

                            loop_steps = loop_steps + 1;
                            [I_2] = self.surface_mesh(label_ind(I_1,:));
                            I_1 = setdiff([1:size(domain_labels,1)]',I_1);
                            [I_2, ~] = find(ismember(label_ind(I_1,:),I_2));
                            I_3 = label_ind(I_1(I_2),:);
                            [I_4,~,I_5] = unique(I_3);
                            I_6 = find(test_ind(I_4) < 0);
                            I_7 = point_in_compartment( ...
                                self, ...
                                compartment.points, ...
                                reuna_t_aux, ...
                                nodes(I_4(I_6),:), ...
                                compartment_counter, ...
                                n_compartments ...
                            );
                            test_ind(I_4(I_6)) = 0;
                            test_ind(I_4(I_6(I_7))) = 1;
                            I_5 = reshape(test_ind(I_4(I_5)),size(I_3));
                            tetra_ind_aux = I_1(I_2(find(sum(I_5,2)>=4)));
                            domain_labels(tetra_ind_aux) = min(max_compartments, unique_domain_labels(domain_label_ind));
                            tetra_ind_aux = intersect(tetra_ind_aux,tetra_refine_ind);
                            %tetra_refine_ind = setdiff(tetra_refine_ind,tetra_ind_aux);

                        end % if

                    end % while

                    if loop_steps > 0

                        I_3 = 0;

                        while not(isempty(I_3)) && compartment_counter < max_compartments

                            I_1 = find(domain_labels <= compartment_counter);
                            [~,~,I_2] = self.surface_mesh(label_ind(I_1,:));
                            I_3 = accumarray(I_2,ones(size(I_2)),[size(I_1,1) 1]);
                            I_3 = find(I_3 >1);
                            domain_labels(I_1(I_3)) = compartment_counter+1;

                        end % while

                        I_3 = 0;

                        while not(isempty(I_3)) && compartment_counter < max_compartments

                            I_1 = find(domain_labels <= compartment_counter);

                            [~,~,~,~,I_2] = self.surface_mesh(label_ind,[],I_1);

                            I_2 = I_2(find(I_2));

                            I_3 = accumarray(I_2,ones(size(I_2)),[size(domain_labels,1) 1]);

                            I_3 = find(I_3 >= 3);

                            domain_labels(I_3) = compartment_counter;

                        end % while

                    end % if

                end % if

            end % for

        end % for

    end % if

    %**************************************************************

    priority_vec_aux = arrayfun(@(c) c.priority, self.compartments);

    [priority_val priority_ind] = min(priority_vec_aux(domain_labels),[],2);

    priority_ind = sub2ind(size(domain_labels),[1:size(domain_labels,1)]',priority_ind);

    [domain_labels] = domain_labels(priority_ind);

    self.data.domain_labels = domain_labels;

    self.domain_labels = domain_labels;

end % function

%% Local helper functions

function [I] = point_in_compartment(zef, reuna_p, reuna_t, nodes, compartment_counter, n_compartments)

    % point_in_compartment
    %
    % TODO
    %
    % Input:
    %
    % - reuna_p
    %
    % - reuna_t
    %
    % - nodes
    %
    % - compartment_counter
    %
    % - n_compartments
    %
    % Output:
    %
    % - I
    %
    %   A set of indices.

    arguments

        zef zef_as_class.Zef

        reuna_p (:,3) double

        reuna_t (:,3) double { mustBeInteger, mustBePositive }

        nodes (:,3) double

        compartment_counter (1,1) double { mustBeInteger, mustBePositive }

        n_compartments (1,1) double { mustBeInteger, mustBePositive }
    end

    % Init waitbar and an object that destroys it in case of an interruption.

    if zef.use_gui

        wb = waitbar(0, 'Labeling compartment');

        cu_fn = @(h) close(h);

        cu_obj = onCleanup(@() cu_fn(wb));

    else

        wb = zef_as_class.TerminalWaitbar("Labeling compartment", n_compartments);

    end

    meshing_threshold = zef.labeling_threshold;

    max_x = max(reuna_p(:,1));
    min_x = min(reuna_p(:,1));
    max_y = max(reuna_p(:,2));
    min_y = min(reuna_p(:,2));
    max_z = max(reuna_p(:,3));
    min_z = min(reuna_p(:,3));
    max_norm = max(sqrt(sum(reuna_p.^2,2)));
    nodes_norm_vec = sqrt(sum(nodes.^2,2));

    meshing_accuracy = zef.labeling_accuracy;

    if meshing_accuracy < 1

        P.faces = reuna_t;
        P.vertices = reuna_p;
        P = reducepatch(P,meshing_accuracy);
        reuna_t = P.faces;
        reuna_p = P.vertices;

    end

    if meshing_accuracy > 1

        P.faces = reuna_t;
        P.vertices = reuna_p;
        P = reducepatch(P,min(1,min(size(reuna_t,1), meshing_accuracy)/size(reuna_t,1)));
        reuna_t = P.faces;
        reuna_p = P.vertices;

    end

    aux_vec_1 = (1/3)*(reuna_p(reuna_t(:,1),:) + reuna_p(reuna_t(:,2),:) + reuna_p(reuna_t(:,3),:))';
    aux_vec_2 = reuna_p(reuna_t(:,2),:)'-reuna_p(reuna_t(:,1),:)';
    aux_vec_3 = reuna_p(reuna_t(:,3),:)'-reuna_p(reuna_t(:,1),:)';
    aux_vec_4 = cross(aux_vec_2,aux_vec_3)/2;

    ind_vec = zeros(size(nodes,1),1);

    I = find(nodes(:,1) <= max_x & nodes(:,1) >= min_x & nodes(:,2) <= max_y & nodes(:,2) >= min_y & nodes(:,3) <= max_z & nodes(:,3) >= min_z & nodes_norm_vec <= max_norm);

    length_I = length(I);

    tic;
    ones_vec = ones(length(aux_vec_1),1);
    ind_vec_aux = zeros(length_I,1);
    nodes_aux = nodes(I,:)';

    %%%%%%%%%%%%%%%% GPU part %%%%%%%%%%%%%%%%%%%

    use_gpu = zef.use_gpu;
    gpu_num = zef.gpu_count;

    if use_gpu == 1 & zef.gpu_count > 0

    nodes_aux = gpuArray(nodes_aux);
    aux_vec_1 = gpuArray(aux_vec_1);
    aux_vec_4 = gpuArray(aux_vec_4);
    ones_vec = gpuArray(ones_vec);
    ind_vec_aux = gpuArray(ind_vec_aux);

    par_num = zef.parallel_vectors;

    bar_ind = ceil(length_I/(50*par_num));

    i_ind = 0;

    for i = 1 : par_num : length_I

        i_ind = i_ind + 1;
        block_ind = [i: min(i+par_num-1,length_I)];
        aux_vec = nodes_aux(:,block_ind);
        aux_vec = reshape(aux_vec,3,1,length(block_ind));
        aux_vec_5 = aux_vec_1(:,:,ones(1,length(block_ind))) - aux_vec(:,ones_vec,:);
        aux_vec_2 = sum(aux_vec_5.*aux_vec_4(:,:,ones(1,length(block_ind))));
        aux_vec_3 = sqrt(sum(aux_vec_5.*aux_vec_5));
        aux_vec_3 = (aux_vec_3.*aux_vec_3).*aux_vec_3;
        aux_vec_6 = sum(aux_vec_2./aux_vec_3)/(4*pi);
        ind_vec_aux(block_ind) = aux_vec_6(:);
        time_val = toc;

        if zef.use_gui

            if mod(i_ind,bar_ind)==0
                waitbar(compartment_counter/n_compartments, wb,['Labeling compartment ' int2str(compartment_counter) ' of ' int2str(n_compartments) '. Ready: ' datestr(datevec(now+(length_I/i - 1)*time_val/86400)) '.']);
            end

        end

    end % for

    else

    %%%%%%%%%%%%%%%%GPU part%%%%%%%%%%%%%%%%%%%

    par_num = zef.parallel_processes;

    vec_num = zef.parallel_vectors;

    n_restarts = ceil(length_I/(vec_num*par_num));
    bar_ind = ceil(length_I/(50*par_num));
    i_ind = 0;

    sub_ind_aux_1 = round(linspace(1,length_I,n_restarts+1));

    tic;
    sub_cell_aux_2 = cell(0);
    for restart_ind = 1 : n_restarts
    sub_length = sub_ind_aux_1(restart_ind+1)-sub_ind_aux_1(restart_ind);
    par_size = ceil(sub_length/par_num);
    sub_cell_aux_1 = cell(0);
    sub_ind_aux_2 =  [1 : par_size : sub_length];
    parfor j = 1 : length(sub_ind_aux_2)
    i = sub_ind_aux_2(j);
    block_ind = [i: min(i+par_size-1,sub_length)]+sub_ind_aux_1(restart_ind)-1;
    if isequal(block_ind(end),length_I-1)
    block_ind = [block_ind block_ind(end)+1];
    end
    aux_vec = nodes_aux(:,block_ind);
    aux_vec = reshape(aux_vec,3,1,length(block_ind));
    aux_vec_5 = aux_vec_1(:,:,ones(1,length(block_ind))) - aux_vec(:,ones_vec,:);
    aux_vec_2 = sum(aux_vec_5.*aux_vec_4(:,:,ones(1,length(block_ind))));
    aux_vec_3 = sqrt(sum(aux_vec_5.*aux_vec_5));
    aux_vec_3 = (aux_vec_3.*aux_vec_3).*aux_vec_3;
    aux_vec_6 = sum(aux_vec_2./aux_vec_3)/(4*pi);
    sub_cell_aux_1{j} = aux_vec_6(:);
    end

    sub_cell_aux_2{restart_ind} = sub_cell_aux_1;

    time_val = toc;

    if zef.use_gui

        if isequal(mod(restart_ind,ceil(n_restarts/50)),0)
            waitbar(compartment_counter/n_compartments, wb,['Labeling compartment ' int2str(compartment_counter) ' of ' int2str(n_compartments) '. Ready: ' datestr(datevec(now+(n_restarts/restart_ind - 1)*time_val/86400)) '.']);
        end

    end

    end

    ind_inc = 0;
    for restart_ind = 1 : n_restarts
        for i = 1 : length(sub_cell_aux_2{restart_ind})
            length_sub_cell = length(sub_cell_aux_2{restart_ind}{i});
            ind_vec_aux(ind_inc+1:ind_inc+length_sub_cell) = sub_cell_aux_2{restart_ind}{i};
            ind_inc = ind_inc + length_sub_cell;
        end
    end

    %%%%%%%%%%%%%%%%CPU part%%%%%%%%%%%%%%%%%%%

        if zef.use_gui

            waitbar(compartment_counter/n_compartments, wb, ['Labeling compartment ' int2str(compartment_counter) ' of ' int2str(n_compartments) '. Ready: ' datestr(datevec(now)) '.']);

        end

    end

    ind_vec(I) = gather(ind_vec_aux);

    I = find(ind_vec > zef.labeling_threshold);

end
