function nodes = zef_inflate_surfaces(nodes,tetra,domain_labels)

waitbar_opened = 0;
if evalin('caller','exist(''h'')')
    if evalin('caller','isvalid(h)')
h = evalin('caller','h');
    else
        h = waitbar([0 0],'Inflating.');
        waitbar_opened = 1;
    end
else
      h = waitbar([0 0],'Inflating.');
      waitbar_opened = 1;
end

inflation_strength = evalin('base','zef.fem_mesh_inflation_strength');
reuna_t = evalin('base','zef.reuna_t');
reuna_p = evalin('base','zef.reuna_p');
reuna_type = evalin('base','zef.reuna_type');

if isequal(reuna_type{end,1},-1)
compartment_length = length(reuna_p)-1;
else
compartment_length = length(reuna_p);
end

for compartment_counter = 1 : compartment_length

interior_ind = find(domain_labels<=compartment_counter);
[~,~,~,~,~,~,node_list] = zef_surface_mesh(tetra,[],interior_ind);

if not(isempty(node_list))

tri_ref = reuna_t{compartment_counter};
nodes_tri_ref = reuna_p{compartment_counter};

n_nearest_neighbors = 25;
ones_vec_nearest = ones(n_nearest_neighbors,1);
center_points = (1/3)*(nodes_tri_ref(tri_ref(:,1),:)+nodes_tri_ref(tri_ref(:,2),:)+nodes_tri_ref(tri_ref(:,3),:));
n_nearest_neighbors = min(n_nearest_neighbors,size(center_points,1));
MdlKDT = KDTreeSearcher(center_points);
nearest_neighbor_ind = knnsearch(MdlKDT,gather(nodes(node_list(:,1),:)),'K',n_nearest_neighbors);

waitbar([0 compartment_counter/length(reuna_p)], h, 'Inflating.');

length_node_list = size(node_list,1);
par_num = evalin('base','zef.parallel_processes');
vec_num = evalin('base','zef.parallel_vectors');
n_restarts = ceil(length_node_list/(vec_num*par_num));
bar_ind = ceil(length_node_list/(50*par_num));
i_ind = 0;

sub_ind_aux_1 = round(linspace(1,length_node_list,n_restarts+1));

tic;
nodes_cell = cell(0);
nodes_ind_cell = cell(0);
for restart_ind = 1 : n_restarts

sub_length = sub_ind_aux_1(restart_ind+1)-sub_ind_aux_1(restart_ind);
par_size = ceil(sub_length/par_num);
sub_cell_aux_1 = cell(0);
sub_ind_aux_2 =  [1 : par_size : sub_length];
nodes_cell_aux = cell(0);
for j = 1 : length(sub_ind_aux_2)
i = sub_ind_aux_2(j);
block_ind = [i: min(i+par_size-1,sub_length)]+sub_ind_aux_1(restart_ind)-1;
if isequal(block_ind(end),length_node_list-1)
block_ind = [block_ind block_ind(end)+1];
end

nodes_cell_aux{j} = zeros(length(block_ind),3);
nodes_ind_cell_aux{j} = zeros(length(block_ind),1);

for k = 1 : length(block_ind)

p_ind = node_list(block_ind(k),1);

%if not(isempty(p_tetra))
    I = [];
    test_ind = 0;
    p = nodes(p_ind,:);
  %  [~, sort_ind] = min(sqrt(sum((nodes(p_tetra,:) - p).^2,2)));
 %   [~, sort_ind] = sort(sqrt(sum((nodes(p_tetra,:) - p).^2,2)));
 %while isempty(I) && test_ind < length(p_tetra)
 test_ind = test_ind + 1;

p_min = node_list(block_ind(k),2);
vec_1_aux = nodes(p_min,:) - p;

vec_1 = vec_1_aux(ones_vec_nearest,:);
d_vec = p(ones_vec_nearest,:)  - nodes_tri_ref(tri_ref(nearest_neighbor_ind(block_ind(k),:),1),:);
vec_2 = nodes_tri_ref(tri_ref(nearest_neighbor_ind(block_ind(k),:),2),:) - nodes_tri_ref(tri_ref(nearest_neighbor_ind(block_ind(k),:),1),:);
vec_3 = nodes_tri_ref(tri_ref(nearest_neighbor_ind(block_ind(k),:),3),:) - nodes_tri_ref(tri_ref(nearest_neighbor_ind(block_ind(k),:),1),:);

[lambda_1, lambda_2, lambda_3] = zef_3by3_solver(vec_1,vec_2,vec_3,d_vec);
I = find(lambda_1<0 & lambda_1 > -1 & lambda_2 >0 & lambda_2<1 & lambda_3>0 & lambda_3 <1);

if not(isempty(I))

lambda_1 = inflation_strength*min(abs(lambda_1(I)));
nodes_cell_aux{j}(k,:) = p + lambda_1.*vec_1_aux;
nodes_ind_cell_aux{j}(k,:) = p_ind;

end
%end
%end
end
end

nodes_cell{restart_ind} = nodes_cell_aux;
nodes_ind_cell{restart_ind} = nodes_ind_cell_aux;

time_val = toc;

    if isequal(mod(restart_ind,ceil(n_restarts/50)),0)
waitbar([restart_ind/n_restarts compartment_counter/length(reuna_p)],h,['Inflating compartment ' int2str(compartment_counter) ' of ' int2str(length(reuna_p)) '. Ready: ' datestr(datevec(now+(n_restarts/restart_ind - 1)*time_val/86400)) '.']);
    end

end

for restart_ind = 1 : n_restarts
for i = 1 : length(nodes_cell{restart_ind})
nodes_ind_aux = find(nodes_ind_cell{restart_ind}{i});
nodes(nodes_ind_cell{restart_ind}{i}(nodes_ind_aux),:) = nodes_cell{restart_ind}{i}(nodes_ind_aux,:);
end
end

%%%%%%%% CPU Version %%%%%%%%

end
end

if waitbar_opened
close(h);
end

end

