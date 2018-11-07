
function [multires_dec, multires_ind, multires_count] = make_multires_dec

n_decompositions = evalin('base','zef.inv_multires_n_decompositions');
[n_levels] = evalin('base','zef.inv_multires_n_levels');
[s_ind] = unique(evalin('base','zef.source_interpolation_ind{1}'));

for n_rep = 1 : n_decompositions

source_points = evalin('base','zef.source_positions');

source_points = source_points(s_ind,:);
source_points = source_points';
source_points_aux = source_points;
size_center_points = size(source_points,2); 
center_points = source_points;

if n_rep == 1
h = waitbar(1/size_center_points,['Dec: ' int2str(1) '/' int2str(n_decompositions) ', Level ' int2str(1) '/' int2str(n_levels) '.']); 
end

multires_dec{n_rep}{n_levels} = [1:size_center_points]';
multires_ind{n_rep}{n_levels} = [1:size_center_points]';
multires_count{n_rep}{n_levels} = ones(size_center_points,1);

par_num = evalin('base','zef.parallel_vectors');
multires_sparsity = evalin('base','zef.inv_multires_sparsity');
bar_ind = ceil(size_center_points/(50*par_num));

use_gpu  = evalin('base','zef.use_gpu');
gpu_num  = evalin('base','zef.gpu_num');

for k = 1 : n_levels-1

size_source_points = floor(size_center_points/multires_sparsity^(n_levels - k));
source_interpolation_aux = zeros(size_source_points,1);

aux_ind = randperm(size_center_points);
%aux_ind = sort(aux_ind);
source_points = source_points_aux(:,aux_ind(1:size_source_points));
ones_vec = ones(size(source_points,2),1);

if use_gpu == 1 & gpuDeviceCount > 0
center_points = gpuArray(center_points);
source_points = gpuArray(source_points);
source_interpolation_aux = gpuArray(source_interpolation_aux);
end 

multires_dec{n_rep}{k} = aux_ind(1:size_source_points)';

i_ind = 0;
tic
for i = 1 : par_num : size_center_points

i_ind = i_ind + 1;
block_ind = [i: min(i+par_num-1,size_center_points)];
aux_vec = center_points(:,block_ind);
aux_vec = reshape(aux_vec,3,1,length(block_ind));
norm_vec = sum((source_points(:,:,ones(1,length(block_ind))) - aux_vec(:,ones_vec,:)).^2);
[min_val min_ind] = min(norm_vec,[],2);
source_interpolation_aux(block_ind) = min_ind(:);

time_val = toc;
if i == 1 
waitbar(i/size_center_points,h,['Dec.: ' int2str(n_rep) '/' int2str(n_decompositions) ', Level ' int2str(k) '/' int2str(n_levels) '.']); 
elseif mod(i_ind,bar_ind)==0 
waitbar(i/size_center_points,h,['Dec.: ' int2str(n_rep) '/' int2str(n_decompositions) ', Level ' int2str(k) '/' int2str(n_levels) ', Ready approx. ' datestr(datevec(now+(size_center_points/i - 1)*time_val/86400)) '.']);
end

end

source_interpolation_aux = gather(source_interpolation_aux);
multires_ind{n_rep}{k} = source_interpolation_aux;
[aux_vec, i_a, i_c] = unique(source_interpolation_aux);
multires_count{n_rep}{k} = accumarray(i_c,1);

end

multires_dec{n_rep}{n_levels} = [1:size_center_points]';
multires_ind{n_rep}{n_levels} = [1:size_center_points]';
multires_count{n_rep}{n_levels} = ones(size_center_points,1);

end

close(h)