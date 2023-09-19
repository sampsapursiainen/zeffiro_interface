function self = label ( self, segmentation, settings, stage )
%
% self = label ( self, segmentation, stage )
%
% Labels the tetrahedra in the given mesh based on the given segmentation.
%

    arguments
        self (1,1) core.TetraMesh
        segmentation (1,1) core.FreeSurferSegmentation
        settings (1,1) core.MeshSettings
        stage (1,1) string { mustBeMember( stage, ["initial","relabeling","adaptive-relabeling"] ) }
    end

    nodes = transpose ( self.nodes ) ;

    tetra = transpose ( self.tetra ) ;

    if stage == "initial"

        domain_labels = initial_labeling ( nodes, stetra, settings, segmentation ) ;

    elseif stage == "relabeling"

        domain_labels = relabeling ( nodes, tetra, settings, segmentation ) ;

    elseif stage == "adaptive-relabeling"

        domain_labels = adaptive_relabeling ( nodes, tetra, settings, segmentation ) ;

    end % if

    self.labels = domain_labels ;

end % function

%% Local helper functions.

function labels = initial_labeling ( nodes, tetra, segmentation, settings )
%
% labels = initial_labeling ( nodes, tetra, segmentation, settings )
%
% Constructs the labels for an initial tetrahedral mesh, that has not yet been
% refined or deformed in any way by mesh post-ptocessing.
%

    arguments
        nodes (:,3) double
        tetra (:,4) uint64
        segmentation (1,1) core.FreeSurferSegmentation
        settings (1,1) core.MeshSettings
    end

    I = zeros(size(nodes,1), 1);

    I_2 = [1 : length(I)]';

    compartment_counter = 0;
    pml_counter = 0;

    for i_labeling = 1 : length(reuna_p)

        for k_labeling = 1 : max(1,length(submesh_cell{i_labeling}))

            compartment_counter = compartment_counter + 1;

            if isempty(submesh_cell{i_labeling})

                reuna_t_aux = reuna_t{i_labeling};

            else

                if k_labeling == 1
                    reuna_t_aux = reuna_t{i_labeling}(1:submesh_cell{i_labeling},:);
                else
                    reuna_t_aux = reuna_t{i_labeling}(submesh_cell{i_labeling}(k_labeling-1)+1: submesh_cell{i_labeling}(k_labeling),:);
                end

            end % if

            if not(isequal(i_labeling,pml_ind_aux))

                I_1 = zef_point_in_compartment(zef,reuna_p{i_labeling},reuna_t_aux,nodes(I_2,:),[compartment_counter n_compartments]);
                I(I_2(I_1)) = compartment_counter;

                I_2 = find(I==0);

            else

                pml_counter = compartment_counter;

                if not(isempty(pml_ind))
                    I(pml_ind) = pml_counter;
                end

            end % if

        end % for

    end % for

    if not(isempty(pml_ind_aux))

        I(find(I==0)) = pml_counter;

    end

    I_1 = find(sum(sign(I(label_ind)),2)>=size(label_ind,2));

    tetra = tetra(I_1,:);

    label_ind = label_ind(I_1,:);

    domain_labels = I(label_ind);

    [unique_vec_1, ~, unique_vec_3] = unique(tetra);

    tetra = reshape(unique_vec_3,size(tetra));

    nodes = nodes(unique_vec_1,:);

    [priority_val priority_ind] = min(priority_vec_aux_segmentation(domain_labels),[],2);

    priority_ind = sub2ind(size(domain_labels),[1:size(domain_labels,1)]',priority_ind);

    [domain_labels] = domain_labels(priority_ind);

end % function

function domain_labels = relabeling ( nodes, tetra, segmentation, settings )
%
% domain_labels = relabeling ( nodes, tetra, segmentation )
%
% Performs labeling on a mesh that has been deformed and/or refined by
% smoothing and/or refinement.
%

    arguments
        nodes (:,3) double
        tetra (:,4) uint64
        segmentation (1,1) core.FreeSurferSegmentation
        settings (1,1) core.MeshSettings
    end

    compartment_counter = 0;
    pml_counter = 0;
    max_compartments = max(domain_labels);

    unique_domain_labels = unique(domain_labels);

    for i_labeling = 1 : length(reuna_p)

        for k_labeling = 1 : max(1,length(submesh_cell{i_labeling}))

            compartment_counter = compartment_counter + 1;

            domain_label_ind = find(ismember(unique_domain_labels,compartment_counter));

            if domain_label_ind

                if compartment_counter == max_compartments
                    break
                end

                if isempty(submesh_cell{i_labeling})

                    reuna_t_aux = reuna_t{i_labeling};

                else

                    if k_labeling == 1
                        reuna_t_aux = reuna_t{i_labeling}(1:submesh_cell{i_labeling},:);
                    else
                        reuna_t_aux = reuna_t{i_labeling}(submesh_cell{i_labeling}(k_labeling-1)+1: submesh_cell{i_labeling}(k_labeling),:);
                    end

                end % if

                tetra_ind_aux = 0;
                test_ind = -ones(size(nodes,1),1);

                while not(isempty(tetra_ind_aux))

                    I_1 = find(domain_labels <= compartment_counter);
                    [I_2] = zef_surface_mesh(label_ind(I_1,:));
                    I_1 = setdiff([1:size(domain_labels,1)]',I_1);
                    [I_2, ~] = find(ismember(label_ind(I_1,:),I_2));
                    I_3 = label_ind(I_1(I_2),:);
                    [I_4,~,I_5] = unique(I_3);
                    I_6 = find(test_ind(I_4) < 0);
                    I_7 = zef_point_in_compartment(zef,reuna_p{i_labeling},reuna_t_aux,nodes(I_4(I_6),:),[compartment_counter n_compartments]);
                    test_ind(I_4(I_6)) = 0;
                    test_ind(I_4(I_6(I_7))) = 1;
                    I_5 = reshape(test_ind(I_4(I_5)),size(I_3));
                    tetra_ind_aux = I_1(I_2(find(sum(I_5,2)>=4)));
                    domain_labels(tetra_ind_aux) = min(max_compartments, unique_domain_labels(domain_label_ind));

                end % while

                if settings.reduce_labeling_outliers

                    I_3 = 0;

                    while not(isempty(I_3)) && compartment_counter < max_compartments

                        I_1 = find(domain_labels <= compartment_counter);
                        [~,~,I_2] = zef_surface_mesh(label_ind(I_1,:));
                        I_3 = accumarray(I_2,ones(size(I_2)),[size(I_1,1) 1]);
                        I_3 = find(I_3 >1);
                        domain_labels(I_1(I_3)) = compartment_counter+1;

                    end % while

                    I_3 = 0;

                    while not(isempty(I_3)) && compartment_counter < max_compartments

                        I_1 = find(domain_labels <= compartment_counter);
                        [~,~,~,~,I_2] = zef_surface_mesh(label_ind,[],I_1);
                        I_2 = I_2(find(I_2));
                        I_3 = accumarray(I_2,ones(size(I_2)),[size(domain_labels,1) 1]);
                        I_3 = find(I_3 >= 3);
                        domain_labels(I_3) = compartment_counter;

                    end % while

                end % if

            end % if

        end % for

    end % for

    [priority_val priority_ind] = min(priority_vec_aux(domain_labels),[],2);

    priority_ind = sub2ind(size(domain_labels),[1:size(domain_labels,1)]',priority_ind);

    [domain_labels] = domain_labels(priority_ind);

end % function

function labels = adaptive_relabeling ( nodes, tetra, segmentation, settings )
%
% labels = adaptive_relabeling ( nodes, tetra, segmentation, settings )
%
% Performs labeling on an adaptively refined / smoothed mesh.
%
    arguments
        nodes (:,3) double
        tetra (:,4) uint64
        segmentation (1,1) core.FreeSurferSegmentation
        settings (1,1) core.MeshSettings
    end

    compartment_counter = 0;
    pml_counter = 0;
    max_compartments = max(domain_labels);

    unique_domain_labels = unique(domain_labels);

    for i_labeling = 1 : length(reuna_p)

        for k_labeling = 1 : max(1,length(submesh_cell{i_labeling}))

            compartment_counter = compartment_counter + 1;

            domain_label_ind = find(ismember(unique_domain_labels,compartment_counter));

            if domain_label_ind

                if compartment_counter == max_compartments
                    break
                end

                if isempty(submesh_cell{i_labeling})
                    reuna_t_aux = reuna_t{i_labeling};
                else
                    if k_labeling == 1
                        reuna_t_aux = reuna_t{i_labeling}(1:submesh_cell{i_labeling},:);
                    else
                        reuna_t_aux = reuna_t{i_labeling}(submesh_cell{i_labeling}(k_labeling-1)+1: submesh_cell{i_labeling}(k_labeling),:);
                    end
                end

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
                        [I_2] = zef_surface_mesh(label_ind(I_1,:));
                        I_1 = setdiff([1:size(domain_labels,1)]',I_1);
                        [I_2, ~] = find(ismember(label_ind(I_1,:),I_2));
                        I_3 = label_ind(I_1(I_2),:);
                        [I_4,~,I_5] = unique(I_3);
                        I_6 = find(test_ind(I_4) < 0);
                        I_7 = zef_point_in_compartment(zef,reuna_p{i_labeling},reuna_t_aux,nodes(I_4(I_6),:),[compartment_counter n_compartments]);
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
                        [~,~,I_2] = zef_surface_mesh(label_ind(I_1,:));
                        I_3 = accumarray(I_2,ones(size(I_2)),[size(I_1,1) 1]);
                        I_3 = find(I_3 >1);
                        domain_labels(I_1(I_3)) = compartment_counter+1;

                    end % while

                    I_3 = 0;

                    while not(isempty(I_3)) && compartment_counter < max_compartments

                        I_1 = find(domain_labels <= compartment_counter);
                        [~,~,~,~,I_2] = zef_surface_mesh(label_ind,[],I_1);
                        I_2 = I_2(find(I_2));
                        I_3 = accumarray(I_2,ones(size(I_2)),[size(domain_labels,1) 1]);
                        I_3 = find(I_3 >= 3);
                        domain_labels(I_3) = compartment_counter;

                    end % while

                end % if

            end % if

        end % for

    end % for

    [priority_val priority_ind] = min(priority_vec_aux(domain_labels),[],2);

    priority_ind = sub2ind(size(domain_labels),[1:size(domain_labels,1)]',priority_ind);

    [domain_labels] = domain_labels(priority_ind);

end % function
