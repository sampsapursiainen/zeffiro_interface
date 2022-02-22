if refinement_flag == 1
tetra_aux = tetra;
end

if evalin('base','zef.refinement_on');

  if refinement_flag == 1
surface_refinement_on = evalin('base','zef.refinement_surface_on');
elseif refinement_flag == 2
    surface_refinement_on = evalin('base','zef.refinement_surface_on_2');
end

    if surface_refinement_on

 length_waitbar = 11;
waitbar(0,h,'Surface refinement.');

J_c = [];

I = [];
if refinement_flag == 1
refinement_type = evalin('base','zef.refinement_surface_compartments');
elseif refinement_flag == 2
    refinement_type = evalin('base','zef.refinement_surface_compartments_2');
end

if length(n_surface_refinement) > 1
    refinement_type = refinement_type(j_surface_refinement);
end


if ismember(1,refinement_type)
if refinement_flag == 1
I = find(ismember(domain_labels,zef_compartment_to_subcompartment(aux_brain_ind(:))));
elseif refinement_flag == 2
I = brain_ind(:);
    end
end
refinement_type = zef_compartment_to_subcompartment(setdiff(refinement_type,1) - 1);

 I = [I ; find(ismember(domain_labels,refinement_type(:)))];

tetra = tetra_aux;

tetra = tetra(I,:);

 ind_m = [ 2 4 3 ;
           1 3 4 ;
           1 4 2 ;
           1 2 3 ];

tetra_sort = [tetra(:,[2 4 3]) ones(size(tetra,1),1) [1:size(tetra,1)]';
              tetra(:,[1 3 4]) 2*ones(size(tetra,1),1) [1:size(tetra,1)]';
              tetra(:,[1 4 2]) 3*ones(size(tetra,1),1) [1:size(tetra,1)]';
              tetra(:,[1 2 3]) 4*ones(size(tetra,1),1) [1:size(tetra,1)]';];
tetra_sort(:,1:3) = sort(tetra_sort(:,1:3),2);
tetra_sort = sortrows(tetra_sort,[1 2 3]);
tetra_ind = zeros(size(tetra_sort,1),1);
I = find(sum(abs(tetra_sort(2:end,1:3)-tetra_sort(1:end-1,1:3)),2)==0);
tetra_ind(I) = 1;
tetra_ind(I+1) = 1;
I = find(tetra_ind == 0);
tetra_ind = sub2ind(size(tetra),repmat(tetra_sort(I,5),1,3),ind_m(tetra_sort(I,4),:));
surface_triangles = [ tetra(tetra_ind)];
J_c = [J_c ;  unique(surface_triangles)];
clear tetra_sort;


tetra = tetra_aux;

waitbar(1/length_waitbar,h,'Surface refinement.');

tetra_vec = sum(ismember(tetra,J_c),2);
J = find(tetra_vec);
ind_aux = unique(tetra(J,:));
J = find(sum(ismember(tetra,ind_aux),2)==4);
ind_aux = unique(tetra(J,:));
ind_aux = ismember(tetra,ind_aux);
sum_aux = sum(ind_aux,2);

J_2 = find(sum_aux==2);
J_3 = find(sum_aux==3);

clear ind_aux sum_aux tetra_vec;
waitbar(2/length_waitbar,h,'Surface refinement.');

J_aux = [J; J_2; J_3];
aux_vec = [ones(size(J)); 2*ones(size(J_2)); 3*ones(size(J_3))];

edge_ind = zeros(6*length(J_aux),6);
aux_ind = [1 2 ; 1 3 ; 1 4 ; 2 3 ; 2 4 ; 3 4];
for i = 1 : 6
edge_ind((i-1)*length(J_aux) + 1:i*length(J_aux),[1 2 3 5 6]) = [tetra(J_aux, aux_ind(i,:)) J_aux aux_vec i*ones(length(J_aux),1)];
end
clear tetra_ind_aux;
edge_ind(:,1:2) = sort(edge_ind(:,1:2),2);
edge_ind = sortrows(edge_ind,[1 2 5]);
clear edge_ind_2 nodes_new;
new_node_ind = 0;
current_edge = [0 0];

waitbar(3/length_waitbar,h,'Surface refinement.');

for i = 1 : size(edge_ind,1)
if edge_ind(i,5) == 1
if edge_ind(i,1:2) == current_edge
edge_ind(i,4) = new_node_ind;
else
new_node_ind = new_node_ind + 1;
current_edge = edge_ind(i,1:2);
edge_ind(i,4) = new_node_ind;
end
else
if edge_ind(i,1:2) == current_edge
edge_ind(i,4) = new_node_ind;
end
end
end

waitbar(4/length_waitbar,h,'Surface refinement.');

[edge_val_aux edge_ind_2] = unique(edge_ind(:,4));
clear edge_val_aux;
edge_ind_2 = edge_ind_2(2:end,:);
nodes_new = (1/2)*(nodes(edge_ind(edge_ind_2,1),:) + nodes(edge_ind(edge_ind_2,2),:));
size_nodes = size(nodes,1);
nodes = [nodes ; nodes_new];
clear edge_ind_2 nodes_new;

waitbar(5/length_waitbar,h,'Surface refinement.');

I =find(edge_ind(:,4));
edge_ind(I,4) = edge_ind(I,4) + size_nodes;
edge_ind = sortrows(edge_ind,[5 3 6]);
edge_mat = reshape(edge_ind(:,4),6,length(J_aux))';
clear edge_ind I;

waitbar(6/length_waitbar,h,'Surface refinement.');

t_ind_1 = [  1     5     6     7
     7     9     6    10
     6     8     3    10
     2     9     8     5
     4     7    10     9
     5     6     9     8
     6     9     8    10
     7     9     5     6 ];

t_ind_2 = [tetra(J,:) edge_mat(1:length(J),:)];

tetra_new = [];

clear J_aux;
domain_labels_new = [];

for i = 1 : 7

tetra_new = [ tetra_new ; t_ind_2(:,t_ind_1(i,:)) ];
domain_labels_new = [domain_labels_new ; domain_labels(J,:)];

end

tetra(J,:) = [ t_ind_2(:,t_ind_1(8,:)) ];

clear t_ind_1 t_ind_2;

waitbar(7/length_waitbar,h,'Surface refinement.');

tetra = [tetra ; tetra_new ];
domain_labels = [domain_labels ; (domain_labels_new)];

waitbar(8/length_waitbar,h,'Surface refinement.');

ind_aux = length(J) + [1 : length(J_2)]';
tetra_new = [];
domain_labels_new = [];
for i = 1 : 6
    switch i
        case 1
            nodes_aux_vec = [1 2 3 4];
        case 2
            nodes_aux_vec = [1 3 2 4];
        case 3
            nodes_aux_vec = [1 4 2 3];
        case 4
            nodes_aux_vec = [2 3 1 4];
        case 5
            nodes_aux_vec = [2 4 1 3];
        case 6
            nodes_aux_vec = [3 4 1 2];
    end


    I = find(edge_mat(ind_aux,i));

    tetra_new = [tetra_new ; edge_mat(ind_aux(I),i) tetra(J_2(I),nodes_aux_vec(:,1)) tetra(J_2(I),nodes_aux_vec(:,3)) tetra(J_2(I),nodes_aux_vec(:,4))];
    domain_labels_new = [domain_labels_new ; domain_labels(J_2(I),:)];
    tetra(J_2(I),:) = [edge_mat(ind_aux(I),i) tetra(J_2(I),nodes_aux_vec(:,2)) tetra(J_2(I),nodes_aux_vec(:,3)) tetra(J_2(I),nodes_aux_vec(:,4))];

end



tetra = [tetra ; tetra_new];
domain_labels = [domain_labels ; (domain_labels_new)];

waitbar(9/length_waitbar,h,'Surface refinement.');

ind_aux = length(J) + length(J_2) + [1 : length(J_3)]';
tetra_new = [];
domain_labels_new = [];
for i = 1 : 4
    switch i
        case 1
            nodes_ind_aux = [1 2 3 4];
            col_ind_aux = [1 4 2];
        case 2
            nodes_ind_aux = [1 2 4 3];
            col_ind_aux = [1 5 3];
        case 3
            nodes_ind_aux = [1 3 4 2];
            col_ind_aux = [2 6 3];
        case 4
            nodes_ind_aux = [2 3 4 1];
            col_ind_aux = [4 6 5];
    end


    I = find(sum(not(edge_mat(ind_aux,col_ind_aux)),2)==0);
    if length(I) > 0
    tetra_new = [tetra_new ; tetra(J_3(I),nodes_ind_aux(:,1))  edge_mat(ind_aux(I),col_ind_aux(1)) edge_mat(ind_aux(I),col_ind_aux(3)) tetra(J_3(I),nodes_ind_aux(:,4))];
    tetra_new = [tetra_new ; tetra(J_3(I),nodes_ind_aux(:,2))  edge_mat(ind_aux(I),col_ind_aux(2)) edge_mat(ind_aux(I),col_ind_aux(1)) tetra(J_3(I),nodes_ind_aux(:,4))];
    tetra_new = [tetra_new ; tetra(J_3(I),nodes_ind_aux(:,3))  edge_mat(ind_aux(I),col_ind_aux(2)) edge_mat(ind_aux(I),col_ind_aux(3)) tetra(J_3(I),nodes_ind_aux(:,4))];
    domain_labels_new = [domain_labels_new ; repmat(domain_labels(J_3(I),:),3,1)];
    tetra(J_3(I),:) = [edge_mat(ind_aux(I),col_ind_aux(1))  edge_mat(ind_aux(I),col_ind_aux(2)) edge_mat(ind_aux(I),col_ind_aux(3)) tetra(J_3(I),nodes_ind_aux(:,4))];
    end

    I = find(sum(not(edge_mat(ind_aux,col_ind_aux)),2)==1);
    if length(I)>0
        for j_ind = 1 : length(I)
    [zero_ind_aux, ~] = find(edge_mat(ind_aux(I(j_ind)),col_ind_aux)' == 0);
        switch zero_ind_aux
        case 1
            col_ind_aux_2 = col_ind_aux([2 3]);
            k_ind = 3;
            i_ind = [1 2];
        case 2
            col_ind_aux_2 = col_ind_aux([1 3]);
            k_ind = 1;
            i_ind = [3 2];
        case 3
            col_ind_aux_2 = col_ind_aux([2 1]);
            k_ind = 2;
            i_ind = [1 3];
        end

 if tetra(J_3(I(j_ind)),nodes_ind_aux(i_ind(1))) > tetra(J_3(I(j_ind)),nodes_ind_aux(i_ind(2)))
 i_ind = fliplr(i_ind);
 col_ind_aux_2 = fliplr(col_ind_aux_2);
 end
 tetra_new = [tetra_new ; tetra(J_3(I(j_ind)),nodes_ind_aux(k_ind))  edge_mat(ind_aux(I(j_ind)),col_ind_aux_2(1)) edge_mat(ind_aux(I(j_ind)),col_ind_aux_2(2)) tetra(J_3(I(j_ind)),nodes_ind_aux(4))];
    tetra_new = [tetra_new ; tetra(J_3(I(j_ind)),nodes_ind_aux(i_ind(1)))  edge_mat(ind_aux(I(j_ind)),col_ind_aux_2(2)) edge_mat(ind_aux(I(j_ind)),col_ind_aux_2(1)) tetra(J_3(I(j_ind)),nodes_ind_aux(4))];
 domain_labels_new = [domain_labels_new ; repmat(domain_labels(J_3(I(j_ind)),:),2,1)];
    tetra(J_3(I(j_ind)),:) = [tetra(J_3(I(j_ind)),nodes_ind_aux(i_ind(1))) tetra(J_3(I(j_ind)),nodes_ind_aux(i_ind(2)))  edge_mat(ind_aux(I(j_ind)),col_ind_aux_2(1)) tetra(J_3(I(j_ind)),nodes_ind_aux(4))];
        end
    end


end

tetra = [tetra ; tetra_new];
domain_labels = [domain_labels ; (domain_labels_new)];

clear tetra_new_ind tetra_new_out;

waitbar(10/length_waitbar,h,'Surface refinement.');

tilavuus = volume(nodes, tetrahedra);

I = find(tilavuus > 0);
tetra(I,:) = tetra(I,[2 1 3 4]);
clear tilavuus I;

if refinement_flag == 2
brain_ind = [];
for k = 1 : length(compartment_tags)
if evalin('base',['zef.' compartment_tags{k} '_sources'])>0
if not(aux_compartment_ind(k)==0) && not(evalin('base',['zef.' compartment_tags{k} '_sources'])==3)
[brain_ind] = [brain_ind ; find(domain_labels==aux_compartment_ind(k))];
end
end
end

if sum(aux_compartment_ind) == 0
brain_ind = find(domain_labels);
end

sigma = sigma_vec(domain_labels);

end


waitbar(1,h,'Surface refinement.');

tetra_vec = sum(ismember(tetra,J_c),2);
J = find(tetra_vec);
J_c = unique(tetra(J,:));
tetra_vec = sum(ismember(tetra,J_c),2);
if refinement_flag == 2
non_source_ind = find(tetra_vec > 2);
non_source_ind = intersect(brain_ind, non_source_ind);
end

   if refinement_flag == 2
       [nodes,optimizer_flag] = zef_fix_negatives(nodes, tetra);
if optimizer_flag == 1
       [tetra, optimizer_flag] = zef_tetra_turn(nodes, tetra, thresh_val);
end
end

tetra_aux = tetra;

    end

end
