%Copyright © 2018- Sampsa Pursiainen & ZI Development Team
%See: https://github.com/sampsapursiainen/zeffiro_interface
function [multires_dec, multires_ind, multires_count] = make_multires_dec(varargin)

if not(isempty(varargin))
n_decompositions = varargin{1};
n_levels = varargin{2};
multires_sparsity = varargin{3};
else
n_decompositions = evalin('base','zef.inv_multires_n_decompositions');
n_levels = evalin('base','zef.inv_multires_n_levels');
multires_sparsity = evalin('base','zef.inv_multires_sparsity');
end
s_ind = unique(evalin('base','zef.source_interpolation_ind{1}'));

for n_rep = 1 : n_decompositions

source_points = evalin('base','zef.source_positions');

source_points = source_points(s_ind,:);
source_points = source_points';
source_points_aux = source_points;
size_center_points = size(source_points,2);
center_points = source_points;

if n_rep == 1
h = waitbar([0 0],['Dec: ' int2str(1) '/' int2str(n_decompositions) ', Level ' int2str(1) '/' int2str(n_levels) '.']);
end

multires_dec{n_rep}{n_levels} = [1:size_center_points]';
multires_ind{n_rep}{n_levels} = [1:size_center_points]';
multires_count{n_rep}{n_levels} = ones(size_center_points,1);

par_num = evalin('base','zef.parallel_vectors');
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

multires_dec{n_rep}{k} = aux_ind(1:size_source_points)';

MdlKDT = KDTreeSearcher(source_points');
source_interpolation_aux = knnsearch(MdlKDT,center_points');

waitbar([k/n_levels n_rep/n_decompositions],h,['Dec.: ' int2str(n_rep) '/' int2str(n_decompositions) ', Level ' int2str(k) '/' int2str(n_levels) '.']);

multires_ind{n_rep}{k} = source_interpolation_aux;
[aux_vec, i_a, i_c] = unique(source_interpolation_aux);
multires_count{n_rep}{k} = accumarray(i_c,1);

end

multires_dec{n_rep}{n_levels} = [1:size_center_points]';
multires_ind{n_rep}{n_levels} = [1:size_center_points]';
multires_count{n_rep}{n_levels} = ones(size_center_points,1);

end

close(h)