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

I = zeros(size(nodes,1), 1);
I_2 = [1 : length(I)]';

compartment_counter = 0;
submesh_vec = cell2mat(zef.reuna_submesh_ind);
n_compartments = length(submesh_vec);
unique_domain_labels = unique(domain_labels);
relabeling_pool = zeros(size(domain_labels));
non_associated_labels = zeros(size(domain_labels));  
label_vec = unique_domain_labels;
domain_labels_original = domain_labels;

% for i_labeling =  1 : length(zef.reuna_p)-1
%     for k_labeling =  1 : length(zef.reuna_submesh_ind{i_labeling})
% 
% compartment_counter = compartment_counter + 1;
% domain_label_ind = find(ismember(unique_domain_labels,compartment_counter));
% 
% if domain_label_ind
% 
%                    if k_labeling == 1
%                         reuna_t_aux = zef.reuna_t{i_labeling}(1:zef.reuna_submesh_ind{i_labeling},:);
%                    else
%                         reuna_t_aux = zef.reuna_t{i_labeling}(zef.reuna_submesh_ind{i_labeling}(k_labeling-1)+1: zef.reuna_submesh_ind{i_labeling}(k_labeling),:);
%                    end
% 
%                 tetra_ind_aux = 0;
%                 test_ind = -ones(size(nodes,1),1);
% 
%                 while not(isempty(tetra_ind_aux))
%                     I_1 = find(domain_labels <= compartment_counter);
%                     [I_2] = zef_surface_mesh(tetra(I_1,:));
%                     I_1 = setdiff([1:size(domain_labels,1)]',I_1);
%                     [I_2, ~] = find(ismember(tetra(I_1,:),I_2));
%                     relabeling_pool(I_1(I_2)) = 1;
% 
%                 end
% end
%     end
% end
% 
% 
%    relabeling_pool_ind = find(relabeling_pool);
%                 [nodes_aux, tetra_aux] = zef_get_submesh(nodes, tetra, relabeling_pool_ind);
%                 [label_ind_aux] = zef_solid_angle_labeling(zef, tetra_aux, nodes_aux, h);
%                 domain_labels(relabeling_pool_ind) = zef_choose_domain_labels(zef,label_ind_aux(tetra_aux));
% 
% I = zeros(size(nodes,1), 1);
% I_2 = [1 : length(I)]';
% 
% compartment_counter = 0;
% relabeling_pool = zeros(size(domain_labels));

if zef.extensive_relabeling

tic;
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

                tetra_ind_aux = 0;
                test_ind = -ones(size(nodes,1),1);

                    I_1 = find(domain_labels <= compartment_counter);
                    [I_2] = zef_surface_mesh(tetra(I_1,:));
                    I_1 = setdiff([1:size(domain_labels,1)]',I_1);
                    [I_2, ~] = find(ismember(tetra(I_1,:),I_2));
                    relabeling_pool(I_1(I_2)) = 1;
                    time_val = toc;
                    zef_waitbar(compartment_counter,n_compartments,h,['Extracting refined surfaces ' int2str(compartment_counter) ' of ' int2str(n_compartments) '. Ready: ' datestr(datevec(now+(n_compartments/compartment_counter - 1)*time_val/86400)) '.']);
                   
end
    end
end

         relabeling_pool_ind = find(relabeling_pool);
                [nodes_aux, tetra_aux] = zef_get_submesh(nodes, tetra, relabeling_pool_ind);
                [label_ind_aux] = zef_solid_angle_labeling(zef, tetra_aux, nodes_aux, h);
                domain_labels(relabeling_pool_ind) = zef_choose_domain_labels(zef,label_ind_aux(tetra_aux),use_labeling_priority);

end

    compartment_counter = 0;



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

                tetra_ind_aux = 0;
                test_ind = -ones(size(nodes,1),1);

                while not(isempty(tetra_ind_aux))
                    I_1 = find(domain_labels <= compartment_counter);
                    [I_2] = zef_surface_mesh(tetra(I_1,:));
                    I_1 = setdiff([1:size(domain_labels,1)]',I_1);
                    [I_2, ~] = find(ismember(tetra(I_1,:),I_2));
                    I_3 = tetra(I_1(I_2),:);
                    [I_4,~,I_5] = unique(I_3);
                    I_6 = find(test_ind(I_4) < 0);
                    I_7 = zef_point_in_compartment(zef,zef.reuna_p{i_labeling},reuna_t_aux,nodes(I_4(I_6),:),[compartment_counter n_compartments]);
                    test_ind(I_4(I_6)) = 0;
                    test_ind(I_4(I_6(I_7))) = 1;
                    I_5 = reshape(test_ind(I_4(I_5)),size(I_3));
                    tetra_ind_aux = I_1(I_2(find(sum(I_5,2)>=4)));
                    domain_labels(tetra_ind_aux) = min(n_compartments, unique_domain_labels(domain_label_ind));
                end

                    I_3 = 0;
                    while not(isempty(I_3)) 
                        I_1 = find(domain_labels <= compartment_counter);
                        [~,~,I_2] = zef_surface_mesh(tetra(I_1,:));
                        I_3 = accumarray(I_2,ones(size(I_2)),[size(I_1,1) 1]);
                        I_3 = find(I_3 >1);
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

I_8 = intersect(find(domain_labels >= n_compartments), find(non_associated_labels > 1));
domain_labels(I_8) = domain_labels_original(I_8);
domain_labels = min(n_compartments, domain_labels);

end

%         relabeling_pool_ind = find(relabeling_pool);
 %               [nodes_aux, tetra_aux] = zef_get_submesh(nodes, tetra, relabeling_pool_ind);
  %              [label_ind_aux] = zef_solid_angle_labeling(zef, tetra_aux, nodes_aux, h);
   %             domain_labels(relabeling_pool_ind) = zef_choose_domain_labels(zef,label_ind_aux(tetra_aux));





