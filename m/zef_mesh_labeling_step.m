label_ind = uint32(label_ind);

if isequal(labeling_flag,1)

    %***********************************************************
    %Initialize labeling.
    %***********************************************************

    [node_labels,distance_vec] = zef_solid_angle_labeling(zef, label_ind, nodes, h);

    I = find(sum(sign(node_labels(label_ind)),2)>=size(label_ind,2));
    tetra = tetra(I,:);
    label_ind = label_ind(I,:);
    domain_labels = node_labels(label_ind);
 
    if zef.distance_smoothing_on
    [nodes] = zef_distance_smoothing(tetra, nodes, distance_vec, zef.distance_smoothing_exp, zef.smoothing_strength,zef.smoothing_steps_dist);
    end

    [unique_vec_1, ~, unique_vec_3] = unique(tetra);
    tetra = reshape(unique_vec_3,size(tetra));
    nodes = nodes(unique_vec_1,:);

        if zef.priority_mode == 1
            use_labeling_priority = 0;
        elseif zef.priority_mode >= 2
            use_labeling_priority = 1;
        end

    domain_labels = zef_choose_domain_labels(zef,domain_labels,use_labeling_priority);


elseif isequal(labeling_flag,2)
    %**************************************************************
    %Re-labeling.
    %**************************************************************

        if zef.priority_mode <= 2
            use_labeling_priority = 0;
        elseif zef.priority_mode == 3
            use_labeling_priority = 1;
        end

[domain_labels, distance_vec] = zef_mesh_relabeling(zef, tetra, nodes, domain_labels, distance_vec, use_labeling_priority, h);
 
if zef.distance_smoothing_on
    [nodes] = zef_distance_smoothing(tetra, nodes, distance_vec, zef.distance_smoothing_exp, zef.smoothing_strength, zef.smoothing_steps_dist);
end

elseif isequal(labeling_flag,3)
    %**************************************************************
    %Re-labeling.
    %**************************************************************

use_labeling_priority = 0;
[domain_labels, distance_vec] = zef_mesh_relabeling(zef, tetra, nodes, domain_labels, distance_vec, use_labeling_priority, h);
 
if zef.distance_smoothing_on
    [nodes] = zef_distance_smoothing(tetra, nodes, distance_vec, zef.distance_smoothing_exp, zef.smoothing_strength,zef.smoothing_steps_dist);
end

end



%     %**************************************************************
% elseif isequal(labeling_flag,3)
%     %**************************************************************
%     %Re-labeling (adaptive).
%     %**************************************************************
%     pml_counter = 0;
%     max_comparetments = max(domain_labels);
% compartment_counter = 0; 
% 
%     unique_domain_labels = unique(domain_labels);
% 
%     for loop_ind_aux_1 = 1 : length(submesh_ind_1)
% 
%  compartment_counter = compartment_counter + 1;
% 
% if and(compartment_counter >= 1, compartment_counter <= max_compartments)
% 
%             i_labeling = submesh_ind_1(compartment_counter);
%             k_labeling = submesh_ind_2(compartment_counter);
% 
%             domain_label_ind = find(ismember(unique_domain_labels,compartment_counter));
% 
%             if domain_label_ind
% 
% 
%                 if isempty(submesh_cell{i_labeling})
%                     reuna_t_aux = zef.reuna_t{i_labeling};
%                 else
%                     if k_labeling == 1
%                         reuna_t_aux = zef.reuna_t{i_labeling}(1:submesh_cell{i_labeling},:);
%                     else
%                         reuna_t_aux = zef.reuna_t{i_labeling}(submesh_cell{i_labeling}(k_labeling-1)+1: submesh_cell{i_labeling}(k_labeling),:);
%                     end
%                 end
% 
%                 tetra_ind_aux = 0;
%                 test_ind = -ones(size(nodes,1),1);
%                 loop_steps = 0;
% 
%                 while not(isempty(tetra_ind_aux))
% 
%                     I_1_0 = find(domain_labels <= compartment_counter);
%                     I_1 = intersect(I_1_0,tetra_refine_ind);
%                     if isempty(I_1)
%                         tetra_ind_aux = [];
%                     else
%                         loop_steps = loop_steps + 1;
%                         [I_2] = zef_surface_mesh(label_ind(I_1,:));
%                         I_1 = setdiff([1:size(domain_labels,1)]',I_1);
%                         [I_2, ~] = find(ismember(label_ind(I_1,:),I_2));
%                         I_3 = label_ind(I_1(I_2),:);
%                         [I_4,~,I_5] = unique(I_3);
%                         I_6 = find(test_ind(I_4) < 0);
%                         I_7 = zef_point_in_compartment(zef,zef.reuna_p{i_labeling},reuna_t_aux,nodes(I_4(I_6),:),[compartment_counter n_compartments]);
%                         test_ind(I_4(I_6)) = 0;
%                         test_ind(I_4(I_6(I_7))) = 1;
%                         I_5 = reshape(test_ind(I_4(I_5)),size(I_3));
%                         tetra_ind_aux = I_1(I_2(find(sum(I_5,2)>=4)));
%                         domain_labels(tetra_ind_aux) = min(max_compartments, unique_domain_labels(domain_label_ind));
%                         tetra_ind_aux = intersect(tetra_ind_aux,tetra_refine_ind);
%                         %tetra_refine_ind = setdiff(tetra_refine_ind,tetra_ind_aux);
%                     end
%                 end
% 
%                 if loop_steps > 0
%                     I_3 = 0;
%                     while not(isempty(I_3)) && compartment_counter < max_compartments
%                         I_1 = find(domain_labels <= compartment_counter);
%                         [~,~,I_2] = zef_surface_mesh(label_ind(I_1,:));
%                         I_3 = accumarray(I_2,ones(size(I_2)),[size(I_1,1) 1]);
%                         I_3 = find(I_3 >1);
%  domain_labels(I_1(I_3)) = compartment_counter + 1; 
%                     end
% 
%                     I_3 = 0;
%                     while not(isempty(I_3)) && compartment_counter < max_compartments
%                         I_1 = find(domain_labels <= compartment_counter);
%                         [~,~,~,~,I_2] = zef_surface_mesh(label_ind,[],I_1);
%                         I_2 = I_2(find(I_2));
%                         I_3 = accumarray(I_2,ones(size(I_2)),[size(domain_labels,1) 1]);
%                         I_3 = find(I_3 >= 3);
%                         domain_labels(I_3) = compartment_counter;
%                     end
%                 end
% 
%             end
%         end
%     end
% 
%                 end
%     end

%**************************************************************

%elseif ismember(labeling_flag,[2 3])
%    [priority_val priority_ind] = min(priority_vec_aux(domain_labels),[],2);
%    priority_ind = sub2ind(size(domain_labels),[1:size(domain_labels,1)]',priority_ind);
%    [domain_labels] = domain_labels(priority_ind);
%end
