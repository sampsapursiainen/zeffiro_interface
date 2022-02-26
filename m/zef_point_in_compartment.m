%Copyright © 2018- Sampsa Pursiainen & ZI Development Team
%See: https://github.com/sampsapursiainen/zeffiro_interface
function [I] = zef_point_in_compartment(reuna_p,reuna_t,nodes,varargin)

if evalin('base','exist(''zef'')')
if evalin('base','isfield(zef,''meshing_threshold'')')
meshing_threshold = evalin('base','zef.meshing_threshold');
else
meshing_threshold = 0.5;
end
else
meshing_threshold = 0.5;
end

compartment_info = [];
if not(isempty(varargin))
compartment_info = varargin{1};
if length(varargin) > 1
meshing_threshold = varargin{2};
end
end

max_x = max(reuna_p(:,1));
min_x = min(reuna_p(:,1));
max_y = max(reuna_p(:,2));
min_y = min(reuna_p(:,2));
max_z = max(reuna_p(:,3));
min_z = min(reuna_p(:,3));
max_norm = max(sqrt(sum(reuna_p.^2,2)));
nodes_norm_vec = sqrt(sum(nodes.^2,2));

meshing_accuracy = evalin('base','zef.meshing_accuracy');

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

%%%%%%%%%%%%%%%%GPU part%%%%%%%%%%%%%%%%%%%

use_gpu = evalin('base','zef.use_gpu');
gpu_num = evalin('base','zef.gpu_num');

if use_gpu == 1 & gpuDeviceCount > 0
nodes_aux = gpuArray(nodes_aux);
aux_vec_1 = gpuArray(aux_vec_1);
aux_vec_4 = gpuArray(aux_vec_4);
ones_vec = gpuArray(ones_vec);
ind_vec_aux = gpuArray(ind_vec_aux);

par_num = evalin('base','zef.parallel_vectors');
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

if not(isempty(compartment_info))
if mod(i_ind,bar_ind)==0
waitbar([i/length_I compartment_info(1)/compartment_info(2)],evalin('caller','h'),['Labeling compartment ' int2str(compartment_info(1)) ' of ' int2str(compartment_info(2)) '. Ready: ' datestr(datevec(now+(length_I/i - 1)*time_val/86400)) '.']);
end
end
end

else

%%%%%%%%%%%%%%%%GPU part%%%%%%%%%%%%%%%%%%%

%%%%%%%%%%%%%%%%CPU part%%%%%%%%%%%%%%%%%%%

par_num = evalin('base','zef.parallel_processes');
vec_num = evalin('base','zef.parallel_vectors');
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

if not(isempty(compartment_info))
    if isequal(mod(restart_ind,ceil(n_restarts/50)),0)
waitbar([restart_ind/n_restarts compartment_info(1)/compartment_info(2)],evalin('caller','h'),['Labeling compartment ' int2str(compartment_info(1)) ' of ' int2str(compartment_info(2)) '. Ready: ' datestr(datevec(now+(n_restarts/restart_ind - 1)*time_val/86400)) '.']);
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

if not(isempty(compartment_info))
waitbar([1 compartment_info(1)/compartment_info(2)],evalin('caller','h'),['Labeling compartment ' int2str(compartment_info(1)) ' of ' int2str(compartment_info(2)) '. Ready: ' datestr(datevec(now)) '.']);
end

end

ind_vec(I) = gather(ind_vec_aux);
I = find(ind_vec > evalin('base','zef.meshing_threshold'));

end

