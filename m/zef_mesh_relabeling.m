function   [domain_labels, distance_vec, label_vec] = zef_mesh_relabeling(zef, tetra, nodes, domain_labels, distance_vec, use_labeling_priority, h)

if nargin < 5
    priority_mode = zef.priority_mode; 
end

if nargin < 6
h = zef_waitbar(0,'Mesh re-labeling.')
close_waitbar = true;
else
close_waitbar = false;
end

I = zeros(size(nodes,1), 1);
I_2 = [1 : length(I)]';

compartment_counter = 0;
submesh_vec = cell2mat(zef.reuna_submesh_ind);
n_compartments = length(submesh_vec);
unique_domain_labels = 1:n_compartments;
non_associated_labels = zeros(size(domain_labels));  
label_vec = unique_domain_labels;
domain_labels_original = domain_labels;

if use_labeling_priority
    tetra_labels = domain_labels(:,[1 1 1 1]);
end

    test_ind = -ones(size(nodes,1),1);

for i_labeling =  1 : length(zef.reuna_p)
    for k_labeling =  1 : length(zef.reuna_submesh_ind{i_labeling})

compartment_counter = compartment_counter + 1;
if use_labeling_priority
tetra_labels_aux = zeros(size(tetra_labels,1),1);
end

        if not(isequal(compartment_counter,n_compartments))

                   if k_labeling == 1
                        reuna_t_aux = zef.reuna_t{i_labeling}(1:zef.reuna_submesh_ind{i_labeling}(k_labeling),:);
                   else
                        reuna_t_aux = zef.reuna_t{i_labeling}(zef.reuna_submesh_ind{i_labeling}(k_labeling-1)+1: zef.reuna_submesh_ind{i_labeling}(k_labeling),:);
                   end

if zef.extensive_relabeling

                tetra_ind_aux = 0;
                test_ind(test_ind==0) = -1;

 while not(isempty(tetra_ind_aux))
     
                    I_1 = find(domain_labels <= compartment_counter);
                    [I_2] = zef_surface_mesh(tetra(I_1,:));
                    [I_2, ~] = find(ismember(tetra(I_1,:),I_2));
                    I_3 = tetra(I_1(I_2),:);
                    [I_4,~,I_5] = unique(I_3);
                    I_6 = find(test_ind(I_4) < 0);
                    [I_7,distance_vec_aux] = zef_point_in_compartment(zef,zef.reuna_p{i_labeling},reuna_t_aux,nodes(I_4(I_6),:),[compartment_counter n_compartments]);
                    test_ind(I_4(I_6)) = 0;
                    test_ind(I_4(I_6(I_7))) = 1;
                    distance_vec(I_4(I_6(I_7))) = distance_vec_aux;
                    if use_labeling_priority
                        I_8 = find(ismember(tetra,I_4(I_6(I_7))));
                        tetra_labels(I_8) = compartment_counter; 
                        tetra_labels_aux(mod(I_8-1,size(tetra_labels,1))+1) = 1;
                    end
                    I_5 = reshape(test_ind(I_4(I_5)),size(I_3));
                    tetra_ind_aux = I_1(I_2(find(sum(I_5,2) < 4)));
                    domain_labels(tetra_ind_aux) = min(n_compartments, compartment_counter + 1);
                    if not(use_labeling_priority)
                    non_associated_labels(tetra_ind_aux) = non_associated_labels(tetra_ind_aux) + 1;
                    end
                    end
end

  tetra_ind_aux = 0;
 test_ind(test_ind==0) = -1;

                while not(isempty(tetra_ind_aux))
                    I_1 = find(domain_labels <= compartment_counter);
                    [I_2] = zef_surface_mesh(tetra(I_1,:));
                    I_1 = setdiff([1:size(domain_labels,1)]',I_1);
                    [I_2, ~] = find(ismember(tetra(I_1,:),I_2));
                    I_3 = tetra(I_1(I_2),:);
                    [I_4,~,I_5] = unique(I_3);
                    I_6 = find(test_ind(I_4) < 0);
                    [I_7,distance_vec_aux] = zef_point_in_compartment(zef,zef.reuna_p{i_labeling},reuna_t_aux,nodes(I_4(I_6),:),[compartment_counter n_compartments]);
                    test_ind(I_4(I_6)) = 0;
                    test_ind(I_4(I_6(I_7))) = 1;
                    distance_vec(I_4(I_6(I_7))) = distance_vec_aux;
                    I_5 = reshape(test_ind(I_4(I_5)),size(I_3));
                    tetra_ind_aux = I_1(I_2(find(sum(I_5,2) >= 4)));
                    if use_labeling_priority
                        I_8 = find(ismember(tetra,I_4(I_6(I_7))));
                        tetra_labels(I_8) = compartment_counter;
                        tetra_labels_aux(mod(I_8-1,size(tetra_labels,1))+1) = 1;
                    end
                    domain_labels(tetra_ind_aux) = min(n_compartments, compartment_counter);
                end 

                    if use_labeling_priority
                        domain_labels = zef_choose_domain_labels(zef, tetra_labels, use_labeling_priority); 
                    else

                    
                    I_3 = 0;
                    while not(isempty(I_3)) 
                        I_1 = find(domain_labels <= compartment_counter);
                        if not(isempty(I_1))
                        [~,~,I_2] = zef_surface_mesh(tetra(I_1,:));
                        I_3 = accumarray(I_2,ones(size(I_2)),[size(I_1,1) 1]);
                        I_3 = find(I_3 >1);
                        non_associated_labels(I_1(I_3)) = non_associated_labels(I_1(I_3)) + 1; 
                        domain_labels(I_1(I_3)) = compartment_counter + 1;
                        else
                            I_3 = [];
                        end

                    end

                    I_3 = 0;
                    while not(isempty(I_3)) && compartment_counter < n_compartments
                        I_1 = find(domain_labels <= compartment_counter);
                        if not(isempty(I_1))
                        [~,~,~,~,I_2] = zef_surface_mesh(tetra,[],I_1);
                        I_2 = I_2(find(I_2));
                        I_3 = accumarray(I_2,ones(size(I_2)),[size(domain_labels,1) 1]);
                        I_3 = find(I_3 >= 3);
                        domain_labels(I_3) = compartment_counter;
                        else 
                            I_3 = [];
                        end
                    end 
                    end
    end
                end

end

if not(use_labeling_priority)
I_8 = intersect(find(domain_labels >= n_compartments), find(non_associated_labels > 1));
domain_labels(I_8) = domain_labels_original(I_8);
end
domain_labels = min(n_compartments, domain_labels);

end
