function   [domain_labels, label_vec] = zef_mesh_relabeling(zef, tetra, nodes, domain_labels, use_labeling_priority, h)

if nargin < 5
    priority_mode = zef.priority_mode; 
end

if nargin < 6
h = zef_waitbar(0,'Mesh re-labeling.')
close_waitbar = true;
else
close_waitbar = false;
end

submesh_vec = cell2mat(zef.reuna_submesh_ind);
n_compartments = length(submesh_vec);
unique_domain_labels = unique(domain_labels);
label_vec = unique_domain_labels;
tetra_labels = domain_labels(:,[1 1 1 1]);
n_tetra = size(tetra_labels,1);

    compartment_counter = 0;

     test_ind = -ones(size(nodes,1),1);

for i_labeling =  1 : length(zef.reuna_p)-1
    for k_labeling =  1 : length(zef.reuna_submesh_ind{i_labeling})

compartment_counter = compartment_counter + 1;
domain_label_ind = find(ismember(unique_domain_labels,compartment_counter));

if domain_label_ind

                   if k_labeling == 1
                        reuna_t_aux = zef.reuna_t{i_labeling}(1:zef.reuna_submesh_ind{i_labeling},:);
                   else
                        reuna_t_aux = zef.reuna_t{i_labeling}(zef.reuna_submesh_ind{i_labeling}(k_labeling-1)+1: zef.reuna_submesh_ind{i_labeling}(k_labeling),:);
                   end
               
                    I_1 = find(domain_labels <= compartment_counter);
                    [I_2] = zef_surface_mesh(tetra(I_1,:));
                    [I_2,~] = find(ismember(tetra,I_2));
                    [I_1] = unique(tetra(I_2,:));
                    I_2 = find(test_ind(I_1) < 0);
                    I_3 = zef_point_in_compartment(zef,zef.reuna_p{i_labeling},reuna_t_aux,nodes(I_1(I_2),:),[compartment_counter n_compartments]);
                    test_ind(I_1(I_2)) = 0;
                    test_ind(I_1(I_2(I_3))) = 1;
                    [I_2, I_3] = find(ismember(tetra,I_1(I_2(I_3))));
                    tetra_labels(I_2 + n_tetra*(I_3-1)) = compartment_counter;
                    I_2 = unique(I_2);
                    domain_labels(I_2) = zef_choose_domain_labels(zef,tetra_labels(I_2,:),use_labeling_priority);

                    I_3 = 0; 
                    while not(isempty(I_3))
                        I_1 = find(domain_labels <= compartment_counter);
                        loop_ind_aux
                        [~,~,I_2] = zef_surface_mesh(tetra(I_1,:));
                        I_3 = accumarray(I_2,ones(size(I_2)),[size(I_1,1) 1]);
                        I_3 = find(I_3 >1);
%                        tetra_labels_aux = tetra_labels(I_1(I_3),:);
% domain_labels_aux = zef_choose_domain_labels(zef,tetra_labels_aux,use_labeling_priority);
% label_ind_aux = find(isequal(domain_labels_aux,compartment_counter));
% loop_ind_aux = 1;
% while and(loop_ind_aux < 4, not(isempty(label_ind_aux)))
% loop_ind_aux = loop_ind_aux + 1;
% domain_labels_aux(label_ind_aux) = zef_choose_domain_labels(zef,tetra_labels_aux(label_ind_aux,:),use_labeling_priority,loop_ind_aux);
% label_ind_aux = find(isequal(domain_labels_aux,compartment_counter));
% end
% domain_labels(I_1(I_3)) = domain_labels_aux;
non_associated_labels(I_1(I_3)) = non_associated_labels(I_1(I_3)) + 1; 
                        domain_labels(I_1(I_3)) = compartment_counter + 1;
                    end

                    I_3 = 0;
                    while not(isempty(I_3)) && compartment_counter < n_compartments
                        I_1 = find(domain_labels <= compartment_counter);
                        [~,~,~,~,I_2] = zef_surface_mesh(tetra,[],I_1);
                        I_2 = I_2(find(I_2));
                        I_3 = accumarray(I_2,ones(size(I_2)),[size(domain_labels,1) 1]);
                        I_3 = find(I_3 >= 3);
                        domain_labels(I_3) = compartment_counter;
                    end


                end

           
                end

end

I_1 = intersect(find(domain_labels >= n_compartments), find(non_associated_labels > 1));
domain_labels(I_1) = domain_labels_original(I_1);
domain_labels = min(n_compartments, domain_labels);

if close_waitbar
    close(h);
end

end




