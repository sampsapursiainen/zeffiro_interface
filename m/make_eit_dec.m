
function [eit_ind,eit_count] = make_eit_dec(nodes,tetrahedra,brain_ind,source_ind)

center_points = (nodes(tetrahedra(:,1),:) + nodes(tetrahedra(:,2),:) + nodes(tetrahedra(:,3),:)+ nodes(tetrahedra(:,4),:))/4;
center_points = center_points';
source_points = center_points(:,source_ind);
center_points = center_points(:,brain_ind);

size_center_points = size(center_points,2); 
size_source_points = size(center_points,2); 

par_num = evalin('base','zef.parallel_vectors');
bar_ind = ceil(size_center_points/(50*par_num));

use_gpu  = evalin('base','zef.use_gpu');
gpu_num  = evalin('base','zef.gpu_num');

h = waitbar(1/size_center_points,['Source decomposition.']); 

source_interpolation_aux = zeros(size_center_points,1);
ones_vec = ones(size(source_points,2),1);

if use_gpu == 1 & gpuDeviceCount > 0
center_points = gpuArray(center_points);
source_points = gpuArray(source_points);
source_interpolation_aux = gpuArray(source_interpolation_aux);
end 

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
waitbar(i/size_center_points,h,['Source decomposition.']); 
elseif mod(i_ind,bar_ind)==0 
waitbar(i/size_center_points,h,['Source decomposition. Ready approx. ' datestr(datevec(now+(size_center_points/i - 1)*time_val/86400)) '.']);
end

end

source_interpolation_aux = gather(source_interpolation_aux);
eit_ind = source_interpolation_aux;
[aux_vec, i_a, i_c] = unique(source_interpolation_aux);
eit_count = accumarray(i_c,1);

close(h);

end



